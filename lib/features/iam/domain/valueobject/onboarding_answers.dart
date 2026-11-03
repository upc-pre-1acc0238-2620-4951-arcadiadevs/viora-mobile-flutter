import 'package:viora/features/iam/domain/valueobject/account_rules.dart';

/// What the person answered in the onboarding. The answers stay on the phone until the
/// email is verified; name, country and mobile become the profile at sign-up.
class OnboardingAnswers {
  const OnboardingAnswers({
    this.fullName = '',
    this.countryIso = 'PE',
    this.nationalPhone = '',
    this.alertsEnabled,
    this.termsAccepted = false,
  });

  final String fullName;
  final String countryIso;
  final String nationalPhone;

  /// Null until the alerts question is answered.
  final bool? alertsEnabled;
  final bool termsAccepted;

  String get firstName => PersonName.firstOf(fullName);

  OnboardingAnswers acceptingTerms() => OnboardingAnswers(
        fullName: fullName,
        countryIso: countryIso,
        nationalPhone: nationalPhone,
        alertsEnabled: alertsEnabled,
        termsAccepted: true,
      );
}
