import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/profiles/domain/entity/profile.dart';
import 'package:viora/features/profiles/domain/exception/profile_failure.dart';
import 'package:viora/features/profiles/domain/repository/profile_repository.dart';
import 'package:viora/features/profiles/infrastructure/local/profile_store.dart';
import 'package:viora/features/profiles/infrastructure/remote/profile_api.dart';
import 'package:viora/features/profiles/infrastructure/remote/profile_dto.dart';
import 'package:viora/features/profiles/infrastructure/remote/update_profile_request_dto.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required this.api,
    required this.store,
    required this.sessionStore,
  });

  final ProfileApi api;
  final ProfileStore store;
  final SessionStore sessionStore;

  // Only the signed-in account's profile: one kept for another account never shows.
  @override
  Stream<Profile?> watchCurrent() async* {
    final userId = await sessionStore.userId();
    yield* store.profile.map((profile) => profile?.userId == userId ? profile : null);
  }

  @override
  Future<void> refresh() async {
    final userId = await sessionStore.userId();
    if (userId == null) return;
    try {
      await _keep(await api.byUser(userId), userId);
    } on ApiException {
      // The kept profile stays.
    } on ApiUnreachableException {
      // The kept profile stays.
    }
  }

  @override
  Future<Profile?> current() async {
    final userId = await sessionStore.userId();
    if (userId == null) return null;
    var profile = await store.read();
    if (profile?.userId != userId) {
      await refresh();
      profile = await store.read();
    }
    return profile?.userId == userId ? profile : null;
  }

  @override
  Future<void> update({
    required String fullName,
    required String countryIso,
    required String phoneNumber,
  }) async {
    final userId = await sessionStore.userId();
    if (userId == null) throw const ProfileUnexpected();
    try {
      final saved = await api.update(
        userId,
        UpdateProfileRequestDto(fullName: fullName, country: countryIso, phoneNumber: phoneNumber),
      );
      await _keep(saved, userId);
    } on ApiUnreachableException {
      throw const ProfileOffline();
    } on ApiException catch (error) {
      // The numbering plan of the server refuses the number as a business rule.
      throw error.status == 422 ? const ProfilePhoneRejected() : const ProfileUnexpected();
    }
  }

  @override
  Future<void> clear() => store.clear();

  Future<void> _keep(ProfileDto profile, String userId) async {
    final email = await sessionStore.email() ?? '';
    await store.save(profile.toDomain(userId: userId, email: email));
  }
}
