import 'package:viora/features/iam/domain/valueobject/registration.dart';
import 'package:viora/features/iam/domain/valueobject/account_role.dart';
import 'package:viora/features/iam/domain/valueobject/account_rules.dart';
import 'package:viora/features/iam/infrastructure/remote/account_role_dto.dart';

class SignUpRequestDto {
  const SignUpRequestDto({
    required this.email,
    required this.password,
    required this.role,
    required this.termsAccepted,
    required this.fullName,
    required this.country,
    required this.phoneNumber,
  });

  factory SignUpRequestDto.fromDomain(Registration registration, {required AccountRole role}) {
    final country = PhoneCountry.fromIso(registration.countryIso);
    return SignUpRequestDto(
      email: registration.email,
      password: registration.password,
      role: role,
      termsAccepted: registration.termsAccepted,
      fullName: registration.fullName,
      country: country.iso,
      phoneNumber: country.e164(registration.nationalPhone),
    );
  }

  final String email;
  final String password;
  final AccountRole role;
  final bool termsAccepted;
  final String fullName;
  final String country;
  final String phoneNumber;

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
        'role': role.serverName,
        'termsAccepted': termsAccepted,
        'profile': {'fullName': fullName, 'country': country, 'phoneNumber': phoneNumber},
      };
}
