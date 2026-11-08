import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plot_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plots_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/has_active_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/risk_plot_dto.dart';
import 'package:viora/features/cooperative_operations/presentation/risk_map_features.dart';
import 'package:viora/features/cooperative_operations/presentation/state/risk_map_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/state/risk_plot_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/state/sector_detail_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/risk_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/risk_plot_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/sector_detail_page.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/risk_map_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/sector_detail_view_model.dart';

final _now = DateTime.utc(2026, 11, 8, 12);

const _square = [
  GeoCoordinate(-70.25, -18.05),
  GeoCoordinate(-70.24, -18.05),
  GeoCoordinate(-70.24, -18.06),
  GeoCoordinate(-70.25, -18.06),
];

RiskPlot _plot(
  String id, {
  PlotRisk risk = PlotRisk.optimal,
  String? sectorId = 's1',
  String? sectorName = 'La Yarada Baja',
  SectorPlacement placement = SectorPlacement.assigned,
  String producer = 'Teodoro Mamani',
  double? distanceKm,
  List<PlotRiskReason> reasons = const [],
  List<GeoCoordinate> outline = _square,
  double? overload,
  String? proposed,
}) =>
    RiskPlot(
      id: id,
      name: 'Lote $id',
      producerName: producer,
      areaHa: 2.5,
      center: outline.isEmpty ? null : outline.first,
      outline: outline,
      sectorId: sectorId,
      sectorName: sectorName,
      placement: placement,
      proposedSectorName: proposed,
      risk: risk,
      reasons: reasons,
      overloadPercent: overload,
      distanceKm: distanceKm,
      evaluatedAt: _now.subtract(const Duration(minutes: 5)),
    );

const _overload = PlotRiskReason(type: RiskReason.overload, value: 43);
final _frost = PlotRiskReason(type: RiskReason.frostForecast, value: 1.2, date: DateTime(2026, 11, 9));

RiskPlotDetail _detail({
  double? fruits = 2,
  double? target = 1.4,
  double? percent = 30,
  PlotRisk risk = PlotRisk.critical,
  DateTime? thinnedOn,
  String? phone = '+51952184337',
}) =>
    RiskPlotDetail(
      id: 'p1',
      name: 'La Yarada 02',
      producerName: 'Teodoro Mamani',
      producerPhone: phone,
      areaHa: 2.5,
      sectorName: 'La Yarada Baja',
      risk: risk,
      reasons: risk == PlotRisk.critical ? const [_overload] : const [],
      overloadPercent: fruits == null ? null : 43,
      sampledTrees: fruits == null ? 0 : 5,
      lastSampledOn: fruits == null ? null : DateTime(2026, 10, 29),
      fruitsPerShoot: fruits,
      targetFruitsPerShoot: target,
      percentageToRemove: percent,
      windowOpensOn: DateTime(2026, 11, 3),
      windowClosesOn: DateTime(2026, 11, 20),
      thinnedOn: thinnedOn,
      kgPerHaAfterThinning: 8200,
      bearingIndex: 0.45,
      evaluatedAt: _now,
    );

class _FakeRisk implements RiskRepository {
  List<RiskPlot> plotsToReturn = const [];
  CooperativeFailure? plotsFailure;
  GeoCoordinate? lastOrigin;
  bool alerts = false;

  @override
  Future<List<RiskPlot>> plots({GeoCoordinate? origin}) async {
    lastOrigin = origin;
    final failure = plotsFailure;
    if (failure != null) throw failure;
    return plotsToReturn;
  }

  @override
  Future<RiskPlotDetail> plot(String id) async => _detail();

  @override
  Future<bool> hasActiveAlerts() async => alerts;
}

class _FakeLocation implements LocationRepository {
  bool permission = false;
  LocationChoice? saved;
  bool grants = true;
  final List<bool> asked = [];
  ManagerLocation? found = const ManagerLocation(coordinate: GeoCoordinate(-70.2, -18.0), accuracyMeters: 5);

