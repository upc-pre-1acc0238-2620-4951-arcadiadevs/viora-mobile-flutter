import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keeps the tokens of the session encrypted on the phone.
class SessionStore {
  const SessionStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _accessToken = 'session.access_token';
  static const _refreshToken = 'session.refresh_token';
  static const _userId = 'session.user_id';
  static const _email = 'session.email';
  static const _role = 'session.role';

  final FlutterSecureStorage _storage;

  Future<void> save({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    required String role,
  }) async {
    await _storage.write(key: _accessToken, value: accessToken);
    await _storage.write(key: _refreshToken, value: refreshToken);
    await _storage.write(key: _userId, value: userId);
    await _storage.write(key: _email, value: email);
    await _storage.write(key: _role, value: role);
  }

  Future<bool> hasSession() async => await refreshToken() != null;

  Future<String?> accessToken() => _storage.read(key: _accessToken);

  Future<String?> refreshToken() => _storage.read(key: _refreshToken);

  Future<String?> userId() => _storage.read(key: _userId);

  Future<String?> email() => _storage.read(key: _email);

  Future<void> clear() async {
    await _storage.delete(key: _accessToken);
    await _storage.delete(key: _refreshToken);
    await _storage.delete(key: _userId);
    await _storage.delete(key: _email);
    await _storage.delete(key: _role);
  }
}
