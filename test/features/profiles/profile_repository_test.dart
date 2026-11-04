import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/profiles/domain/exception/profile_failure.dart';
import 'package:viora/features/profiles/infrastructure/local/profile_store.dart';
import 'package:viora/features/profiles/infrastructure/remote/profile_api.dart';
import 'package:viora/features/profiles/infrastructure/repository/profile_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const store = SessionStore();
  late ProfileStore profileStore;

  http.Response profile(String name) => http.Response.bytes(
        utf8.encode(
          jsonEncode({
            'id': 'profile-1',
            'userId': 'user-1',
            'fullName': name,
            'country': 'PE',
            'phoneNumber': '+51951406118',
          }),
        ),
        200,
      );

  ProfileRepositoryImpl repository(Future<http.Response> Function(http.Request) handler) =>
      ProfileRepositoryImpl(
        api: ProfileApi(client: ApiClient(client: MockClient(handler))),
        store: profileStore,
        sessionStore: store,
      );

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      'session.user_id': 'user-1',
      'session.email': 'rosa@example.com',
    });
    profileStore = ProfileStore();
  });

  test('keeps the downloaded profile, with the email of the session', () async {
    final repo = repository((_) async => profile('Rosa Condori'));

    await repo.refresh();

    final kept = await repo.current();
    expect(kept?.fullName, 'Rosa Condori');
    expect(kept?.email, 'rosa@example.com');
  });

  test('without a connection the kept profile stays', () async {
    await repository((_) async => profile('Rosa Condori')).refresh();
    final offline = repository((_) async => throw http.ClientException('offline'));

    await offline.refresh();

    expect((await offline.current())?.fullName, 'Rosa Condori');
  });

  test('current reads the kept profile without going to the server', () async {
    await repository((_) async => profile('Rosa Condori')).refresh();
    var requests = 0;
    final repo = repository((_) async {
      requests++;
      return profile('Otra');
    });

    expect((await repo.current())?.fullName, 'Rosa Condori');
    expect(requests, 0);
  });

  test('watching follows the changes of the kept profile', () async {
    final repo = repository((_) async => profile('Rosa Condori'));
    final names = repo.watchCurrent().map((profile) => profile?.fullName);
    final expectation = expectLater(names, emitsInOrder([null, 'Rosa Condori']));

    await Future<void>.delayed(const Duration(milliseconds: 10));
    await repo.refresh();

    await expectation;
  });

  test('a profile kept for another account does not show', () async {
    await repository((_) async => profile('Rosa Condori')).refresh();
    await const FlutterSecureStorage().write(key: 'session.user_id', value: 'user-2');

    final repo = repository((_) async => http.Response('{}', 500));

    expect(await repo.current(), isNull);
    expect(await repo.watchCurrent().first, isNull);
  });

  test('saving keeps what the server answered', () async {
    final repo = repository((_) async => profile('Rosa Paz'));

    await repo.update(fullName: 'Rosa Paz', countryIso: 'PE', phoneNumber: '+51951406118');

    expect((await repo.current())?.fullName, 'Rosa Paz');
  });

  test('saving without a connection fails and keeps the profile', () async {
    await repository((_) async => profile('Rosa Condori')).refresh();
    final offline = repository((_) async => throw http.ClientException('offline'));

    await expectLater(
      offline.update(fullName: 'Rosa Paz', countryIso: 'PE', phoneNumber: '+51951406118'),
      throwsA(isA<ProfileOffline>()),
    );

    expect((await offline.current())?.fullName, 'Rosa Condori');
  });

  test('clearing forgets the profile', () async {
    final repo = repository((_) async => profile('Rosa Condori'));
    await repo.refresh();

    await repo.clear();

    expect(await profileStore.read(), isNull);
  });
}
