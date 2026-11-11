import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/sector_alert_dto.dart';
import 'package:viora/features/cooperative_operations/presentation/state/manager_alerts_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/manager_alerts_page.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/manager_alerts_view_model.dart';

/// Wednesday morning; the frost is forecast for Thursday 19.
final _now = DateTime(2026, 11, 18, 7, 45);

SectorAlert _alert(
  String id, {
  SectorAlertType type = SectorAlertType.sectorCritical,
  bool active = true,
  String sector = 'La Yarada Baja',
  Duration ago = const Duration(minutes: 5),
  PlotRisk? levelAfter,
  int affected = 5,
  String? producer = 'Teodoro Mamani',
  RiskReason? reason = RiskReason.overload,
  double? value = 43,
  DateTime? leadDate,
}) {
  final at = _now.subtract(ago);
  return SectorAlert(
    id: id,
    sectorId: 'sector-$id',
    sectorName: sector,
    type: type,
    severity: type == SectorAlertType.frost ? AlertSeverity.attention : AlertSeverity.critical,
    active: active,
    openedAt: at,
    updatedAt: at,
    normalizedAt: active ? null : at,
    sectorLevelAfter: levelAfter,
    affectedPlots: affected,
    sectorPlots: 18,
    leadPlotId: producer == null ? null : 'plot-$id',
    leadPlotName: producer == null ? null : 'La Yarada 02',
    leadProducerName: producer,
    leadReason: producer == null ? null : reason,
    leadValue: value,
    leadDate: leadDate,
  );
}

/// The alerts of the mockup: one critical, one frost and two normalized.
final _mockup = [
  _alert('frost',
      type: SectorAlertType.frost,
      sector: 'La Yarada Alta',
      ago: const Duration(hours: 2),
      affected: 3,
      producer: 'Rosa Condori',
      reason: RiskReason.frostForecast,
      value: 1.2,
      leadDate: DateTime(2026, 11, 19)),
  _alert('critical'),
  _alert('magollo', active: false, sector: 'Magollo', ago: const Duration(days: 1), levelAfter: PlotRisk.moderate),
  _alert('palos', type: SectorAlertType.frost, active: false, sector: 'Los Palos', ago: const Duration(days: 6)),
];

class _FakeRisk implements RiskRepository {
  List<SectorAlert> alertsToReturn = const [];
  CooperativeFailure? failure;

  @override
  Future<List<SectorAlert>> alerts() async {
    final failure = this.failure;
    if (failure != null) throw failure;
    return alertsToReturn;
  }

  @override
  Future<bool> hasActiveAlerts() async => alertsToReturn.any((alert) => alert.active);

  @override
  Future<List<RiskPlot>> plots({GeoCoordinate? origin}) async => const [];

  @override
  Future<RiskPlotDetail> plot(String id) => throw UnimplementedError();

  /// The alerts kept from the last read, for T14 without a connection.
  Kept<List<SectorAlert>>? kept;

  @override
  Future<Kept<List<SectorAlert>>?> keptAlerts() async => kept;

  @override
  Future<Kept<List<RiskPlot>>?> keptPlots() async => null;

  @override
  Future<Kept<RiskPlotDetail>?> keptPlot(String id) async => null;
}

Widget _page(
  ManagerAlertsUiState state, {
  void Function(String)? onSector,
  void Function(AlertFilter)? onFilter,
  VoidCallback? onRetry,
  VoidCallback? onPreferences,
}) =>
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ManagerAlertsContent(
        state: state,
        now: _now,
        onBack: () {},
        onRetry: onRetry ?? () {},
        onOpenPreferences: onPreferences ?? () {},
        onToggleFilter: onFilter ?? (_) {},
        onOpenSector: onSector ?? (_) {},
      ),
    );

