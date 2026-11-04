import 'package:viora/features/profiles/domain/entity/profile.dart';

/// The profile of the signed-in person, kept on the phone so it shows without a connection.
abstract class ProfileRepository {
  /// The kept profile, again every time it changes; null while there is none.
  Stream<Profile?> watchCurrent();

  /// Downloads the profile. Without a connection, the kept one stays.
  Future<void> refresh();

  /// The kept profile or, if there is none yet, the downloaded one.
  Future<Profile?> current();

  /// Saves the contact details. Throws a ProfileFailure when it can't.
  Future<void> update({
    required String fullName,
    required String countryIso,
    required String phoneNumber,
  });

  /// Forgets the kept profile, when the session ends.
  Future<void> clear();
}
