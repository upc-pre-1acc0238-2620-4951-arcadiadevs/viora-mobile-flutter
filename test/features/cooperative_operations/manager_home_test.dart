import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/l10n/app_localizations_es.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_intake_forecasts_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plots_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';
import 'package:viora/features/cooperative_operations/domain/repository/intake_repository.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/intake_forecast_dto.dart';
import 'package:viora/features/cooperative_operations/presentation/state/manager_home_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/manager_home_sections.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/manager_home_view_model.dart';

const _overload = PlotRiskReason(type: RiskReason.overload, value: 43);
final _frost = PlotRiskReason(type: RiskReason.frostForecast, value: 1.2, date: DateTime(2026, 11, 12));

RiskPlot _plot(
  String id, {
  PlotRisk risk = PlotRisk.optimal,
  String? sectorId = 's1',
  String? sectorName = 'La Yarada Baja',
  SectorPlacement placement = SectorPlacement.assigned,
  String producer = 'Teodoro Mamani',
  List<PlotRiskReason> reasons = const [],
  String? proposed,
}) =>
    RiskPlot(
      id: id,
      name: 'Lote $id',
      producerName: producer,
      areaHa: 2.5,
      center: null,
      outline: const [],
      sectorId: sectorId,
      sectorName: sectorName,
      placement: placement,
      proposedSectorName: proposed,
      risk: risk,
      reasons: reasons,
      overloadPercent: null,
      distanceKm: null,
      evaluatedAt: null,
    );

final _capacity = LicenseCapacity(
  organizationName: 'Cooperativa Olivar del Sur',
  seats: 60,
  contractedAreaHa: 200,
  seatsUsed: 48,
  seatsFree: 12,
  reservedAreaHa: 138,
  freeAreaHa: 62,
  suggestedHectaresPerCode: 5,
  startsAt: DateTime(2026),
  endsAt: DateTime(2027),
);

IntakeForecast _intake({int year = 2026, double? total = 1240}) => IntakeForecast(
      campaignYear: year,
      kind: IntakeKind.projection,
      status: total == null ? IntakeStatus.noData : IntakeStatus.sufficient,
      totalTons: total,
      greenTons: 700,
      blackTons: 420,
      unclassifiedTons: 120,
      plots: 60,
      sampledPlots: 37,
      estimablePlots: 31,
      coveragePercent: 61.7,
      preliminaryThresholdPercent: 50,
      sectors: const [],
      evaluatedAt: null,
    );

SectorAlert _alert(SectorAlertType type, {bool active = true}) => SectorAlert(
      id: '${type.name}-$active',
      sectorId: 's1',
      sectorName: 'La Yarada Baja',
      type: type,
      severity: AlertSeverity.attention,
      active: active,
      openedAt: null,
      updatedAt: null,
      normalizedAt: null,
      sectorLevelAfter: null,
      affectedPlots: 1,
      sectorPlots: 3,
      leadPlotId: null,
      leadPlotName: null,
      leadProducerName: null,
      leadReason: null,
      leadValue: null,
      leadDate: null,
    );

class _FakeRisk implements RiskRepository {
  List<RiskPlot> plotsAnswer = const [];
  CooperativeFailure? plotsFailure;
  List<SectorAlert> alertsAnswer = const [];

  @override
  Future<List<RiskPlot>> plots({GeoCoordinate? origin}) async {
    final failure = plotsFailure;
    if (failure != null) throw failure;
    return plotsAnswer;
  }

  @override
  Future<List<SectorAlert>> alerts() async => alertsAnswer;

  Kept<List<RiskPlot>>? keptPlotsAnswer;
  Kept<List<SectorAlert>>? keptAlertsAnswer;

  @override
  Future<Kept<List<RiskPlot>>?> keptPlots() async => keptPlotsAnswer;