void _phone(WidgetTester tester, {double height = 1400}) {
  tester.view.physicalSize = Size(360 * 3, height * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  group('reading the server', () {
    test('an active alert keeps its sector, its figures and the plot that leads it', () {
      final alert = SectorAlertDto.fromJson({
        'id': 'a1',
        'sectorZoneId': 's1',
        'sectorZoneName': 'La Yarada Baja',
        'type': 'SECTOR_CRITICAL',
        'severity': 'CRITICAL',
        'status': 'ACTIVE',
        'openedAt': '2026-11-18T12:40:00Z',
        'updatedAt': '2026-11-18T12:40:00Z',
        'normalizedAt': null,
        'sectorLevelAfter': null,
        'affectedPlots': 5,
        'sectorPlots': 18,
        'leadPlotId': 'p1',
        'leadPlotName': 'La Yarada 02',
        'leadProducerName': 'Teodoro Mamani',
        'leadReason': 'OVERLOAD',
        'leadValue': 43.0,
        'leadDate': null,
      }).toDomain();

      expect(alert.sectorId, 's1');
      expect(alert.type, SectorAlertType.sectorCritical);
      expect(alert.severity, AlertSeverity.critical);
      expect(alert.active, isTrue);
      expect(alert.affectedPlots, 5);
      expect(alert.leadReason, RiskReason.overload);
      expect(alert.leadValue, 43);
      expect(alert.sectorLevelAfter, isNull);
      expect(alert.changedAt, DateTime.utc(2026, 11, 18, 12, 40));
    });

    test('a normalized frost tells how the sector was left, even when nobody shares', () {
      final alert = SectorAlertDto.fromJson({
        'id': 'a2',
        'sectorZoneId': 's2',
        'sectorZoneName': 'Los Palos',
        'type': 'FROST',
        'severity': 'ATTENTION',
        'status': 'NORMALIZED',
        'openedAt': '2026-11-10T05:00:00Z',
        'updatedAt': '2026-11-11T05:00:00Z',
        'normalizedAt': '2026-11-12T09:00:00Z',
        'sectorLevelAfter': 'MODERATE',
        'affectedPlots': 0,
        'sectorPlots': 7,
        'leadDate': '2026-11-11',
      }).toDomain();

      expect(alert.type, SectorAlertType.frost);
      expect(alert.severity, AlertSeverity.attention);
      expect(alert.active, isFalse);
      expect(alert.sectorLevelAfter, PlotRisk.moderate);
      expect(alert.leadProducerName, isNull);
      expect(alert.leadReason, isNull);
      expect(alert.changedAt, DateTime.utc(2026, 11, 12, 9));
    });
  });

  group('T14 · the state', () {
    test('the critical alerts go first and each capsule counts its own', () {
      final state = ManagerAlertsUiState(loading: false, alerts: _mockup);

      expect(state.active.map((alert) => alert.id), ['critical', 'frost']);
      expect(state.normalized.map((alert) => alert.id), ['magollo', 'palos']);
      expect((state.critical, state.attention, state.normalized.length), (1, 1, 2));
      expect(state.activeSectors, ['La Yarada Baja', 'La Yarada Alta']);
    });

    test('a capsule narrows the list to its group', () {
      final state = ManagerAlertsUiState(loading: false, alerts: _mockup);

      final critical = state.withFilter(AlertFilter.critical);
      expect(critical.visibleActive.map((alert) => alert.id), ['critical']);
      expect(critical.visibleNormalized, isEmpty);

      final normalized = state.withFilter(AlertFilter.normalized);
      expect(normalized.visibleActive, isEmpty);
      expect(normalized.visibleNormalized, hasLength(2));
    });

    test('an older alert goes after today\'s, whatever its severity', () {
      final state = ManagerAlertsUiState(
        loading: false,
        alerts: [
          _alert('old', ago: const Duration(days: 2)),
          _alert('frost', type: SectorAlertType.frost, ago: const Duration(minutes: 30)),
        ],
      );

      expect(state.active.map((alert) => alert.id), ['frost', 'old']);
    });
  });

  group('T14 · the view model', () {
    test('it reads the alerts and remembers when', () async {
      final risk = _FakeRisk()..alertsToReturn = _mockup;
      final viewModel = ManagerAlertsViewModel(getAlerts: GetSectorAlertsUseCase(repository: risk), clock: () => _now);

      await viewModel.load();

      expect(viewModel.state.loading, isFalse);
      expect(viewModel.state.alerts, hasLength(4));
      expect(viewModel.state.readAt, _now);
    });

    test('a second tap on the same capsule shows every alert again', () async {
      final viewModel = ManagerAlertsViewModel(getAlerts: GetSectorAlertsUseCase(repository: _FakeRisk()));

      viewModel.toggleFilter(AlertFilter.attention);
      expect(viewModel.state.filter, AlertFilter.attention);
      viewModel.toggleFilter(AlertFilter.critical);
      expect(viewModel.state.filter, AlertFilter.critical);
      viewModel.toggleFilter(AlertFilter.critical);
      expect(viewModel.state.filter, isNull);
    });

    test('without connection it says so and keeps the filter for the retry', () async {
      final risk = _FakeRisk()..failure = const CooperativeOffline();
      final viewModel = ManagerAlertsViewModel(getAlerts: GetSectorAlertsUseCase(repository: risk));
      viewModel.toggleFilter(AlertFilter.critical);

      await viewModel.load();
      expect(viewModel.state.failure, isA<CooperativeOffline>());
      expect(viewModel.state.filter, AlertFilter.critical);

      risk
        ..failure = null
        ..alertsToReturn = _mockup;
      await viewModel.load();
      expect(viewModel.state.failure, isNull);
      expect(viewModel.state.visibleActive.map((alert) => alert.id), ['critical']);
    });

    test('without connection it shows the alerts kept from the last read, with their date', () async {
      final savedAt = _now.subtract(const Duration(hours: 3));
      final risk = _FakeRisk()
        ..failure = const CooperativeOffline()
        ..kept = Kept(_mockup, savedAt);
      final viewModel = ManagerAlertsViewModel(
        getAlerts: GetSectorAlertsUseCase(repository: risk),
        getKeptAlerts: GetKeptSectorAlertsUseCase(repository: risk),
      );

      await viewModel.load();

      expect(viewModel.state.failure, isNull);
      expect(viewModel.state.offline, isTrue);
      expect(viewModel.state.alerts, hasLength(4));
      expect(viewModel.state.readAt, savedAt);
    });
  });

  group('T14 · the screen', () {
    testWidgets('it shows the active alerts of today and those normalized this week', (tester) async {
      _phone(tester, height: 2600);
      String? opened;
      await tester.pumpWidget(_page(ManagerAlertsUiState(loading: false, alerts: _mockup, readAt: _now), onSector: (id) => opened = id));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('alertas activas'), findsOneWidget);
      expect(find.textContaining('En La Yarada Baja y La Yarada Alta · actualizado'), findsOneWidget);
      expect(find.text('Críticas'), findsOneWidget);
      expect(find.text('Atención'), findsNWidgets(2));
      expect(find.text('Normalizadas'), findsOneWidget);
      expect(find.text('HOY'), findsOneWidget);

      expect(find.text('La Yarada Baja pasó a Crítico'), findsOneWidget);
      expect(find.text('Crítica'), findsOneWidget);
      expect(find.text('Hace 5 min'), findsOneWidget);
      expect(
        find.text('Teodoro Mamani registró una sobrecarga de 43 %. Ya son 5 parcelas en rojo en el sector.'),
        findsOneWidget,
      );

      expect(find.text('Helada radiativa en La Yarada Alta'), findsOneWidget);
      expect(find.text('Jueves 19'), findsOneWidget);
      expect(find.text('1,2°'), findsOneWidget);
      expect(find.text('Mínima prevista de 1,2 °C el jueves 19. Avisa a los socios del sector.'), findsOneWidget);

      expect(find.text('NORMALIZADAS · ÚLTIMOS 7 DÍAS'), findsOneWidget);
      expect(find.text('Magollo volvió a Moderado'), findsOneWidget);
      expect(find.text('Ayer'), findsOneWidget);
      expect(find.text('Pasó la helada en Los Palos'), findsOneWidget);
      expect(find.text('12 nov'), findsOneWidget);

      await tester.tap(find.text('Abrir sector').first);
      expect(opened, 'sector-critical');
    });

    testWidgets('a capsule filters and the settings open the preferences', (tester) async {
      _phone(tester);
      AlertFilter? filter;
      var preferences = false;
      await tester.pumpWidget(_page(
        ManagerAlertsUiState(loading: false, alerts: _mockup, readAt: _now),
        onFilter: (value) => filter = value,
        onPreferences: () => preferences = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Normalizadas'));
      expect(filter, AlertFilter.normalized);

      await tester.tap(find.bySemanticsLabel('Preferencias de alertas'));
      expect(preferences, isTrue);
    });

    testWidgets('filtered to the critical ones it hides the frost and the normalized', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_page(
        ManagerAlertsUiState(loading: false, alerts: _mockup, readAt: _now, filter: AlertFilter.critical),
      ));
      await tester.pumpAndSettle();

      expect(find.text('La Yarada Baja pasó a Crítico'), findsOneWidget);
      expect(find.text('Helada radiativa en La Yarada Alta'), findsNothing);
      expect(find.text('Magollo volvió a Moderado'), findsNothing);
    });

    testWidgets('when the owner stopped sharing only the sector\'s figures remain', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_page(
        ManagerAlertsUiState(loading: false, alerts: [_alert('a', producer: null, affected: 1)], readAt: _now),
      ));
      await tester.pumpAndSettle();

      expect(find.text('alerta activa'), findsOneWidget);
      expect(find.text('Ya hay 1 parcela en rojo en el sector.'), findsOneWidget);
    });

    testWidgets('without alerts the sectors are calm', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_page(ManagerAlertsUiState(loading: false, readAt: _now)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('alertas activas'), findsOneWidget);
      expect(find.textContaining('Tus sectores están en calma · actualizado'), findsOneWidget);
      expect(find.text('HOY'), findsNothing);
    });

    testWidgets('without connection it offers to try again', (tester) async {
      _phone(tester);
      var retried = false;
      await tester.pumpWidget(_page(
        const ManagerAlertsUiState(loading: false, failure: CooperativeOffline()),
        onRetry: () => retried = true,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión. Revisa tu señal e inténtalo de nuevo.'), findsOneWidget);
      await tester.tap(find.text('Reintentar'));
      expect(retried, isTrue);
    });
  });
}
