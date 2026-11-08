import 'dart:async';

import 'package:flutter/material.dart' hide Visibility;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/presentation/risk_map_features.dart';

/// A Flutter widget pinned to a place of the map: a sector's label, "Tú".
class RiskMapMarker {
  const RiskMapMarker({required this.key, required this.position, required this.child});

  final String key;
  final GeoCoordinate position;
  final Widget child;
}

/// The Mapbox map of G20: the polygons of the plots painted by risk, and [markers] over them.
/// It draws no sector boundaries, because there are none: a sector is a label of each plot.
class RiskMapCanvas extends StatefulWidget {
  const RiskMapCanvas({
    super.key,
    required this.plots,
    required this.markers,
    required this.selectedPlotId,
    required this.selectedSectorId,
    required this.focus,
    required this.focusKey,
    required this.padding,
    required this.onTapPlot,
  });

  final List<RiskPlot> plots;
  final List<RiskMapMarker> markers;
  final String? selectedPlotId;
  final String? selectedSectorId;

  /// The places the camera fits, again each time [focusKey] changes.
  final List<GeoCoordinate> focus;
  final String focusKey;

  /// What the floating controls and the panel cover, so the focus isn't hidden under them.
  final EdgeInsets padding;

  /// Null when the touch fell on the bare map.
  final ValueChanged<String?> onTapPlot;

  @override
  State<RiskMapCanvas> createState() => _RiskMapCanvasState();
}

class _RiskMapCanvasState extends State<RiskMapCanvas> {
  static const _sourceId = 'risk-plots';
  static const _fillLayerId = 'risk-plots-fill';
  static const _lineLayerId = 'risk-plots-line';
  static const _dashedLayerId = 'risk-plots-dashed';

  /// Tacna, for the moment before there is anything to fit.
  static final _valley = CameraViewportState(center: Point(coordinates: Position(-70.25, -18.05)), zoom: 11);

  MapboxMap? _map;
  bool _styleReady = false;
  Map<String, Offset> _markerOffsets = const {};
  bool _projecting = false;
  bool _projectAgain = false;

  @override
  void didUpdateWidget(RiskMapCanvas old) {
    super.didUpdateWidget(old);
    if (old.plots != widget.plots ||
        old.selectedPlotId != widget.selectedPlotId ||
        old.selectedSectorId != widget.selectedSectorId) {
      unawaited(_updatePlots());
    }
    if (old.focusKey != widget.focusKey || old.padding != widget.padding) unawaited(_fitFocus());
    if (old.markers != widget.markers) unawaited(_projectMarkers());
  }

  String get _features => plotsFeatureCollection(
        widget.plots,
        selectedPlotId: widget.selectedPlotId,
        selectedSectorId: widget.selectedSectorId,
      );

  Future<void> _onMapCreated(MapboxMap map) async {
    _map = map;
    map.addInteraction(TapInteraction.onMap(_onTap));
    await map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    await map.compass.updateSettings(CompassSettings(enabled: false));
    // The list of plots reads as a plan: no tilting.
    await map.gestures.updateSettings(GesturesSettings(pitchEnabled: false, rotateEnabled: false));
  }

  void _onTap(MapContentGestureContext context) {
    final position = context.point.coordinates;
    final plot = plotAt(widget.plots, position.lng.toDouble(), position.lat.toDouble());
    widget.onTapPlot(plot?.id);
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData _) async {
    final style = _map;
    if (style == null) return;
    await style.addSource(GeoJsonSource(id: _sourceId, data: _features));
    await style.addLayer(FillLayer(
      id: _fillLayerId,
      sourceId: _sourceId,
      fillColorExpression: const ['to-color', ['get', 'fillColor']],
      fillOpacityExpression: const ['get', 'fillOpacity'],
    ));
    final line = <Object>['to-color', ['get', 'lineColor']];
    await style.addLayer(LineLayer(
      id: _lineLayerId,
      sourceId: _sourceId,
      filter: const ['!', ['get', 'dashed']],
      lineColorExpression: line,
      lineOpacityExpression: const ['get', 'lineOpacity'],
      lineWidthExpression: const ['get', 'lineWidth'],
    ));
    await style.addLayer(LineLayer(
      id: _dashedLayerId,
      sourceId: _sourceId,
      filter: const ['get', 'dashed'],
      lineColorExpression: line,
      lineOpacityExpression: const ['get', 'lineOpacity'],
      lineWidth: 1.5,
      lineDasharray: const [3, 2],
    ));
    _styleReady = true;
    await _updatePlots();
    await _fitFocus(animated: false);
    await _projectMarkers();
  }

  Future<void> _updatePlots() async {
    if (!_styleReady) return;
    final source = await _map?.getSource(_sourceId);
    if (source is GeoJsonSource) await source.updateGeoJSON(_features);
  }

  Future<void> _fitFocus({bool animated = true}) async {
    final map = _map;
    if (map == null || !_styleReady || widget.focus.isEmpty) return;
    final padding = widget.padding;
    final camera = await map.cameraForCoordinatesPadding(
      [for (final place in widget.focus) Point(coordinates: Position(place.longitude, place.latitude))],
      CameraOptions(),
      MbxEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right),
      16,
      null,
    );
    if (animated) {
      await map.easeTo(camera, MapAnimationOptions(duration: 450));
    } else {
      await map.setCamera(camera);
    }
    await _projectMarkers();
  }

  /// Asks where each marker falls on the screen, one question at a time however fast the camera moves.
  Future<void> _projectMarkers() async {
    final map = _map;
    if (map == null || !_styleReady) return;
    if (_projecting) {
      _projectAgain = true;
      return;
    }
    _projecting = true;
    try {
      do {
        _projectAgain = false;
        final markers = widget.markers;
        final pixels = await map.pixelsForCoordinates([
          for (final marker in markers)
            Point(coordinates: Position(marker.position.longitude, marker.position.latitude)),
        ]);
        if (!mounted) return;
        final size = context.size ?? Size.zero;
        setState(() {
          _markerOffsets = {
            for (var i = 0; i < markers.length; i++)
              if (isOnMap(Offset(pixels[i].x, pixels[i].y), size)) markers[i].key: Offset(pixels[i].x, pixels[i].y),
          };
        });
      } while (_projectAgain);
    } finally {
      _projecting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MapWidget(
            // The same imagery as the producer's app: the manager recognizes the plots on the ground.
            styleUri: MapboxStyles.SATELLITE_STREETS,
            viewport: _valley,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
            onCameraChangeListener: (_) => unawaited(_projectMarkers()),
          ),
        ),
        for (final marker in widget.markers)
          if (_markerOffsets[marker.key] case final Offset offset)
            Positioned(
              key: ValueKey(marker.key),
              left: offset.dx,
              top: offset.dy,
              child: FractionalTranslation(translation: const Offset(-0.5, -0.5), child: marker.child),
            ),
      ],
    );
  }
}
