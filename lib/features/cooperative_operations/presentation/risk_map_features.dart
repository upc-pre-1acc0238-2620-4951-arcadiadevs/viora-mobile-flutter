import 'dart:convert';
import 'dart:ui';

import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';

/// The color of each risk on the map and in the dots of the lists. Grey is never green.
Color riskColor(PlotRisk risk) => switch (risk) {
      PlotRisk.critical => VioraColors.terracotta500,
      PlotRisk.moderate => VioraColors.harvest400,
      PlotRisk.optimal => VioraColors.green700,
      PlotRisk.noData => VioraColors.neutral500,
    };

String _hex(Color color) {
  final value = color.toARGB32() & 0xFFFFFF;
  return '#${value.toRadixString(16).padLeft(6, '0')}';
}

/// The plots as GeoJSON for the map: each feature carries how it is painted. Plots outside the
/// chosen sector fade; the chosen plot is the strongest; plots without data get a dashed line.
String plotsFeatureCollection(List<RiskPlot> plots, {String? selectedPlotId, String? selectedSectorId}) {
  final features = [
    for (final plot in plots)
      if (plot.outline.isNotEmpty) _feature(plot, selectedPlotId, selectedSectorId),
  ];
  return jsonEncode({'type': 'FeatureCollection', 'features': features});
}

Map<String, Object?> _feature(RiskPlot plot, String? selectedPlotId, String? selectedSectorId) {
  final selected = plot.id == selectedPlotId;
  final faded = selectedSectorId != null && plot.sectorId != selectedSectorId;
  final color = _hex(riskColor(plot.risk));
  return {
    'type': 'Feature',
    'properties': {
      'id': plot.id,
      'fillColor': color,
      'fillOpacity': selected ? 0.8 : (faded ? 0.15 : 0.5),
      'lineColor': selected ? _hex(VioraColors.neutral0) : color,
      'lineOpacity': faded ? 0.3 : 1.0,
      'lineWidth': selected ? 3.0 : 2.0,
      'dashed': plot.risk == PlotRisk.noData && !selected,
    },
    'geometry': {
      'type': 'Polygon',
      'coordinates': [
        [
          for (final corner in [...plot.outline, plot.outline.first]) [corner.longitude, corner.latitude],
        ],
      ],
    },
  };
}

/// Whether a place projected by the map falls on the map. Mapbox answers a corner for what is out
/// of view, so a marker there must be hidden, not drawn at that corner.
bool isOnMap(Offset pixel, Size map) =>
    pixel.dx > 0 && pixel.dy > 0 && pixel.dx < map.width && pixel.dy < map.height;

/// The plot under a touch; the last one drawn wins, as it's the one on top.
RiskPlot? plotAt(List<RiskPlot> plots, double longitude, double latitude) {
  for (final plot in plots.reversed) {
    if (plot.contains(longitude, latitude)) return plot;
  }
  return null;
}
