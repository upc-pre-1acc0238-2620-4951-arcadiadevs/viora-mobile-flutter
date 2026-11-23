import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/designsystem/component/viora_capsule_bar.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_intake_forecasts_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/has_active_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/intake_repository.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/intake_forecast_dto.dart';
import 'package:viora/features/cooperative_operations/presentation/state/intake_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/intake_page.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/intake_view_model.dart';

const _sectors = [
  SectorIntake(sectorId: 's1', sectorName: 'La Yarada Baja', plots: 18, sampledPlots: 15, tons: 390),
  SectorIntake(sectorId: 's2', sectorName: 'La Yarada Alta', plots: 14, sampledPlots: 10, tons: 320),
  SectorIntake(sectorId: 's5', sectorName: 'Sama', plots: 4, sampledPlots: 0, tons: null),
  SectorIntake(
    sectorId: null,
    sectorName: null,
    placement: SectorPlacement.pending,
    plots: 2,
    sampledPlots: 0,
    tons: null,
  ),
];

IntakeForecast _forecast({
  int year = 2026,
  IntakeKind kind = IntakeKind.projection,
  IntakeStatus status = IntakeStatus.sufficient,
  double? total = 1240,
  int plots = 60,
  int sampled = 37,
  int estimable = 31,
  List<SectorIntake> sectors = _sectors,
}) =>
    IntakeForecast(
      campaignYear: year,
      kind: kind,
      status: status,
      totalTons: total,
      greenTons: total == null ? 0 : 700,
      blackTons: total == null ? 0 : 420,
      unclassifiedTons: total == null ? 0 : 120,
      plots: plots,
      sampledPlots: sampled,
      estimablePlots: estimable,
      coveragePercent: sampled * 100 / plots,
      preliminaryThresholdPercent: 50,
      sectors: sectors,
      evaluatedAt: null,
    );

class _FakeIntake implements IntakeRepository {
  List<IntakeForecast> list = [];
  Map<int, IntakeForecast> byYear = {};
  CooperativeFailure? failure;
  final read = <int>[];

  @override
  Future<List<IntakeForecast>> campaigns() async {
    final failure = this.failure;
    if (failure != null) throw failure;
    return list;
  }

  @override
  Future<IntakeForecast> campaign(int year) async {
    read.add(year);
    final failure = this.failure;
    if (failure != null) throw failure;
    return byYear[year]!;
  }

  /// What the phone kept of the last reads, for G30 · Sin conexión.
  Kept<List<IntakeForecast>>? keptList;
  Map<int, Kept<IntakeForecast>> keptByYear = {};

  @override
  Future<Kept<List<IntakeForecast>>?> keptCampaigns() async => keptList;

  @override
  Future<Kept<IntakeForecast>?> keptCampaign(int year) async => keptByYear[year];
}

