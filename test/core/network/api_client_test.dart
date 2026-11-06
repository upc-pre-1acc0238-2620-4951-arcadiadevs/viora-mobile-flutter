import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:viora/core/datastore/session_events.dart';
import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/network/api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const store = SessionStore();
  late SessionEvents events;
  late List<http.Request> requests;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      'session.access_token': 'old-access',
      'session.refresh_token': 'old-refresh',
      'session.user_id': 'user-1',
    });
    events = SessionEvents();
    requests = [];
  });

  http.Response renewed() => http.Response(
        jsonEncode({
          'accessToken': 'new-access',
          'refreshToken': 'new-refresh',
          'userId': 'user-1',
          'email': 'rosa@example.com',
          'role': 'ROLE_TECHNICAL_MANAGER',
        }),
        200,
      );

  ApiClient client(Future<http.Response> Function(http.Request) handler) => ApiClient(
        client: MockClient((request) {
          requests.add(request);
          return handler(request);
        }),
        sessionStore: store,
        sessionEvents: events,
      );

  bool isRefresh(http.Request request) => request.url.path.endsWith('auth/refresh-tokens');

  test('a collection answer is read as a list, also after renewing the token', () async {
    final licenses = await client((request) async {
      if (isRefresh(request)) return renewed();
      return request.headers['authorization'] == 'Bearer new-access'
          ? http.Response('[{"id":"license-1"},{"id":"license-2"}]', 200)
          : http.Response('{}', 401);
    }).getList('cooperative-licenses');

    expect(licenses.map((license) => license['id']), ['license-1', 'license-2']);
  });

  test('a collection error keeps its status and reason', () async {
    await expectLater(
      client((_) async => http.Response('{"reason":"some.reason"}', 403)).getList('licenses'),
      throwsA(isA<ApiException>()
          .having((error) => error.status, 'status', 403)
          .having((error) => error.reason, 'reason', 'some.reason')),
    );
  });

  test('sends the access token of the session', () async {
    await client((_) async => http.Response('{}', 200)).get('plots');

    expect(requests.single.headers['authorization'], 'Bearer old-access');
  });

  test('a rejected token is renewed and the request repeated with the new one', () async {
    final body = await client((request) async {
      if (isRefresh(request)) return renewed();
      return request.headers['authorization'] == 'Bearer new-access'
          ? http.Response('{"ok":true}', 200)
          : http.Response('{}', 401);
    }).get('plots');

    expect(body['ok'], isTrue);
    expect(jsonDecode(requests[1].body), {'refreshToken': 'old-refresh'});
    expect(await store.accessToken(), 'new-access');
    expect(await store.refreshToken(), 'new-refresh');
    expect(await store.email(), 'rosa@example.com');
  });

  test('requests rejected together share one renewal', () async {
    final api = client((request) async {
      if (isRefresh(request)) return renewed();
      return request.headers['authorization'] == 'Bearer new-access'
          ? http.Response('{}', 200)
          : http.Response('{}', 401);
    });

    await Future.wait([api.get('plots'), api.get('samplings'), api.get('profiles/user-1')]);

    expect(requests.where(isRefresh), hasLength(1));
  });

  test('a refused renewal ends the session and announces it', () async {
    final expired = expectLater(events.expired, emits(null));

    await expectLater(
      client((request) async => http.Response('{}', isRefresh(request) ? 403 : 401)).get('plots'),
      throwsA(isA<ApiException>().having((error) => error.status, 'status', 401)),
    );

    await expired;
    expect(await store.hasSession(), isFalse);
  });

  test('a server error during the renewal keeps the session', () async {
    await expectLater(
      client((request) async => http.Response('{}', isRefresh(request) ? 500 : 401)).get('plots'),
      throwsA(isA<ApiException>()),
    );

    expect(await store.refreshToken(), 'old-refresh');
  });

  test('no connection during the renewal keeps the session', () async {
    await expectLater(
      client((request) async {
        if (isRefresh(request)) throw http.ClientException('offline');
        return http.Response('{}', 401);
      }).get('plots'),
      throwsA(isA<ApiUnreachableException>()),
    );

    expect(await store.refreshToken(), 'old-refresh');
  });

  test('a token refused again after renewing is not renewed twice', () async {
    await expectLater(
      client((request) async => isRefresh(request) ? renewed() : http.Response('{}', 401))
          .get('plots'),
      throwsA(isA<ApiException>()),
    );

    expect(requests.where(isRefresh), hasLength(1));
  });
}
