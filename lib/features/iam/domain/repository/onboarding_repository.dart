import 'package:viora/features/iam/domain/valueobject/onboarding_answers.dart';

/// The onboarding answers kept on the phone until the email is verified, so closing the
/// app in the middle doesn't lose them.
abstract class OnboardingRepository {
  Future<OnboardingAnswers> answers();

  Future<void> save(OnboardingAnswers answers);

  Future<void> clear();
}