  @override
  ManagerLocation? lastKnown;

  @override
  Future<bool> hasPermission() async => permission;

  @override
  Future<bool> requestPermission({required bool openSettings}) async {
    asked.add(openSettings);
    return permission = grants;
  }

  @override
  Future<ManagerLocation?> current() async => lastKnown = found;

  @override
  Future<LocationChoice?> choice() async => saved;

  @override
  Future<void> saveChoice(LocationChoice choice) async => saved = choice;
}

RiskMapViewModel _viewModel(_FakeRisk risk, _FakeLocation location) => RiskMapViewModel(
      getPlots: GetRiskPlotsUseCase(repository: risk),
      getPlot: GetRiskPlotUseCase(repository: risk),
      hasActiveAlerts: HasActiveSectorAlertsUseCase(repository: risk),
      location: location,
    );

Widget _app(Widget home) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

Widget _riskPage(RiskMapUiState state, {void Function(String)? onScope, void Function(String)? onPlot}) =>
    _app(RiskPageContent(
      state: state,
      now: _now,
      onRetry: () {},
      onShowList: (_) {},
      onToggleSector: (_) {},
      onRetryGps: () {},
      onOpenAlerts: () {},
      onOpenScope: onScope ?? (_) {},
      onOpenPlot: onPlot ?? (_) {},
      map: (markers, focus, focusKey) => Stack(
        children: [
          for (final marker in markers) Positioned(left: 0, top: 0, child: marker.child),
        ],
      ),
    ));

