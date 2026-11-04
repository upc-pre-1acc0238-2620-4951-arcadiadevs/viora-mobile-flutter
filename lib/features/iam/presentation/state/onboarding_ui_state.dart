import 'package:flutter/foundation.dart';
import 'package:viora/core/domain/account_rules.dart';

/// The onboarding questions in order; [number] is the one the top bar shows.
enum OnboardingStep {
  name(1),
  phone(2),
  alerts(3),
  summary(null);

  const OnboardingStep(this.number);

  static const questions = 3;

  final int? number;
}

@immutable
class OnboardingUiState {
  const OnboardingUiState({
    this.step = OnboardingStep.name,
    this.editing = false,
    this.fullName = '',
    this.country = PhoneCountry.pe,
    this.phone = '',
    this.alertsEnabled = false,
  });

  final OnboardingStep step;

  /// A question opened from the summary to edit it: continuing returns there.
  final bool editing;
  final String fullName;
  final PhoneCountry country;
  final String phone;
  final bool alertsEnabled;

  bool get nameValid => PersonName.isValid(fullName);
  bool get phoneValid => country.isValidMobile(phone);
  bool get showPhoneError => phone.isNotEmpty && !phoneValid;
  String get firstName => PersonName.firstOf(fullName);

  OnboardingUiState copyWith({
    OnboardingStep? step,
    bool? editing,
    String? fullName,
    PhoneCountry? country,
    String? phone,
    bool? alertsEnabled,
  }) {
    return OnboardingUiState(
      step: step ?? this.step,
      editing: editing ?? this.editing,
      fullName: fullName ?? this.fullName,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
    );
  }
}