class _FakeRisk implements RiskRepository {
  @override
  Future<bool> hasActiveAlerts() async => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _app(Widget child) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

Widget _page(
  IntakeUiState state, {
  VoidCallback? onOpenMembers,
  VoidCallback? onChooseCampaign,
  VoidCallback? onOpenCaliberRanges,
}) =>
    _app(
      IntakePageContent(
        state: state,
        onRetry: () {},
        onRefresh: () async {},
        onChooseCampaign: onChooseCampaign ?? () {},
        onOpenAlerts: () {},
        onOpenMembers: onOpenMembers ?? () {},
        onOpenCaliberRanges: onOpenCaliberRanges ?? () {},
      ),
    );

void main() {
  group('IntakeForecastDto', () {
    test('reads a closed campaign and the sector of the plots to confirm', () {
      final forecast = IntakeForecastDto.fromJson({
        'campaignYear': 2025,
        'kind': 'SETTLED',
        'status': 'CLOSED',
        'totalTons': 820.0,
        'greenTons': 500.0,
        'blackTons': 320.0,
        'unclassifiedTons': 0.0,
        'plots': 40,
        'sampledPlots': 40,
        'estimablePlots': 40,
        'coveragePercent': 100.0,
        'preliminaryThresholdPercent': 50.0,
        'sectors': [
          {'sectorZoneId': null, 'sectorZoneName': null, 'sectorStatus': 'PENDING', 'plots': 2, 'sampledPlots': 0},
          {'sectorZoneId': null, 'sectorZoneName': null, 'sectorStatus': 'NONE', 'plots': 1, 'sampledPlots': 1},
        ],
        'evaluatedAt': '2026-11-11T12:00:00Z',
      }).toDomain();

      expect(forecast.kind, IntakeKind.settled);
      expect(forecast.status, IntakeStatus.closed);
      expect(forecast.sectors.map((sector) => sector.placement), [SectorPlacement.pending, SectorPlacement.none]);
    });

    test('reads the confidence, what is left to sample and the split by caliber', () {
      final forecast = IntakeForecastDto.fromJson({
        'campaignYear': 2026,
        'kind': 'PROJECTION',
        'status': 'SUFFICIENT',
        'confidenceLevel': 'MEDIUM',
        'pendingPlots': 4,
        'pendingHectares': 6.5,
        'caliberBreakdown': [
          {'minFruitsPerKg': 140, 'maxFruitsPerKg': 180, 'tons': 320.0, 'greenTons': 190.0, 'blackTons': 110.0,
            'unclassifiedTons': 20.0},
        ],
        'unsizedTons': 80.0,
        'outOfRangeTons': 0.0,
      }).toDomain();

      expect(forecast.confidence, IntakeConfidence.medium);
      expect(forecast.pendingPlots, 4);
      expect(forecast.pendingHectares, 6.5);
      expect(forecast.caliberBreakdown.single.minFruitsPerKg, 140);
      expect(forecast.caliberBreakdown.single.greenTons, 190);
      expect(forecast.unsizedTons, 80);

      final older = IntakeForecastDto.fromJson({'campaignYear': 2026, 'kind': 'PROJECTION'}).toDomain();
      expect(older.confidence, isNull);
      expect(older.caliberBreakdown, isEmpty);
    });

    test('reads how each sector splits by color, and leaves it out when the server does not send it', () {
      final forecast = IntakeForecastDto.fromJson({
        'campaignYear': 2026,
        'kind': 'PROJECTION',
        'status': 'SUFFICIENT',
        'sectors': [
          {
            'sectorZoneId': 's1',
            'sectorZoneName': 'La Yarada Baja',
            'sectorStatus': 'ASSIGNED',
            'plots': 18,
            'sampledPlots': 15,
            'tons': 390.0,
            'greenTons': 220.0,
            'blackTons': 130.0,
            'unclassifiedTons': 40.0,
          },
          {'sectorZoneId': 's2', 'sectorZoneName': 'Sama', 'sectorStatus': 'ASSIGNED', 'plots': 4, 'tons': 80.0},
        ],
      }).toDomain();

      final split = forecast.sectors.first;
      expect([split.greenTons, split.blackTons, split.unclassifiedTons], [220, 130, 40]);
      expect(split.hasColors, isTrue);
      expect(forecast.sectors.last.hasColors, isFalse);
    });
  });

  group('IntakeForecast', () {
    test('counts the plots missing to reach the threshold, which already counts as enough', () {
      expect(_forecast(plots: 60, sampled: 24).plotsToThreshold, 6);
      expect(_forecast(plots: 7, sampled: 2).plotsToThreshold, 2);
      expect(_forecast(plots: 60, sampled: 30).plotsToThreshold, 0);
    });
  });

  group('IntakeViewModel', () {
    late _FakeIntake intake;

    IntakeViewModel viewModel() => IntakeViewModel(
          getCampaigns: GetIntakeForecastsUseCase(repository: intake),
          getCampaign: GetIntakeForecastUseCase(repository: intake),
          getKeptCampaigns: GetKeptIntakeForecastsUseCase(repository: intake),
          getKeptCampaign: GetKeptIntakeForecastUseCase(repository: intake),
          hasActiveAlerts: HasActiveSectorAlertsUseCase(repository: _FakeRisk()),
        );

    setUp(() {
      intake = _FakeIntake()
        ..list = [_forecast(sectors: const []), _forecast(year: 2025, kind: IntakeKind.settled, sectors: const [])]
        ..byYear = {
          2026: _forecast(),
          2025: _forecast(year: 2025, kind: IntakeKind.settled, status: IntakeStatus.closed),
        };
    });

    test('opens on the newest campaign, with its sectors', () async {
      final model = viewModel();

      await model.load();

      expect(model.state.loading, isFalse);
      expect(model.state.campaigns, hasLength(2));
      expect(model.state.selectedYear, 2026);
      expect(model.state.forecast!.sectors, hasLength(4));
      expect(model.state.hasActiveAlerts, isTrue);
    });

    test('reads the campaign chosen in the sheet, and keeps it when reloading', () async {
      final model = viewModel();
      await model.load();

      await model.selectCampaign(2025);
      await model.load();

      expect(model.state.selectedYear, 2025);
      expect(model.state.forecast!.status, IntakeStatus.closed);
      expect(intake.read, [2026, 2025, 2025]);
    });

    test('keeps what is on screen when a reload fails, and reports a first failure', () async {
      final model = viewModel();
      await model.load();
      intake.failure = const CooperativeOffline();

      await model.load();
      expect(model.state.forecast, isNotNull);
      expect(model.state.failure, isNull);

      final fresh = viewModel();
      await fresh.load();
      expect(fresh.state.failure, isA<CooperativeOffline>());
    });

    test('opened without connection, it shows the campaign kept from the last read', () async {
      final savedAt = DateTime(2026, 9, 26, 18, 10);
      intake
        ..failure = const CooperativeOffline()
        ..keptList = Kept([_forecast(sectors: const [])], savedAt)
        ..keptByYear = {2026: Kept(_forecast(), savedAt)};
      final model = viewModel();

      await model.load();

      expect(model.state.failure, isNull);
      expect(model.state.selectedYear, 2026);
      expect(model.state.forecast!.sectors, hasLength(4));
      expect(model.state.savedAt, savedAt);
    });

    test('a campaign never read before cannot be chosen without connection', () async {
      final model = viewModel();
      await model.load();
      intake.failure = const CooperativeOffline();

      await model.selectCampaign(2025);

      expect(model.state.failure, isA<CooperativeOffline>());
    });
  });

  group('G30 · Acopio', () {
    testWidgets('shows the projection, the coverage and the sectors', (tester) async {
      await tester.pumpWidget(_page(IntakeUiState(loading: false, selectedYear: 2026, forecast: _forecast())));

      expect(find.text('Campaña 2026'), findsOneWidget);
      expect(find.text('Cobertura suficiente'), findsOneWidget);
      expect(find.text('PROYECCIÓN · CAMPAÑA 2026'), findsOneWidget);
      expect(find.textContaining('Faltan 23 por muestrear'), findsOneWidget);
      expect(find.text('120 t sin clasificar · 10 %'), findsOneWidget);
      expect(find.text('37 de 60 parcelas'), findsOneWidget);
      expect(find.text('62 %'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Por confirmar'), 200);
      expect(find.text('15 de 18 con muestreo'), findsOneWidget);
      expect(find.text('10 de 14'), findsOneWidget);
      expect(find.text('0 de 4 · sin datos'), findsOneWidget);
      expect(find.text('0 de 2 · revisar sector'), findsOneWidget);
    });

    testWidgets('splits the bar of a sector green and black when the server tells how', (tester) async {
      const sectors = [
        SectorIntake(
          sectorId: 's1',
          sectorName: 'La Yarada Baja',
          plots: 18,
          sampledPlots: 15,
          tons: 390,
          greenTons: 220,
          blackTons: 130,
          unclassifiedTons: 40,
        ),
        SectorIntake(sectorId: 's2', sectorName: 'La Yarada Alta', plots: 14, sampledPlots: 10, tons: 320),
      ];
      await tester.pumpWidget(_page(IntakeUiState(loading: false, selectedYear: 2026, forecast: _forecast(sectors: sectors))));
      await tester.scrollUntilVisible(find.text('La Yarada Alta'), 200);

      // The total and the first sector are split; the second one stays a single green bar.
      expect(find.byType(VioraSegmentedBar), findsNWidgets(2));
    });

    testWidgets('grades the projection, says what is left to sample and splits it by caliber', (tester) async {
      final forecast = IntakeForecast(
        campaignYear: 2026,
        kind: IntakeKind.projection,
        status: IntakeStatus.sufficient,
        totalTons: 1240,
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
        confidence: IntakeConfidence.medium,
        pendingPlots: 12,
        pendingHectares: 38.5,
        caliberBreakdown: const [
          CaliberIntake(minFruitsPerKg: 140, maxFruitsPerKg: 180, tons: 320, greenTons: 190, blackTons: 110,
              unclassifiedTons: 20),
        ],
        unsizedTons: 80,
        outOfRangeTons: 0,
      );
      var opened = false;
      await tester.pumpWidget(_page(IntakeUiState(loading: false, selectedYear: 2026, forecast: forecast),
          onOpenCaliberRanges: () => opened = true));

      expect(find.text('Confianza media'), findsOneWidget);
      expect(find.text('31 de 60 parcelas son estimables. Para confianza alta faltan 12 parcelas y 38,5 ha.'),
          findsOneWidget);
      // A graded projection no longer speaks of the preliminary threshold, which would contradict its tag
      expect(find.textContaining('umbral preliminar'), findsNothing);
      await tester.scrollUntilVisible(find.text('Sin calibre'), 200);
      expect(find.text('140–180 frutos/kg'), findsOneWidget);
      expect(find.text('Fuera de rango'), findsNothing);
      await tester.tap(find.text('Editar rangos'));
      expect(opened, isTrue);
    });

    testWidgets('without caliber ranges it offers to set them', (tester) async {
      var opened = false;
      await tester.pumpWidget(_page(IntakeUiState(loading: false, selectedYear: 2026, forecast: _forecast()),
          onOpenCaliberRanges: () => opened = true));

      await tester.scrollUntilVisible(find.text('Configurar calibres'), 200);
      await tester.tap(find.text('Configurar calibres'));
      expect(opened, isTrue);
    });

    testWidgets('marks a projection below the threshold as preliminary', (tester) async {
      final forecast = _forecast(status: IntakeStatus.preliminary, sampled: 24, estimable: 20);
      await tester.pumpWidget(_page(IntakeUiState(loading: false, selectedYear: 2026, forecast: forecast)));

      expect(find.text('Preliminar'), findsOneWidget);
      expect(find.textContaining('Solo 40 % de las parcelas tiene muestreo'), findsOneWidget);
      expect(find.text('Margen de incertidumbre elevado · 24 de 60 parcelas'), findsOneWidget);
      await tester.scrollUntilVisible(find.textContaining('Faltan 6 para llegar.'), 200);
      expect(find.textContaining('Faltan 6 para llegar.'), findsOneWidget);
    });

    testWidgets('shows no figure without sampling, and leads to the members', (tester) async {
      var opened = false;
      final forecast = _forecast(status: IntakeStatus.noData, total: null, sampled: 0, estimable: 0);
      await tester.pumpWidget(_page(
        IntakeUiState(loading: false, selectedYear: 2026, forecast: forecast),
        onOpenMembers: () => opened = true,
      ));

      expect(find.text('Sin datos suficientes\npara proyectar'), findsOneWidget);
      expect(find.text('0 de 60'), findsOneWidget);
      expect(find.text('Por sector'), findsNothing);
      await tester.tap(find.text('Ver socios sin muestreo'));
      expect(opened, isTrue);
    });

    testWidgets('shows a past campaign as the intake its members settled', (tester) async {
      final forecast = _forecast(year: 2025, kind: IntakeKind.settled, status: IntakeStatus.partial, sampled: 30);
      await tester.pumpWidget(_page(IntakeUiState(loading: false, selectedYear: 2025, forecast: forecast)));

      expect(find.text('ACOPIO REAL · CAMPAÑA 2025'), findsOneWidget);
      expect(find.text('Parcial'), findsOneWidget);
      expect(find.text('COSECHAS ASENTADAS'), findsOneWidget);
      expect(find.textContaining('umbral preliminar'), findsNothing);
    });

    testWidgets('«Elige la campaña» lists each campaign and answers the chosen one', (tester) async {
      int? chosen;
      final campaigns = [
        _forecast(),
        _forecast(year: 2025, kind: IntakeKind.settled, status: IntakeStatus.closed, total: 820),
        _forecast(year: 2024, kind: IntakeKind.settled, status: IntakeStatus.noData, total: null),
      ];
      await tester.pumpWidget(_app(Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async => chosen = await showCampaignSheet(context, campaigns, 2026),
            child: const Text('abrir'),
          ),
        ),
      )));
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      expect(find.text('En curso · proyección 1 240 t'), findsOneWidget);
      expect(find.text('Cerrada · acopio real 820 t'), findsOneWidget);
      expect(find.text('Sin cosechas asentadas'), findsOneWidget);
      await tester.tap(find.text('Campaña 2025'));
      await tester.pumpAndSettle();
      expect(chosen, 2025);
    });
  });
}
