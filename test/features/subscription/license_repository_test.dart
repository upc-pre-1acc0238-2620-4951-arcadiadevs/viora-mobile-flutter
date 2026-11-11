import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:viora/core/database/app_database.dart';
import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';
import 'package:viora/features/subscription/domain/valueobject/manager_code.dart';
import 'package:viora/features/subscription/infrastructure/local/manager_license_dao.dart';
import 'package:viora/features/subscription/infrastructure/remote/license_api.dart';
import 'package:viora/features/subscription/infrastructure/repository/license_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sessionStore = SessionStore();
  late AppDatabase db;
  late List<http.Request> requests;

  Map<String, dynamic> license({String organization = 'Cooperativa Olivar del Sur'}) => {
        'id': 'license-1',
        'organizationName': organization,
        'seats': 60,
        'contractedAreaHa': 200.0,
        'startsAt': '2026-11-05T00:00:00Z',
        'endsAt': '2028-01-01T05:00:00Z',
        'active': true,
      };

  http.Response json(Object body, [int status = 200]) =>
      http.Response.bytes(utf8.encode(jsonEncode(body)), status);

  LicenseRepositoryImpl repository(Future<http.Response> Function(http.Request) handler) =>
      LicenseRepositoryImpl(
        api: LicenseApi(
          client: ApiClient(
            client: MockClient((request) {
              requests.add(request);
              return handler(request);
            }),
          ),
        ),
        dao: ManagerLicenseDao(db),
        sessionStore: sessionStore,
      );

  final code = ManagerCode.tryParse('GEST-1111')!;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      'session.user_id': 'manager-1',
      'session.email': 'ruben@example.com',
    });
    db = AppDatabase(NativeDatabase.memory());
    requests = [];
  });

  tearDown(() => db.close());

  test('refresh downloads the license of the session and keeps it', () async {
    final repo = repository((_) async => json([license()]));

    final downloaded = await repo.refresh();

    expect(requests.single.url.path, endsWith('/cooperative-licenses'));
    expect(downloaded?.organizationName, 'Cooperativa Olivar del Sur');
    final kept = await repo.kept();
    expect(kept?.id, 'license-1');
    expect(kept?.seats, 60);
    expect(kept?.contractedAreaHa, 200);
    expect(kept?.endsAt.toUtc(), DateTime.utc(2028, 1, 1, 5));
  });

  test('a license the manager no longer holds is forgotten', () async {
    await repository((_) async => json([license()])).refresh();

    final none = await repository((_) async => json([])).refresh();

    expect(none, isNull);
    expect(await repository((_) async => json([])).kept(), isNull);
  });

  test('without a connection the refresh fails and the kept license stays', () async {
    await repository((_) async => json([license()])).refresh();
    final offline = repository((_) async => throw http.ClientException('offline'));

    await expectLater(offline.refresh(), throwsA(isA<LicenseOffline>()));
    expect((await offline.kept())?.id, 'license-1');
  });

  test('a server error is never read as no license', () async {
    await repository((_) async => json([license()])).refresh();
    final failing = repository((_) async => json({'code': 'UNEXPECTED_ERROR'}, 502));

    await expectLater(failing.refresh(), throwsA(isA<LicenseUnexpected>()));
    expect((await failing.kept())?.id, 'license-1');
  });

  test('activating sends the normalized code and keeps the license', () async {
    final repo = repository((_) async => json(license(), 201));

    final activated = await repo.activate(ManagerCode.tryParse(' gest-1111 ')!);

    expect(requests.single.url.path, endsWith('/manager-code-redemptions'));
    expect(jsonDecode(requests.single.body), {'code': 'GEST-1111'});
    expect(activated.organizationName, 'Cooperativa Olivar del Sur');
    expect((await repo.kept())?.id, 'license-1');
  });

  test('each refusal of the server becomes the failure the screen shows', () async {
    Future<Object?> failureOf(http.Response response) async {
      try {
        await repository((_) async => response).activate(code);
        return null;
      } on LicenseFailure catch (failure) {
        return failure;
      }
    }

    expect(
      await failureOf(json({'reason': 'subscription.manager_code.not_redeemable'}, 400)),
      isA<LicenseCodeNotRedeemable>(),
    );
    expect(
      await failureOf(json({'reason': 'subscription.manager.already_licensed'}, 409)),
      isA<LicenseAlreadyHeld>(),
    );
    expect(
      await failureOf(http.Response('', 429, headers: {'retry-after': '120'})),
      isA<LicenseTooManyAttempts>()
          .having((failure) => failure.retryAfterSeconds, 'retryAfterSeconds', 120),
    );
    expect(await failureOf(json({'code': 'USER_FORBIDDEN'}, 403)), isA<LicenseUnexpected>());
    expect(await repository((_) async => throw http.ClientException('offline')).activate(code)
        .then<Object?>((_) => null, onError: (Object error) => error), isA<LicenseOffline>());
  });

  test('the kept license belongs to its account only', () async {
    await repository((_) async => json([license()])).refresh();
    FlutterSecureStorage.setMockInitialValues({'session.user_id': 'manager-2'});

    final other = repository((_) async => json([]));

    expect(await other.kept(), isNull);
    expect(await other.watchCurrent().first, isNull);
  });

  test('watching follows the kept license, and clearing forgets it', () async {
    final repo = repository((_) async => json([license()]));
    final seen = <String?>[];
    final subscription = repo.watchCurrent().listen((license) => seen.add(license?.organizationName));
    // The database opens on the first query: the empty answer comes before anything is kept.
    await pumpEventQueue();

    await repo.refresh();
    await pumpEventQueue();
    await repo.clear();
    await pumpEventQueue();
    await subscription.cancel();

    expect(seen, [null, 'Cooperativa Olivar del Sur', null]);
  });

  test('the account email comes from the session', () async {
    expect(await repository((_) async => json([])).accountEmail(), 'ruben@example.com');
  });

  test('a code must be GEST- and four letters or digits, in any case and with spaces', () {
    expect(ManagerCode.tryParse('gest-7k2q')?.value, 'GEST-7K2Q');
    expect(ManagerCode.tryParse(' GEST - 7K2Q ')?.value, 'GEST-7K2Q');
    for (final invalid in ['COOP-7K2Q', 'GEST-7K2', 'GEST-7K2QA', 'GEST7K2Q', '']) {
      expect(ManagerCode.tryParse(invalid), isNull, reason: invalid);
    }
  });
}
