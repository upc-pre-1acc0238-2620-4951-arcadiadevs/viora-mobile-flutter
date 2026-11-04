/// The civil profile of the account.
class Profile {
  const Profile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.countryIso,
    required this.phoneNumber,
    required this.email,
  });

  final String id;
  final String userId;
  final String fullName;
  final String countryIso;

  /// In E.164 format.
  final String phoneNumber;
  final String email;
}
