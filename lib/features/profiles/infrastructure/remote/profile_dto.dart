import 'package:viora/features/profiles/domain/entity/profile.dart';

class ProfileDto {
  const ProfileDto({
    required this.id,
    required this.fullName,
    required this.country,
    required this.phoneNumber,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) => ProfileDto(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        country: json['country'] as String,
        phoneNumber: json['phoneNumber'] as String,
      );

  final String id;
  final String fullName;
  final String country;
  final String phoneNumber;

  /// The profile doesn't hold the email: the session of the account does.
  Profile toDomain({required String userId, required String email}) => Profile(
        id: id,
        userId: userId,
        fullName: fullName,
        countryIso: country,
        phoneNumber: phoneNumber,
        email: email,
      );
}