  @override
  Future<Kept<List<SectorAlert>>?> keptAlerts() async => keptAlertsAnswer;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCooperative implements CooperativeRepository {
  CooperativeFailure? failure;

  @override
  Future<LicenseCapacity> capacity() async {
    final failure = this.failure;
    if (failure != null) throw failure;
    return _capacity;
  }

  Kept<LicenseCapacity>? keptCapacityAnswer;

  @override
  Future<Kept<LicenseCapacity>?> keptCapacity() async => keptCapacityAnswer;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeIntake implements IntakeRepository {
  List<IntakeForecast> answer = const [];
  CooperativeFailure? failure;

  @override
  Future<List<IntakeForecast>> campaigns() async {
    final failure = this.failure;
    if (failure != null) throw failure;
    return answer;
  }

  @override
  Future<IntakeForecast> campaign(int year) async => answer.first;

  Kept<List<IntakeForecast>>? keptAnswer;

  @override
  Future<Kept<List<IntakeForecast>>?> keptCampaigns() async => keptAnswer;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeLocation implements LocationRepository {
  @override
  ManagerLocation? lastKnown;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _app(Widget child) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

void main() {
  final l10n = AppLocalizationsEs();

  group('ManagerHomeViewModel', () {
    late _FakeRisk risk;
    late _FakeCooperative cooperative;
    late _FakeIntake intake;

    ManagerHomeViewModel viewModel() => ManagerHomeViewModel(
          getPlots: GetRiskPlotsUseCase(repository: risk),
          getCapacity: GetLicenseCapacityUseCase(repository: cooperative),
          getAlerts: GetSectorAlertsUseCase(repository: risk),
          getIntake: GetIntakeForecastsUseCase(repository: intake),
          location: _FakeLocation(),
          getKeptPlots: GetKeptRiskPlotsUseCase(repository: risk),
          getKeptCapacity: GetKeptLicenseCapacityUseCase(repository: cooperative),
          getKeptAlerts: GetKeptSectorAlertsUseCase(repository: risk),
          getKeptIntake: GetKeptIntakeForecastsUseCase(repository: intake),
        );

    setUp(() {
      risk = _FakeRisk();
      cooperative = _FakeCooperative();
      intake = _FakeIntake();
    });

    test('reads the valley, the seats, the active frost alerts and the newest campaign', () async {
      risk
        ..plotsAnswer = [_plot('1', risk: PlotRisk.critical), _plot('2')]
        ..alertsAnswer = [
          _alert(SectorAlertType.frost),
          _alert(SectorAlertType.frost, active: false),
          _alert(SectorAlertType.sectorCritical),
        ];
      intake.answer = [_intake(year: 2026), _intake(year: 2025)];
      final home = viewModel();

      await home.load();

      expect(home.state.loading, isFalse);
      expect(home.state.territory!.valley.critical, 1);
      expect(home.state.capacity!.seatsUsed, 48);
      expect(home.state.frostAlerts, 1);
      expect(home.state.intake!.campaignYear, 2026);
    });

    test('a card that cannot be read is left out, the Home is still shown', () async {
      risk.plotsAnswer = [_plot('1')];
      cooperative.failure = const CooperativeUnexpected();
      final home = viewModel();

      await home.load();

      expect(home.state.failure, isNull);
      expect(home.state.territory, isNotNull);
      expect(home.state.capacity, isNull);
      expect(home.state.intake, isNull);
    });

    test('without the valley it reports the failure, and keeps what it had on a later failure', () async {
      risk.plotsFailure = const CooperativeOffline();
      final home = viewModel();

      await home.load();
      expect(home.state.failure, isA<CooperativeOffline>());

      risk
        ..plotsFailure = null
        ..plotsAnswer = [_plot('1')];
      await home.load();
      risk.plotsFailure = const CooperativeOffline();
      await home.load();

      expect(home.state.failure, isNull);
      expect(home.state.territory!.valley.total, 1);
    });

    test('without a connection it shows the valley and the cards last read, with their date', () async {
      final saved = DateTime(2026, 11, 10, 18, 10);
      risk
        ..plotsFailure = const CooperativeOffline()
        ..keptPlotsAnswer = Kept([_plot('1', risk: PlotRisk.critical)], saved)
        ..keptAlertsAnswer = Kept([_alert(SectorAlertType.frost)], saved);
      cooperative
        ..failure = const CooperativeOffline()
        ..keptCapacityAnswer = Kept(_capacity, saved);
      intake
        ..failure = const CooperativeOffline()
        ..keptAnswer = Kept([_intake(year: 2026)], saved);
      final home = viewModel();

      await home.load();

      expect(home.state.failure, isNull);
      expect(home.state.territory!.valley.critical, 1);
      expect(home.state.savedAt, saved);
      expect(home.state.capacity!.seatsUsed, 48);
      expect(home.state.intake!.campaignYear, 2026);
    });
  });

  group('the voice line', () {
    test('names the most urgent sector and its overloaded plots', () {
      final territory = RiskTerritory([
        _plot('1', risk: PlotRisk.critical, reasons: const [_overload]),
        _plot('2', risk: PlotRisk.critical, reasons: const [_overload]),
        _plot('3', risk: PlotRisk.moderate, sectorId: 's2', sectorName: 'Magollo'),
      ]);

      expect(managerHomeVoiceLine(l10n, territory), 'La Yarada Baja necesita tu visita: 2 parcelas en sobrecarga.');
    });

    test('warns of frost when nothing is red, and is calm when all is well', () {
      expect(
        managerHomeVoiceLine(l10n, RiskTerritory([_plot('1', risk: PlotRisk.moderate, reasons: [_frost])])),
        'Se viene helada: 1 parcela bajo 1,5 °C en 48 h.',
      );
      expect(managerHomeVoiceLine(l10n, RiskTerritory([_plot('1')])), 'Tu valle está en calma: ninguna parcela en rojo.');
      expect(managerHomeVoiceLine(l10n, const RiskTerritory([])), l10n.homeVoiceNoPlots);
    });

    test('counts the red plots of the valley when they have no sector', () {
      final territory = RiskTerritory([
        _plot('1', risk: PlotRisk.critical, sectorId: null, sectorName: null, placement: SectorPlacement.none),
      ]);

      expect(managerHomeVoiceLine(l10n, territory), 'Una parcela en rojo espera tu visita.');
    });
  });

  test('the visits are the red and amber plots in the order of the server', () {
    final territory = RiskTerritory([
      _plot('1', risk: PlotRisk.critical),
      _plot('2'),
      _plot('3', risk: PlotRisk.moderate),
      _plot('4', risk: PlotRisk.noData),
    ]);

    expect(territory.visits.plots.map((plot) => plot.id), ['1', '3']);
  });

  test('tons are grouped by a thin space', () {
    expect(formatTons(1240.4, 'es'), '1 240');
    expect(formatTons(1240.4, 'en'), '1 240');
    expect(formatTons(700, 'es'), '700');
  });

  test('the intake of a campaign without samplings has no figure', () {
    final dto = IntakeForecastDto.fromJson({
      'campaignYear': 2026,
      'kind': 'PROJECTION',
      'status': 'NO_DATA',
      'totalTons': null,
      'greenTons': 0,
      'blackTons': 0,
      'unclassifiedTons': 0,
      'plots': 4,
      'sampledPlots': 0,
      'estimablePlots': 0,
      'coveragePercent': 0,
      'preliminaryThresholdPercent': 50,
      'sectors': [
        {'sectorZoneId': null, 'sectorZoneName': null, 'sectorStatus': 'NONE', 'plots': 4, 'sampledPlots': 0, 'tons': null},
      ],
    }).toDomain();

    expect(dto.status, IntakeStatus.noData);
    expect(dto.totalTons, isNull);
    expect(dto.sectors.single.tons, isNull);
  });

  group('G10 · Inicio', () {
    ManagerHomeUiState state({List<RiskPlot>? plots, IntakeForecast? intake}) => ManagerHomeUiState(
          loading: false,
          territory: RiskTerritory(plots ??
              [
                _plot('1', risk: PlotRisk.critical, reasons: const [_overload]),
                _plot('2', risk: PlotRisk.critical, producer: 'Rosa Condori', reasons: [_frost]),
                _plot('3', risk: PlotRisk.moderate, producer: 'Julio Quispe', sectorName: 'Magollo'),
                _plot('4', risk: PlotRisk.moderate, producer: 'Ángel Choque'),
                _plot('5'),
                _plot('6', risk: PlotRisk.noData),
              ]),
          capacity: _capacity,
          frostAlerts: 2,
          intake: intake ?? _intake(),
        );

    Widget summary(ManagerHomeUiState state, {List<String>? opened}) => _app(ManagerHomeSummaryContent(
          state: state,
          onRetry: () {},
          onOpenRisk: () => opened?.add('risk'),
          onOpenIntake: () => opened?.add('intake'),
          onOpenAlerts: () => opened?.add('alerts'),
          onOpenMembers: () => opened?.add('members'),
          onOpenVisits: () => opened?.add('visits'),
          onOpenPlot: (id) => opened?.add('plot $id'),
        ));

    testWidgets('shows the traffic light, the license cards and three visits', (tester) async {
      tester.view.physicalSize = const Size(402, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(summary(state()));

      expect(find.text('SEMÁFORO DEL VALLE · 6 PARCELAS'), findsOneWidget);
      expect(find.text('2'), findsWidgets);
      expect(find.text('parcelas\ncríticas'), findsOneWidget);
      expect(find.text('Crítico 2'), findsOneWidget);
      expect(find.text('Moderado 2'), findsOneWidget);
      expect(find.text('Campaña 2026'), findsOneWidget);
      expect(find.text('1 240 t'), findsOneWidget);
      expect(find.text('Cobertura 62 %'), findsOneWidget);
      expect(find.text('alertas de helada\n≤ 1,5 °C en 48 h'), findsOneWidget);
      expect(find.text('48 / 60'), findsOneWidget);
      expect(find.text('Teodoro Mamani'), findsOneWidget);
      expect(find.text('Lote 1 · La Yarada Baja'), findsOneWidget);
      expect(find.text('Julio Quispe'), findsOneWidget);
      expect(find.text('Ángel Choque'), findsNothing);
    });

    testWidgets('each card opens its screen', (tester) async {
      tester.view.physicalSize = const Size(402, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final opened = <String>[];

      await tester.pumpWidget(summary(state(), opened: opened));
      await tester.tap(find.text('Ver riesgo territorial'));
      await tester.tap(find.text('Campaña 2026'));
      await tester.tap(find.text('48 / 60'));
      await tester.tap(find.text('alertas de helada\n≤ 1,5 °C en 48 h'));
      await tester.tap(find.text('Ver todas'));
      await tester.tap(find.text('Teodoro Mamani'));

      expect(opened, ['risk', 'intake', 'members', 'alerts', 'visits', 'plot 1']);
    });

    testWidgets('without samplings the intake has no figure, and a calm valley has no visits', (tester) async {
      tester.view.physicalSize = const Size(402, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(summary(state(plots: [_plot('1')], intake: _intake(total: null))));

      expect(find.text('—'), findsOneWidget);
      expect(find.text('sin muestreos todavía'), findsOneWidget);
      expect(find.text('Ninguna parcela necesita visita hoy.'), findsOneWidget);
      expect(find.text('Ver todas'), findsNothing);
    });

    testWidgets('a valley kept without a connection says so, with its date', (tester) async {
      tester.view.physicalSize = const Size(402, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final kept = state(plots: [_plot('1')]);

      await tester.pumpWidget(summary(kept));
      expect(find.textContaining('Sin conexión'), findsNothing);

      await tester.pumpWidget(summary(kept.copyWith(savedAt: () => DateTime(2026, 11, 10, 18, 10))));
      expect(find.textContaining('Sin conexión · último estado'), findsOneWidget);
    });
  });
}
