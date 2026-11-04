import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viora/features/profiles/domain/entity/profile.dart';

/// Keeps the profile of the signed-in person on the phone, so it shows offline.
class ProfileStore {
  ProfileStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _id = 'profile.id';
  static const _userId = 'profile.user_id';
  static const _fullName = 'profile.full_name';
  static const _country = 'profile.country';
  static const _phone = 'profile.phone';
  static const _email = 'profile.email';

  final FlutterSecureStorage _storage;
  final _changes = StreamController<Profile?>.broadcast();

  /// The kept profile, and again every time it changes.
  Stream<Profile?> get profile async* {
    yield await read();
    yield* _changes.stream;
  }

  Future<Profile?> read() async {
    final userId = await _storage.read(key: _userId);
    if (userId == null) return null;
    return Profile(
      id: await _storage.read(key: _id) ?? userId,
      userId: userId,
      fullName: await _storage.read(key: _fullName) ?? '',
      countryIso: await _storage.read(key: _country) ?? '',
      phoneNumber: await _storage.read(key: _phone) ?? '',
      email: await _storage.read(key: _email) ?? '',
    );
  }

  Future<void> save(Profile profile) async {
    await _storage.write(key: _id, value: profile.id);
    await _storage.write(key: _userId, value: profile.userId);
    await _storage.write(key: _fullName, value: profile.fullName);
    await _storage.write(key: _country, value: profile.countryIso);
    await _storage.write(key: _phone, value: profile.phoneNumber);
    await _storage.write(key: _email, value: profile.email);
    _changes.add(profile);
  }

  Future<void> clear() async {
    for (final key in const [_id, _userId, _fullName, _country, _phone, _email]) {
      await _storage.delete(key: key);
    }
    _changes.add(null);
  }
}
