import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:viora/core/datastore/session_events.dart';
import 'package:viora/core/datastore/session_store.dart';

/// The server answered with an error status. [body] is its JSON problem detail, when
/// there is one.
class ApiException implements Exception {
  const ApiException(this.status, this.body, this.retryAfterSeconds);

  final int status;
  final Map<String, dynamic> body;
  final int? retryAfterSeconds;

  String? get code => body['code'] as String?;
  String? get reason => body['reason'] as String?;
}

/// The server couldn't be reached: no connection, a timeout or an unreadable answer.
class ApiUnreachableException implements Exception {
  const ApiUnreachableException();
}

/// JSON client of the Viora backend: the base URL, the language, the session token and the
/// error mapping live in this one place.
class ApiClient {
  ApiClient({
    http.Client? client,
    this._sessionStore,
    this._sessionEvents,
    this._languageTag,
  }) : _client = client ?? http.Client();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://viora-platform.onrender.com/api/v1/',
  );

  // The hosted backend sleeps when idle and takes a while to answer the first request.
  static const _timeout = Duration(seconds: 90);

  final http.Client _client;
  final SessionStore? _sessionStore;
  final SessionEvents? _sessionEvents;

  /// The language chosen in the app, when it isn't the one of the phone.
  final String Function()? _languageTag;

  /// The renewal in progress. A refresh token works only once, so every request rejected
  /// at the same time waits for this one.
  Future<String?>? _renewal;

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) => _authorized(
        (headers) => _client.post(_uri(path), headers: headers, body: jsonEncode(body)),
      );

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) => _authorized(
        (headers) => _client.put(_uri(path), headers: headers, body: jsonEncode(body)),
      );

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body) => _authorized(
        (headers) => _client.patch(_uri(path), headers: headers, body: jsonEncode(body)),
      );

  Future<Map<String, dynamic>> get(String path) =>
      _authorized((headers) => _client.get(_uri(path), headers: headers));

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> _headers(String? accessToken) => {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        // The server words its messages and emails in the language of the app.
        HttpHeaders.acceptLanguageHeader:
            _languageTag?.call() ?? PlatformDispatcher.instance.locale.toLanguageTag(),
        if (accessToken != null) HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      };

  /// Sends the request with the session token. A rejected token is renewed once and the
  /// request repeated; if that isn't possible, the caller gets the original 401.
  Future<Map<String, dynamic>> _authorized(
    Future<http.Response> Function(Map<String, String> headers) request,
  ) async {
    final accessToken = await _sessionStore?.accessToken();
    try {
      return await _send(() => request(_headers(accessToken)));
    } on ApiException catch (error) {
      if (error.status != 401 || accessToken == null) rethrow;
      final renewed = await _renewedToken(accessToken);
      if (renewed == null) rethrow;
      return _send(() => request(_headers(renewed)));
    }
  }

  Future<String?> _renewedToken(String rejected) async {
    final store = _sessionStore!;
    // Another request may have renewed it while this one was on its way.
    final current = await store.accessToken();
    if (current != null && current != rejected) return current;
    return _renewal ??= _renew(store).whenComplete(() => _renewal = null);
  }

  Future<String?> _renew(SessionStore store) async {
    final refreshToken = await store.refreshToken();
    if (refreshToken == null) return null;
    final Map<String, dynamic> session;
    try {
      session = await _send(
        () => _client.post(
          _uri('auth/refresh-tokens'),
          headers: _headers(null),
          body: jsonEncode({'refreshToken': refreshToken}),
        ),
      );
    } on ApiException catch (error) {
      // A refusal ends the session; any other error may pass, so the tokens stay saved.
      if (error.status == 401 || error.status == 403) {
        await store.clear();
        _sessionEvents?.notifyExpired();
      }
      return null;
    }
    final accessToken = session['accessToken'] as String;
    await store.save(
      accessToken: accessToken,
      refreshToken: session['refreshToken'] as String,
      userId: session['userId'] as String,
      email: session['email'] as String? ?? '',
      role: session['role'] as String,
    );
    return accessToken;
  }

  Future<Map<String, dynamic>> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request().timeout(_timeout);
    } on SocketException {
      throw const ApiUnreachableException();
    } on TimeoutException {
      throw const ApiUnreachableException();
    } on http.ClientException {
      throw const ApiUnreachableException();
    }

    final body = _decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return body;
    throw ApiException(
      response.statusCode,
      body,
      (body['retryAfterSeconds'] as num?)?.toInt() ??
          int.tryParse(response.headers['retry-after'] ?? ''),
    );
  }

  Map<String, dynamic> _decode(String raw) {
    if (raw.isEmpty) return const {};
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } on FormatException {
      return const {};
    }
  }
}
