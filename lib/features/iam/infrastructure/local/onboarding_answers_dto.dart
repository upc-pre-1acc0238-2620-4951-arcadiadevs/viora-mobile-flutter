import 'package:viora/features/iam/domain/valueobject/onboarding_answers.dart';

/// The answers as they're kept on the phone.
class OnboardingAnswersDto {
  const OnboardingAnswersDto({
    required this.fullName,
    required this.countryIso,
    required this.nationalPhone,
    required this.alertsEnabled,
    required this.termsAccepted,
  });

  factory OnboardingAnswersDto.fromDomain(OnboardingAnswers answers) => OnboardingAnswersDto(
        fullName: answers.fullName,
        countryIso: answers.countryIso,
        nationalPhone: answers.nationalPhone,
        alertsEnabled: answers.alertsEnabled,
        termsAccepted: answers.termsAccepted,
      );

  factory OnboardingAnswersDto.fromJson(Map<String, dynamic> json) => OnboardingAnswersDto(
        fullName: json['fullName'] as String? ?? '',
        countryIso: json['countryIso'] as String? ?? 'PE',
        nationalPhone: json['nationalPhone'] as String? ?? '',
        alertsEnabled: json['alertsEnabled'] as bool?,
        termsAccepted: json['termsAccepted'] as bool? ?? false,
      );

  final String fullName;
  final String countryIso;
  final String nationalPhone;
  final bool? alertsEnabled;
  final bool termsAccepted;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'countryIso': countryIso,
        'nationalPhone': nationalPhone,
        'alertsEnabled': alertsEnabled,
        'termsAccepted': termsAccepted,
      };

  OnboardingAnswers toDomain() => OnboardingAnswers(
        fullName: fullName,
        countryIso: countryIso,
        nationalPhone: nationalPhone,
        alertsEnabled: alertsEnabled,
        termsAccepted: termsAccepted,
      );
}
