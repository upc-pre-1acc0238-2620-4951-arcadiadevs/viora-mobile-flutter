import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:viora/core/database/app_database.dart';
import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/infrastructure/local/manager_snapshot_dao.dart';
import 'package:viora/features/cooperative_operations/infrastructure/local/manager_snapshot_store.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/cooperative_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/intake_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/risk_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/repository/cooperative_repository_impl.dart';
import 'package:viora/features/cooperative_operations/infrastructure/repository/intake_repository_impl.dart';
import 'package:viora/features/cooperative_operations/infrastructure/repository/risk_repository_impl.dart';
import 'package:viora/features/cooperative_operations/presentation/state/intake_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/intake_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final savedAt = DateTime(2026, 9, 26, 18, 10);
  late AppDatabase db;
  late bool online;

  final plot = {
    'plotId': 'plot-1',
    'plotName': 'Lote 1',
    'producerName': 'Teodoro Mamani',
    'riskLevel': 'CRITICAL',
  };
  final campaign = {
    'campaignYear': 2026,
    'kind': 'PROJECTION',
    'status': 'SUFFICIENT',
    'totalTons': 1240.0,
    'plots': 60,
    'sampledPlots': 37,
    'estimablePlots': 31,
    'coveragePercent': 61.7,
    'preliminaryThresholdPercent': 50.0,
  };

  final license = {
    'organizationName': 'Cooperativa Olivar del Sur',
    'seats': 60,
    'contractedAreaHa': 200.0,
    'seatsUsed': 48,
    'startsAt': '2026-01-01T00:00:00Z',
    'endsAt': '2026-12-31T00:00:00Z',
  };
  final member = {'id': 'm1', 'fullName': 'Teodoro Mamani', 'sharing': 'SHARING'};
  final code = {
    'id': 'c1',
    'issuedAt': '2026-11-01T00:00:00Z',
    'expiresAt': '2026-11-30T00:00:00Z',
    'hectares': 12,
    'status': 'AVAILABLE',
  };

  ApiClient client() => ApiClient(
        client: MockClient((request) async {
          if (!online) throw http.ClientException('no signal');
          final path = request.url.path;
          final Object body = path.endsWith('/member-plots')
              ? [plot]
              : path.endsWith('/member-plots/plot-1')
                  ? plot
              : path.endsWith('/cooperative-licenses')
                  ? [license]
              : path.endsWith('/cooperative-members')
                  ? [member]
              : path.endsWith('/invitation-codes')
                  ? [code]
              : path.endsWith('/intake-forecasts')
                  ? [campaign]
                  : path.endsWith('/intake-forecasts/2026')
                      ? campaign
                      : <Object>[];
          return http.Response.bytes(utf8.encode(jsonEncode(body)), 200);
        }),
      );

  ManagerSnapshotStore store() =>
      ManagerSnapshotStore(dao: ManagerSnapshotDao(db), sessionStore: const SessionStore(), clock: () => savedAt);

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({'session.user_id': 'manager-1'});
    db = AppDatabase(NativeDatabase.memory());
    online = true;
  });

  tearDown(() => db.close());

  test('a read keeps its answer, and the kept copy comes back without a connection', () async {
    final risk = RiskRepositoryImpl(api: RiskApi(client: client()), snapshots: store());
    final intake = IntakeRepositoryImpl(api: IntakeApi(client: client()), snapshots: store());
    await risk.plots();
    await intake.campaigns();
    await intake.campaign(2026);

    online = false;
    await expectLater(risk.plots(), throwsA(isA<CooperativeOffline>()));

    final plots = await risk.keptPlots();
    expect(plots!.value.single.name, 'Lote 1');
    expect(plots.savedAt, savedAt);
    expect((await intake.keptCampaigns())!.value.single.totalTons, 1240);
    expect((await intake.keptCampaign(2026))!.value.estimablePlots, 31);
    expect(await intake.keptCampaign(2025), isNull);
  });

  test('a plot, the seats, the roster and the codes are kept too, for G10, G22, G23 and G40', () async {
    final risk = RiskRepositoryImpl(api: RiskApi(client: client()), snapshots: store());
    final cooperative = CooperativeRepositoryImpl(api: CooperativeApi(client: client()), snapshots: store());
    await risk.plot('plot-1');
    await cooperative.capacity();
    await cooperative.members();
    await cooperative.codes(InvitationCodeFilter.available);

    online = false;
    await expectLater(cooperative.members(), throwsA(isA<CooperativeOffline>()));

    expect((await risk.keptPlot('plot-1'))!.value.name, 'Lote 1');
    expect(await risk.keptPlot('plot-2'), isNull);
    expect((await cooperative.keptCapacity())!.value.seatsUsed, 48);
    expect((await cooperative.keptMembers())!.value.single.fullName, 'Teodoro Mamani');
    expect((await cooperative.keptCodes(InvitationCodeFilter.available))!.value.single.id, 'c1');
    expect(await cooperative.keptCodes(InvitationCodeFilter.redeemed), isNull);
  });

  test('another account never sees what was kept, and clearing forgets it', () async {
    final risk = RiskRepositoryImpl(api: RiskApi(client: client()), snapshots: store());
    await risk.plots();

    FlutterSecureStorage.setMockInitialValues({'session.user_id': 'manager-2'});
    expect(await risk.keptPlots(), isNull);

    FlutterSecureStorage.setMockInitialValues({'session.user_id': 'manager-1'});
    expect(await risk.keptPlots(), isNotNull);
    await store().clear();
    expect(await risk.keptPlots(), isNull);
  });

  testWidgets('G30 · Sin conexión puts the date of the projection in place of the voice', (tester) async {
    const forecast = IntakeForecast(
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
      sectors: [],
      evaluatedAt: null,
    );
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: IntakePageContent(
        state: IntakeUiState(loading: false, selectedYear: 2026, forecast: forecast, savedAt: savedAt),
        now: DateTime(2026, 11, 11, 9),
        onRetry: () {},
        onRefresh: () async {},
        onChooseCampaign: () {},
        onOpenAlerts: () {},
        onOpenMembers: () {},
      ),
    ));

    // «sep» or «sept», as the phone's Spanish names the month.
    expect(find.textContaining(RegExp(r'^Sin conexión · proyección del 26 sept?, 18:10$')), findsOneWidget);
    expect(find.textContaining('Faltan 23 por muestrear'), findsNothing);
  });
}
