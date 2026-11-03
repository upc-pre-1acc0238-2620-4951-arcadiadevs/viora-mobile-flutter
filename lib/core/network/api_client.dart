import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;

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

/// JSON client of the Viora backend: the base URL, the language and the error mapping
/// live in this one place.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://viora-platform.onrender.com/api/v1/',
  );

  // The hosted backend sleeps when idle and takes a while to answer the first request.
  static const _timeout = Duration(seconds: 90);

  final http.Client _client;

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) =>
      _send(() => _client.post(_uri(path), headers: _headers(), body: jsonEncode(body)));

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) =>
      _send(() => _client.put(_uri(path), headers: _headers(), body: jsonEncode(body)));

  Future<Map<String, dynamic>> get(String path) =>
      _send(() => _client.get(_uri(path), headers: _headers()));

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> _headers() => {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        // The server words its messages and emails in the language of the phone.
        HttpHeaders.acceptLanguageHeader: PlatformDispatcher.instance.locale.toLanguageTag(),
      };

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
