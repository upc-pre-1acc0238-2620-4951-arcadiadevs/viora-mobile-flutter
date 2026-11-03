import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/iam/domain/repository/onboarding_repository.dart';
import 'package:viora/features/iam/domain/valueobject/account_rules.dart';
import 'package:viora/features/iam/domain/valueobject/onboarding_answers.dart';
import 'package:viora/features/iam/presentation/state/onboarding_ui_state.dart';

/// The onboarding questions: name, mobile, alerts and summary. Each answer is saved on the
/// phone as soon as the person moves on, and an earlier run is picked up with its answers.
class OnboardingViewModel extends Cubit<OnboardingUiState> {
  OnboardingViewModel({required this.repository}) : super(const OnboardingUiState()) {
    _restore();
  }

  final OnboardingRepository repository;

  Future<void> _restore() async {
    final answers = await repository.answers();
    // The person may already be typing when the saved answers arrive: keep their edits.
    if (isClosed || state.fullName.isNotEmpty || state.step != OnboardingStep.name) return;
    emit(state.copyWith(
      fullName: answers.fullName,
      country: PhoneCountry.fromIso(answers.countryIso),
      phone: answers.nationalPhone,
      alertsEnabled: answers.alertsEnabled == true,
    ));
  }

  void onName(String value) => emit(state.copyWith(fullName: value));

  void onCountry(PhoneCountry value) => emit(state.copyWith(country: value));

  void onPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > PhoneCountry.nationalDigits
        ? digits.substring(0, PhoneCountry.nationalDigits)
        : digits;
    emit(state.copyWith(phone: limited));
  }

  void continueFromName() {
    if (state.nameValid) _advance(OnboardingStep.phone);
  }

  void continueFromPhone() {
    if (state.phoneValid) _advance(OnboardingStep.alerts);
  }

  /// After the system dialog of the alerts button, or when the person declines (false).
  void onAlertsAnswered(bool enabled) {
    emit(state.copyWith(alertsEnabled: enabled));
    _advance(OnboardingStep.summary);
  }

  /// The edit link on a row of the summary.
  void edit(OnboardingStep step) => emit(state.copyWith(step: step, editing: true));

  /// Back arrow and system back. False on the first question, so the screen can be left.
  bool back() {
    if (state.editing) {
      emit(state.copyWith(step: OnboardingStep.summary, editing: false));
      return true;
    }
    final previous = switch (state.step) {
      OnboardingStep.name => null,
      OnboardingStep.phone => OnboardingStep.name,
      OnboardingStep.alerts => OnboardingStep.phone,
      OnboardingStep.summary => OnboardingStep.alerts,
    };
    if (previous == null) return false;
    emit(state.copyWith(step: previous));
    return true;
  }

  /// Continuing below the legal notice records the acceptance before creating the account.
  Future<void> acceptTerms() => repository.save(_answers().acceptingTerms());

  void _advance(OnboardingStep next) {
    emit(state.copyWith(step: state.editing ? OnboardingStep.summary : next, editing: false));
    repository.save(_answers());
  }

  OnboardingAnswers _answers() => OnboardingAnswers(
        fullName: state.fullName.trim(),
        countryIso: state.country.iso,
        nationalPhone: state.phone,
        alertsEnabled: state.step == OnboardingStep.summary ? state.alertsEnabled : null,
      );
}