void _phone(WidgetTester tester, {double height = 900}) {
  tester.view.physicalSize = Size(360 * 3, height * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  group('reading the server', () {
    test('a polygon loses its closing corner; anything else reads as no outline', () {
      final outline = parseOutline(jsonEncode({
        'type': 'Polygon',
        'coordinates': [
          [
            [-70.25, -18.05],
            [-70.24, -18.05],
            [-70.24, -18.06],
            [-70.25, -18.05],
          ],
        ],
      }));

      expect(outline, hasLength(3));
      expect(outline.first.longitude, -70.25);
      expect(outline.first.latitude, -18.05);
      expect(parseOutline(null), isEmpty);
      expect(parseOutline('not json'), isEmpty);
      expect(parseOutline('{"type":"Point","coordinates":[1,2]}'), isEmpty);
      expect(parseOutline('{"type":"Polygon","coordinates":[]}'), isEmpty);
    });

    test('a day of the server stays that day on the phone', () {
      final detail = RiskPlotDetailDto.fromJson({
        'plotId': 'p1',
        'windowClosesOn': '2026-11-20',
      }).toDomain();

      expect(detail.windowClosesOn?.toLocal().day, 20);
    });

    test('a plot without a sector or a polygon still reads', () {
      final plot = RiskPlotDto.fromJson({
        'plotId': 'p1',
        'plotName': 'Lote',
        'riskLevel': 'NO_DATA',
        'sectorStatus': 'NONE',
        'reasons': <Object>[],
      }).toDomain();

      expect(plot.outline, isEmpty);
      expect(plot.center, isNull);
      expect(plot.risk, PlotRisk.noData);
      expect(plot.placement, SectorPlacement.none);
    });
  });

  group('the traffic light', () {
    test('a group takes the color of its most urgent plot; grey goes before green', () {
      expect(RiskGroup([_plot('a'), _plot('b', risk: PlotRisk.critical)]).level, PlotRisk.critical);
      expect(RiskGroup([_plot('a'), _plot('b', risk: PlotRisk.moderate)]).level, PlotRisk.moderate);
      expect(RiskGroup([_plot('a'), _plot('b', risk: PlotRisk.noData)]).level, PlotRisk.noData);
      expect(RiskGroup([_plot('a')]).level, PlotRisk.optimal);
      expect(const RiskGroup([]).level, PlotRisk.noData);
    });

    test('sectors go from the most urgent to the least; the picker goes by name', () {
      final territory = RiskTerritory([
        _plot('a', sectorId: 's1', sectorName: 'Los Palos'),
        _plot('b', sectorId: 's2', sectorName: 'Sama', risk: PlotRisk.noData),
        _plot('c', sectorId: 's3', sectorName: 'Magollo', risk: PlotRisk.critical),
        _plot('d', sectorId: 's4', sectorName: 'La Yarada', risk: PlotRisk.critical),
        _plot('e', sectorId: 's4', sectorName: 'La Yarada', risk: PlotRisk.critical),
      ]);

      expect(territory.sectorsByUrgency.map((s) => s.name), ['La Yarada', 'Magollo', 'Sama', 'Los Palos']);
      expect(territory.sectorsByName.map((s) => s.name), ['La Yarada', 'Los Palos', 'Magollo', 'Sama']);
    });

    test('plots waiting for a sector or without one stay out of the sectors, not out of the territory', () {
      final territory = RiskTerritory([
        _plot('a'),
        _plot('b', sectorId: null, sectorName: null, placement: SectorPlacement.pending, proposed: 'Cerro'),
        _plot('c', sectorId: null, sectorName: null, placement: SectorPlacement.none),
      ]);

      expect(territory.sectorsByName, hasLength(1));
      expect(territory.pending.total, 1);
      expect(territory.unassigned.total, 1);
      expect(territory.valley.total, 3);
    });

    test('near means within 5 km; without a distance it is not near', () {
      final territory = RiskTerritory([
        _plot('a', distanceKm: 1),
        _plot('b', distanceKm: 5),
        _plot('c', distanceKm: 5.1),
        _plot('d'),
      ]);

      expect(territory.nearby.plots.map((p) => p.id), ['a', 'b']);
    });

    test('one outing names critical plots within 1.5 km, the closest first and each member once', () {
      final group = RiskGroup([
        _plot('a', risk: PlotRisk.critical, producer: 'Elena Quispe', distanceKm: 1.2),
        _plot('b', risk: PlotRisk.critical, producer: 'Teodoro Mamani', distanceKm: 0.9),
        _plot('c', risk: PlotRisk.critical, producer: 'Teodoro Mamani', distanceKm: 1.0),
        _plot('d', risk: PlotRisk.critical, producer: 'Rosa Condori', distanceKm: 2),
        _plot('e', producer: 'Hugo Ticona', distanceKm: 0.1),
      ]);

      expect(group.criticalWithinOneOuting.map((p) => p.producerName), ['Teodoro Mamani', 'Elena Quispe']);
    });

    test('the coldest frost leads', () {
      final colder = PlotRiskReason(type: RiskReason.frostForecast, value: 0.5, date: DateTime(2026, 11, 9));
      final group = RiskGroup([_plot('a', reasons: [_frost]), _plot('b', reasons: [colder])]);

      expect(group.coldestFrost?.value, 0.5);
      expect(group.withFrost, 2);
    });
  });

  group('the map', () {
    test('a place out of view gets no marker, whatever corner the map answers', () {
      const map = Size(400, 800);

      expect(isOnMap(const Offset(200, 300), map), isTrue);
      expect(isOnMap(Offset.zero, map), isFalse);
      expect(isOnMap(const Offset(-1, -1), map), isFalse);
      expect(isOnMap(const Offset(400, 800), map), isFalse);
      expect(isOnMap(const Offset(500, 300), map), isFalse);
    });

    test('a touch finds the plot under it, and only that one', () {
      final plots = [_plot('a')];

      expect(plotAt(plots, -70.245, -18.055)?.id, 'a');
      expect(plotAt(plots, -70.30, -18.055), isNull);
      expect(plotAt([_plot('none', outline: const [])], -70.245, -18.055), isNull);
    });

    Map<String, dynamic> properties(String json, String id) {
      final features = (jsonDecode(json) as Map<String, dynamic>)['features'] as List<dynamic>;
      final feature = features.cast<Map<String, dynamic>>().firstWhere(
            (f) => (f['properties'] as Map<String, dynamic>)['id'] == id,
          );
      return feature['properties'] as Map<String, dynamic>;
    }

    test('each risk has its color; no data is grey and dashed, never green', () {
      final json = plotsFeatureCollection([
        _plot('red', risk: PlotRisk.critical),
        _plot('amber', risk: PlotRisk.moderate),
        _plot('green'),
        _plot('grey', risk: PlotRisk.noData),
      ]);

      expect(properties(json, 'red')['fillColor'], '#c15a2e');
      expect(properties(json, 'amber')['fillColor'], '#cda100');
      expect(properties(json, 'green')['fillColor'], '#485a4f');
      expect(properties(json, 'grey')['fillColor'], '#7d7a75');
      expect(properties(json, 'grey')['dashed'], isTrue);
      expect(properties(json, 'green')['dashed'], isFalse);
    });

    test('filtering by sector fades the others; the chosen plot stands out', () {
      final json = plotsFeatureCollection(
        [_plot('in', sectorId: 's1'), _plot('out', sectorId: 's2')],
        selectedSectorId: 's1',
      );
      final chosen = plotsFeatureCollection([_plot('in'), _plot('other')], selectedPlotId: 'in');

      expect(properties(json, 'in')['fillOpacity'], 0.5);
      expect(properties(json, 'out')['fillOpacity'], 0.15);
      expect(properties(chosen, 'in')['lineWidth'], 3.0);
      expect(properties(chosen, 'other')['lineWidth'], 2.0);
    });

    test('a plot without a polygon is not drawn, and the ring closes', () {
      final json = plotsFeatureCollection([_plot('a'), _plot('none', outline: const [])]);
      final features = (jsonDecode(json) as Map<String, dynamic>)['features'] as List<dynamic>;
      final geometry = (features.single as Map<String, dynamic>)['geometry'] as Map<String, dynamic>;
      final ring = (geometry['coordinates'] as List<dynamic>).first as List<dynamic>;

      expect(ring, hasLength(5));
      expect(ring.first, ring.last);
    });
  });

  group('G20 · the view model', () {
    late _FakeRisk risk;
    late _FakeLocation location;

    setUp(() {
      risk = _FakeRisk()..plotsToReturn = [_plot('a', risk: PlotRisk.critical)];
      location = _FakeLocation();
    });

    test('the first opening explains the GPS and reads the valley without it', () async {
      final viewModel = _viewModel(risk, location);
      await viewModel.start();

      expect(viewModel.state.explainLocation, isTrue);
      expect(viewModel.state.gpsOff, isFalse);
      expect(risk.lastOrigin, isNull);
      expect(viewModel.state.plots, hasLength(1));
    });

    test('allowing asks the phone and sends the place to the server', () async {
      final viewModel = _viewModel(risk, location);
      await viewModel.start();
      await viewModel.allowLocation();

      expect(location.saved, LocationChoice.allowed);
      expect(location.asked, [true]);
      expect(viewModel.state.location, isNotNull);
      expect(risk.lastOrigin?.latitude, -18.0);
    });

    test('«Ahora no» leaves the whole valley and it is not asked again', () async {
      final viewModel = _viewModel(risk, location);
      await viewModel.start();
      await viewModel.declineLocation();

      expect(viewModel.state.gpsOff, isTrue);
      final again = _viewModel(risk, location);
      await again.start();
      expect(again.state.explainLocation, isFalse);
      expect(again.state.gpsOff, isTrue);
    });

    test('a permission lost after a yes, as «Solo esta vez» does, is asked again', () async {
      location.saved = LocationChoice.allowed;
      final viewModel = _viewModel(risk, location);
      await viewModel.start();

      expect(location.asked, [false]);
      expect(viewModel.state.explainLocation, isFalse);
      expect(viewModel.state.gpsOff, isFalse);
      expect(viewModel.state.location, isNotNull);
      expect(risk.lastOrigin?.latitude, -18.0);
    });

    test('a no to that dialog stops asking, and never opens the settings by itself', () async {
      location
        ..saved = LocationChoice.allowed
        ..grants = false;
      final viewModel = _viewModel(risk, location);
      await viewModel.start();

      expect(location.asked, [false]);
      expect(location.saved, LocationChoice.declined);
      expect(viewModel.state.gpsOff, isTrue);
      expect(viewModel.state.plots, hasLength(1));

      final again = _viewModel(risk, location);
      await again.start();
      expect(location.asked, [false]);
      expect(again.state.gpsOff, isTrue);
    });

    test('«Reintentar» asks even after a no, and may open the settings', () async {
      location.saved = LocationChoice.declined;
      final viewModel = _viewModel(risk, location);
      await viewModel.start();
      await viewModel.allowLocation();

      expect(location.asked, [true]);
      expect(location.saved, LocationChoice.allowed);
      expect(viewModel.state.location, isNotNull);
    });

    test('coming back from the settings with the permission finds the manager', () async {
      location.saved = LocationChoice.declined;
      final viewModel = _viewModel(risk, location);
      await viewModel.start();
      expect(viewModel.state.location, isNull);

      location.permission = true;
      await viewModel.resume();

      expect(viewModel.state.location, isNotNull);
      expect(risk.lastOrigin?.latitude, -18.0);
    });

    test('a denied permission or a phone that can\'t find itself is the same: no GPS', () async {
      location.grants = false;
      final denied = _viewModel(risk, location);
      await denied.start();
      await denied.allowLocation();
      expect(denied.state.gpsOff, isTrue);

      location
        ..grants = true
        ..permission = true
        ..found = null;
      final noFix = _viewModel(risk, location);
      await noFix.start();
      expect(noFix.state.gpsOff, isTrue);
      expect(noFix.state.location, isNull);
    });

    test('touching a plot opens it and touching it again closes it', () async {
      final viewModel = _viewModel(risk, location);
      await viewModel.start();

      await viewModel.tapPlot('a');
      expect(viewModel.state.selectedPlot?.id, 'a');
      expect(viewModel.state.selectedDetail?.percentageToRemove, 30);

      await viewModel.tapPlot('a');
      expect(viewModel.state.selectedPlot, isNull);
      expect(viewModel.state.selectedDetail, isNull);
    });

    test('a sector\'s label filters, closes the chosen plot and toggles', () async {
      final viewModel = _viewModel(risk, location);
      await viewModel.start();
      await viewModel.tapPlot('a');

      viewModel.toggleSector('s1');
      expect(viewModel.state.selectedSector?.name, 'La Yarada Baja');
      expect(viewModel.state.selectedPlot, isNull);

      viewModel.toggleSector('s1');
      expect(viewModel.state.selectedSector, isNull);
    });

    test('a failed refresh keeps what is on screen; a failed first read reports it', () async {
      final viewModel = _viewModel(risk, location);
      await viewModel.start();
      risk.plotsFailure = const CooperativeOffline();
      await viewModel.refresh();
      expect(viewModel.state.failure, isNull);
      expect(viewModel.state.plots, hasLength(1));

      final first = _viewModel(risk, location);
      await first.start();
      expect(first.state.failure, isA<CooperativeOffline>());
    });

    test('a plot that is gone after a refresh stops being the chosen one', () async {
      final viewModel = _viewModel(risk, location);
      await viewModel.start();
      await viewModel.tapPlot('a');

      risk.plotsToReturn = [_plot('b')];
      await viewModel.refresh();
      expect(viewModel.state.selectedPlotId, isNull);
    });
  });

  group('G22 · the view model', () {
    test('a sector reads only its plots, in the server\'s order', () async {
      final risk = _FakeRisk()
        ..plotsToReturn = [
          _plot('a', risk: PlotRisk.critical, distanceKm: 3),
          _plot('b', sectorId: 'other', sectorName: 'Sama'),
          _plot('c', risk: PlotRisk.critical, distanceKm: 1),
        ];
      final viewModel = SectorDetailViewModel(getPlots: GetRiskPlotsUseCase(repository: risk), location: _FakeLocation());
      await viewModel.load('s1');

      expect(viewModel.state.title, 'La Yarada Baja');
      expect(viewModel.state.priority.map((p) => p.id), ['a', 'c']);

      viewModel.toggleOrder();
      expect(viewModel.state.priority.map((p) => p.id), ['c', 'a']);
    });

    test('«Ver visitas por cercanía» arrives with the closest first', () async {
      final risk = _FakeRisk()
        ..plotsToReturn = [
          _plot('a', risk: PlotRisk.critical, distanceKm: 3),
          _plot('b', risk: PlotRisk.critical, distanceKm: 1),
          _plot('far', risk: PlotRisk.critical, distanceKm: 40),
        ];
      final viewModel = SectorDetailViewModel(getPlots: GetRiskPlotsUseCase(repository: risk), location: _FakeLocation());
      await viewModel.load(RiskScopes.nearby);

      expect(viewModel.state.priority.map((p) => p.id), ['b', 'a']);
    });
  });

  group('G20 · the screen', () {
    final valley = [
      _plot('a', risk: PlotRisk.critical, distanceKm: 1, reasons: const [_overload], overload: 43),
      _plot('b', risk: PlotRisk.critical, distanceKm: 2, reasons: [_frost]),
      _plot('c', distanceKm: 3),
      _plot('d', risk: PlotRisk.noData, sectorId: 's2', sectorName: 'Sama'),
    ];

    testWidgets('near the manager it sums up what is within 5 km and opens the visits', (tester) async {
      _phone(tester);
      String? opened;
      await tester.pumpWidget(_riskPage(
        RiskMapUiState(
          loading: false,
          plots: valley,
          location: const ManagerLocation(coordinate: GeoCoordinate(-70.2, -18.0), accuracyMeters: 5),
        ),
        onScope: (scope) => opened = scope,
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('A menos de 5 km'), findsOneWidget);
      expect(find.text('CERCA DE TI · GPS ± 5 M'), findsOneWidget);
      expect(find.text('3 parcelas socias · actualizado hace 5 min'), findsOneWidget);
      expect(find.text('Crítico'), findsOneWidget);

      await tester.tap(find.text('Ver visitas por cercanía'));
      expect(opened, RiskScopes.nearby);
    });

    testWidgets('without GPS it warns and offers the sectors in alphabetical order', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_riskPage(RiskMapUiState(loading: false, plots: valley, gpsOff: true)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Sin ubicación · mostramos todo el valle'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
      expect(find.text('3 parcelas · 2 críticas'), findsOneWidget);
      expect(find.text('1 parcela · sin muestreo válido'), findsOneWidget);
      final first = tester.getTopLeft(find.text('La Yarada Baja').last).dy;
      final second = tester.getTopLeft(find.text('Sama').last).dy;
      expect(first, lessThan(second));
    });

    testWidgets('a chosen plot shows its owner, overload, prescription and days left', (tester) async {
      _phone(tester);
      String? opened;
      await tester.pumpWidget(_riskPage(
        RiskMapUiState(
          loading: false,
          plots: valley,
          gpsOff: true,
          selectedPlotId: 'a',
          selectedDetail: _detail(),
        ),
        onPlot: (id) => opened = id,
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Lote a'), findsOneWidget);
      expect(find.text('Teodoro Mamani · La Yarada Baja · 2,5 ha'), findsOneWidget);
      expect(find.text('43 %'), findsOneWidget);
      expect(find.text('30 %'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);

      await tester.tap(find.text('Ver lote'));
      expect(opened, 'a');
    });

    testWidgets('a chosen sector is summed up and opens G22', (tester) async {
      _phone(tester);
      String? opened;
      await tester.pumpWidget(_riskPage(
        RiskMapUiState(loading: false, plots: valley, gpsOff: true, selectedSectorId: 's1'),
        onScope: (scope) => opened = scope,
      ));
      await tester.pumpAndSettle();

      expect(find.text('FILTRO POR SECTOR'), findsOneWidget);
      await tester.tap(find.text('Ver parcelas del sector'));
      expect(opened, 's1');
    });

    testWidgets('the list goes by urgency and shows «Por confirmar» with «Revisar»', (tester) async {
      _phone(tester, height: 1400);
      await tester.pumpWidget(_riskPage(RiskMapUiState(
        loading: false,
        showList: true,
        plots: [
          ...valley,
          _plot('e', sectorId: null, sectorName: null, placement: SectorPlacement.pending, proposed: 'Cerro'),
        ],
      )));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('MÁS CRÍTICO'), findsOneWidget);
      expect(find.text('Por confirmar'), findsOneWidget);
      expect(find.text('Revisar'), findsOneWidget);
      expect(find.text('Sin datos'), findsOneWidget);
    });

    testWidgets('a valley without plots says so instead of showing green', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_riskPage(const RiskMapUiState(loading: false)));
      await tester.pumpAndSettle();

      expect(find.textContaining('Aparecerán aquí'), findsOneWidget);
      expect(find.text('Óptimo'), findsNothing);
    });

    testWidgets('the explanation of the GPS answers with its two actions', (tester) async {
      _phone(tester);
      bool? answer;
      await tester.pumpWidget(_app(Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              answer = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                builder: (context) => const LocationExplanationSheet(),
              );
            },
            child: const Text('open'),
          ),
        ),
      )));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Permitir ubicación'));
      await tester.pumpAndSettle();
      expect(answer, isTrue);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ahora no'));
      await tester.pumpAndSettle();
      expect(answer, isFalse);
    });
  });

  group('G22 · the screen', () {
    Widget page(SectorDetailUiState state, {void Function(String)? onPlot, void Function(PlotRisk)? onGroup}) =>
        _app(SectorDetailContent(
          state: state,
          onBack: () {},
          onRetry: () {},
          onToggleOrder: () {},
          onToggleGroup: onGroup ?? (_) {},
          onOpenPlot: onPlot ?? (_) {},
        ));

    final plots = [
      _plot('a', risk: PlotRisk.critical, reasons: const [_overload], distanceKm: 1.2),
      _plot('b', risk: PlotRisk.critical, reasons: [_frost], producer: 'Rosa Condori', distanceKm: 1.4),
      _plot('c', producer: 'Hugo Ticona'),
      _plot('d', risk: PlotRisk.noData, producer: 'Luis Ccama'),
    ];

    testWidgets('the priority plots are numbered with their reason, the rest grouped', (tester) async {
      _phone(tester, height: 1500);
      String? opened;
      await tester.pumpWidget(page(
        SectorDetailUiState(loading: false, scope: 's1', title: 'La Yarada Baja', plots: plots),
        onPlot: (id) => opened = id,
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('2'), findsWidgets);
      expect(find.text('de 4 parcelas en rojo'), findsOneWidget);
      expect(find.text('Sobrecarga 43 %'), findsOneWidget);
      expect(find.text('Helada 1,2 °C · 9 nov'), findsOneWidget);
      expect(find.text('Teodoro y Rosa están a menos de 1,5 km: puedes verlos en una sola salida.'), findsOneWidget);
      expect(find.text('Resto del sector'), findsOneWidget);
      expect(find.text('Sin datos suficientes'), findsOneWidget);

      await tester.tap(find.text('Teodoro Mamani'));
      expect(opened, 'a');
    });

    testWidgets('a group of the rest opens its plots in place', (tester) async {
      _phone(tester, height: 1500);
      PlotRisk? toggled;
      await tester.pumpWidget(page(
        SectorDetailUiState(loading: false, scope: 's1', title: 'La Yarada Baja', plots: plots),
        onGroup: (risk) => toggled = risk,
      ));
      await tester.tap(find.text('Sin datos suficientes'));
      expect(toggled, PlotRisk.noData);
      expect(find.text('Luis Ccama'), findsNothing);

      await tester.pumpWidget(page(SectorDetailUiState(
        loading: false,
        scope: 's1',
        title: 'La Yarada Baja',
        plots: plots,
        expanded: const {PlotRisk.noData},
      )));
      await tester.pumpAndSettle();
      expect(find.text('Luis Ccama'), findsOneWidget);
    });

    testWidgets('a sector without plots says so', (tester) async {
      _phone(tester);
      await tester.pumpWidget(page(const SectorDetailUiState(loading: false, scope: 's1')));
      await tester.pumpAndSettle();

      expect(find.text('No hay parcelas que mostrar aquí.'), findsOneWidget);
    });
  });

  group('G23 · the screen', () {
    Widget page(RiskPlotDetail plot, {void Function(String)? onCall, VoidCallback? onDossier}) => _app(RiskPlotContent(
          state: RiskPlotUiState(loading: false, plot: plot),
          now: _now,
          onBack: () {},
          onRetry: () {},
          onOpenDossier: onDossier ?? () {},
          onCall: onCall ?? (_) {},
          onWhatsapp: (_) {},
        ));

    testWidgets('a sampled plot shows its load, prescription and bearing index, read-only', (tester) async {
      _phone(tester, height: 2400);
      String? called;
      var dossier = false;
      await tester.pumpWidget(page(_detail(), onCall: (phone) => called = phone, onDossier: () => dossier = true));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Solo lectura'), findsOneWidget);
      expect(find.text('Carga frutal'), findsOneWidget);
      expect(find.text('FRUTOS POR BROTE'), findsOneWidget);
      expect(find.text('2,00'), findsOneWidget);
      expect(find.text('1,40'), findsOneWidget);
      expect(find.text('8,2'), findsOneWidget);
      expect(find.textContaining('43 % más fruta'), findsOneWidget);
      expect(find.textContaining('2027 sería'), findsOneWidget);
      expect(find.text('30 %'), findsOneWidget);
      expect(find.textContaining('quitar 3 de cada 10'), findsOneWidget);
      expect(find.text('Quedan 12 días'), findsOneWidget);
      expect(find.text('Aclareo aún sin registrar'), findsOneWidget);
      expect(find.text('BBI · alternancia alta'), findsOneWidget);
      expect(find.text('No cambia el color del semáforo.'), findsOneWidget);

      await tester.tap(find.text('Llamar'));
      expect(called, '+51952184337');
      await tester.tap(find.text('Ver expediente provisional'));
      expect(dossier, isTrue);
    });

    testWidgets('a registered thinning replaces the warning', (tester) async {
      _phone(tester, height: 1600);
      await tester.pumpWidget(page(_detail(thinnedOn: DateTime(2026, 11, 5))));
      await tester.pumpAndSettle();

      expect(find.text('Aclareo registrado el 5 nov'), findsOneWidget);
      expect(find.text('Aclareo aún sin registrar'), findsNothing);
      expect(find.text('Quedan 12 días'), findsNothing);
    });

    testWidgets('without a valid sampling there is no load or prescription, and it never reads as green', (tester) async {
      _phone(tester, height: 1800);
      await tester.pumpWidget(page(_detail(fruits: null, target: null, percent: null, risk: PlotRisk.noData)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('0 de 5 árboles'), findsOneWidget);
      expect(find.textContaining('nunca en verde'), findsOneWidget);
      expect(find.text('Óptimo'), findsNothing);
      expect(find.text('Quedan 12 días'), findsNothing);
      expect(find.textContaining('Escríbele a Teodoro'), findsOneWidget);
    });

    testWidgets('without a phone there is no way to call', (tester) async {
      _phone(tester, height: 1600);
      await tester.pumpWidget(page(_detail(phone: null)));
      await tester.pumpAndSettle();

      expect(find.text('Llamar'), findsNothing);
      expect(find.text('WhatsApp'), findsNothing);
    });
  });
}
