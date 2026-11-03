/// What a person signs up with: the credentials of the account and the profile answered
/// in the onboarding. [nationalPhone] is the mobile without the dial code of [countryIso].
class Registration {
  const Registration({
    required this.email,
    required this.password,
    required this.fullName,
    required this.countryIso,
    required this.nationalPhone,
    required this.termsAccepted,
  });

  final String email;
  final String password;
  final String fullName;
  final String countryIso;
  final String nationalPhone;
  final bool termsAccepted;
}
