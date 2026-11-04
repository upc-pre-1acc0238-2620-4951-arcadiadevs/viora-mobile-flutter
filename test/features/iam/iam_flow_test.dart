import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/features/iam/application/usecase/check_password_reset_link_use_case.dart';
import 'package:viora/features/iam/application/usecase/request_password_reset_use_case.dart';
import 'package:viora/features/iam/application/usecase/resend_code_use_case.dart';
import 'package:viora/features/iam/application/usecase/reset_password_use_case.dart';
import 'package:viora/features/iam/application/usecase/sign_in_use_case.dart';
import 'package:viora/features/iam/application/usecase/sign_up_use_case.dart';
import 'package:viora/features/iam/application/usecase/verify_email_use_case.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/domain/valueobject/registration.dart';
import 'package:viora/features/iam/domain/repository/auth_repository.dart';
import 'package:viora/features/iam/domain/repository/onboarding_repository.dart';
import 'package:viora/core/domain/account_rules.dart';
import 'package:viora/features/iam/domain/valueobject/onboarding_answers.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/state/onboarding_ui_state.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';
import 'package:viora/features/iam/presentation/viewmodel/onboarding_view_model.dart';

class _FakeOnboarding implements OnboardingRepository {
  OnboardingAnswers saved = const OnboardingAnswers();
  bool cleared = false;

  @override
  Future<OnboardingAnswers> answers() async => saved;

  @override
  Future<void> save(OnboardingAnswers answers) async => saved = answers;

  @override
  Future<void> clear() async => cleared = true;
}

class _FakeAuth implements AuthRepository {
  AuthFailure? failure;
  Registration? registered;
  int resends = 0;

  Future<void> _maybeFail() async {
    final failure = this.failure;
    if (failure != null) throw failure;
  }

  @override
  Future<void> signIn(String email, String password) => _maybeFail();

  @override
  Future<void> signOut() async {}

  @override
  Future<void> changePassword(String currentPassword, String newPassword) => _maybeFail();

  @override
  Future<String> signUp(Registration registration) async {
    await _maybeFail();
    registered = registration;
    return registration.email;
  }

  @override
  Future<void> verifyEmail(String email, String code) => _maybeFail();

  @override
  Future<void> resendCode(String email) async => resends++;

  @override
  Future<void> requestPasswordReset(String email) => _maybeFail();

  @override
  Future<void> checkPasswordResetLink(String token) => _maybeFail();

  @override
  Future<void> resetPassword(String token, String newPassword) => _maybeFail();

  @override
  Future<bool> isSignedIn() async => false;
}

void main() {
  group('account rules', () {
    test('a name needs two letters', () {
      expect(PersonName.isValid(' R '), isFalse);
      expect(PersonName.isValid('12'), isFalse);
      expect(PersonName.isValid('Ñu'), isTrue);
    });

    test('a password needs 8 characters with letters and numbers', () {
      expect(PasswordPolicy.isValid('abc123'), isFalse);
      expect(PasswordPolicy.isValid('abcdefgh'), isFalse);
      expect(PasswordPolicy.isValid('abcd1234'), isTrue);
    });

    test('each country has the shape of its mobile numbers', () {
      expect(PhoneCountry.pe.isValidMobile('987654321'), isTrue);
      expect(PhoneCountry.pe.isValidMobile('887654321'), isFalse);
      expect(PhoneCountry.pe.isValidMobile('98765'), isFalse);
      expect(PhoneCountry.es.isValidMobile('612345678'), isTrue);
      expect(PhoneCountry.es.isValidMobile('912345678'), isFalse);
      expect(PhoneCountry.pe.e164('987654321'), '+51987654321');
      expect(PhoneCountry.pe.international('951406118'), '+51 951 406 118');
    });
  });

  group('onboarding', () {
    late _FakeOnboarding repository;
    late OnboardingViewModel viewModel;

    setUp(() {
      repository = _FakeOnboarding();
      viewModel = OnboardingViewModel(repository: repository);
    });

    tearDown(() => viewModel.close());

    void answerUntilSummary() {
      viewModel
        ..onName('Rubén Ticona')
        ..continueFromName()
        ..onPhone('951406118')
        ..continueFromPhone()
        ..onAlertsAnswered(true);
    }

    test('goes through the questions in order and saves the answers', () async {
      await Future<void>.delayed(Duration.zero);
      answerUntilSummary();

      expect(viewModel.state.step, OnboardingStep.summary);
      expect(viewModel.state.firstName, 'Rubén');
      expect(repository.saved.fullName, 'Rubén Ticona');
      expect(repository.saved.nationalPhone, '951406118');
      expect(repository.saved.alertsEnabled, isTrue);
    });

    test("doesn't move on with an invalid answer", () async {
      await Future<void>.delayed(Duration.zero);

      viewModel
        ..onName('R')
        ..continueFromName();
      expect(viewModel.state.step, OnboardingStep.name);

      viewModel
        ..onName('Rubén')
        ..continueFromName()
        ..onPhone('98765')
        ..continueFromPhone();
      expect(viewModel.state.step, OnboardingStep.phone);
      expect(viewModel.state.showPhoneError, isTrue);
    });

    test('tells the expected format while the phone is incomplete', () {
      expect(viewModel.state.showPhoneError, isFalse);
      viewModel.onPhone('98765');
      expect(viewModel.state.showPhoneError, isTrue);
      viewModel.onPhone('951406118');
      expect(viewModel.state.showPhoneError, isFalse);
    });

    test('keeps only 9 digits of the phone', () {
      viewModel.onPhone('951-406-118-999');
      expect(viewModel.state.phone, '951406118');
    });

    test('editing from the summary returns to it', () async {
      await Future<void>.delayed(Duration.zero);
      answerUntilSummary();

      viewModel
        ..edit(OnboardingStep.name)
        ..onName('Rosa Condori')
        ..continueFromName();

      expect(viewModel.state.step, OnboardingStep.summary);
      expect(repository.saved.fullName, 'Rosa Condori');
    });

    test('back walks the questions and ends on the first one', () async {
      await Future<void>.delayed(Duration.zero);
      viewModel
        ..onName('Rubén')
        ..continueFromName();

      expect(viewModel.back(), isTrue);
      expect(viewModel.state.step, OnboardingStep.name);
      expect(viewModel.back(), isFalse);
    });

    test('restores the answers of an earlier run', () async {
      final saved = _FakeOnboarding()
        ..saved = const OnboardingAnswers(fullName: 'Rosa', nationalPhone: '987654321');
      final restored = OnboardingViewModel(repository: saved);
      await Future<void>.delayed(Duration.zero);

      expect(restored.state.fullName, 'Rosa');
      expect(restored.state.phone, '987654321');
      await restored.close();
    });

    test('accepting the terms keeps the answers for the sign-up', () async {
      await Future<void>.delayed(Duration.zero);
      answerUntilSummary();

      await viewModel.acceptTerms();

      expect(repository.saved.termsAccepted, isTrue);
      expect(repository.saved.fullName, 'Rubén Ticona');
    });
  });

  group('account', () {
    late _FakeAuth auth;
    late _FakeOnboarding onboarding;
    late IamViewModel viewModel;

    setUp(() {
      auth = _FakeAuth();
      onboarding = _FakeOnboarding()
        ..saved = const OnboardingAnswers(
          fullName: 'Rosa Condori',
          nationalPhone: '987654321',
          termsAccepted: true,
        );
      viewModel = IamViewModel(
        signInUseCase: SignInUseCase(repository: auth),
        signUpUseCase: SignUpUseCase(repository: auth),
        verifyEmailUseCase: VerifyEmailUseCase(repository: auth),
        resendCodeUseCase: ResendCodeUseCase(repository: auth),
        requestPasswordResetUseCase: RequestPasswordResetUseCase(repository: auth),
        checkPasswordResetLinkUseCase: CheckPasswordResetLinkUseCase(repository: auth),
        resetPasswordUseCase: ResetPasswordUseCase(repository: auth),
        onboardingRepository: onboarding,
      );
    });

    tearDown(() => viewModel.close());

    void fillAccount() => viewModel
      ..onEmail('rosa@example.com')
      ..onPassword('Clave1234');

    test('signing in authenticates', () async {
      fillAccount();
      await viewModel.signIn();
      expect(viewModel.state.authenticated, isTrue);
    });

    test('wrong credentials mark the fields and stay on the screen', () async {
      auth.failure = const InvalidCredentials();
      fillAccount();
      await viewModel.signIn();

      expect(viewModel.state.failure, isA<InvalidCredentials>());
      expect(viewModel.state.authenticated, isFalse);
    });

    test('an account of another role is told to use the other app', () async {
      auth.failure = const AccountOfOtherRole();
      fillAccount();
      await viewModel.signIn();

      expect(viewModel.state.failure, isA<AccountOfOtherRole>());
      expect(viewModel.state.authenticated, isFalse);
    });

    test('an unverified account continues with a fresh code', () async {
      auth.failure = const EmailNotVerified();
      fillAccount();
      await viewModel.signIn();
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.step, IamStep.verify);
      expect(viewModel.state.pendingEmail, 'rosa@example.com');
      expect(auth.resends, 1);
    });

    test('offline shows the general error', () async {
      auth.failure = const AuthOffline();
      fillAccount();
      await viewModel.signIn();
      expect(viewModel.state.failure, isA<AuthOffline>());
    });

    test('signing up uses the onboarding answers and asks for the code', () async {
      fillAccount();
      await viewModel.signUp();

      expect(auth.registered?.fullName, 'Rosa Condori');
      expect(auth.registered?.nationalPhone, '987654321');
      expect(auth.registered?.termsAccepted, isTrue);
      expect(viewModel.state.step, IamStep.verify);
      expect(viewModel.state.resendSeconds, 45);
    });

    test('a pending email of another role blocks the button until it changes', () async {
      auth.failure = const EmailPendingWithOtherRole();
      fillAccount();
      await viewModel.signUp();
      expect(viewModel.state.failure, isA<EmailPendingWithOtherRole>());
      expect(viewModel.state.canCreateAccount, isFalse);

      viewModel.onEmail('otra@example.com');
      expect(viewModel.state.failure, isNull);
      expect(viewModel.state.canCreateAccount, isTrue);
    });

    test('the email goes without the spaces around it', () {
      viewModel.onEmail(' rosa@example.com ');

      expect(viewModel.state.normalizedEmail, 'rosa@example.com');
      expect(viewModel.state.emailValid, isTrue);
    });

    test('a taken email blocks the button until it changes', () async {
      auth.failure = const EmailTaken();
      fillAccount();
      await viewModel.signUp();
      expect(viewModel.state.failure, isA<EmailTaken>());
      expect(viewModel.state.canCreateAccount, isFalse);

      viewModel.onEmail('otra@example.com');
      expect(viewModel.state.canCreateAccount, isTrue);
    });

    test('the sixth digit verifies, opens the session and clears the answers', () async {
      fillAccount();
      await viewModel.signUp();

      viewModel.onCode('123456');
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.authenticated, isTrue);
      expect(onboarding.cleared, isTrue);
    });

    test('a wrong code tells the attempts left', () async {
      fillAccount();
      await viewModel.signUp();
      auth.failure = const InvalidCode(2);

      viewModel.onCode('123456');
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(
        viewModel.state.failure,
        isA<InvalidCode>().having((error) => error.remainingAttempts, 'left', 2),
      );
      expect(viewModel.state.resendSeconds, greaterThan(0));
    });

    test('a dead code can be replaced right away', () async {
      fillAccount();
      await viewModel.signUp();
      auth.failure = const CodeExpired();

      viewModel.onCode('123456');
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.failure, isA<CodeExpired>());
      expect(viewModel.state.resendSeconds, 0);
    });

    test('the resend countdown reaches zero', () {
      fakeAsync((async) {
        fillAccount();
        viewModel.signUp();
        async.flushMicrotasks();
        expect(viewModel.state.resendSeconds, 45);

        async.elapse(const Duration(seconds: 45));

        expect(viewModel.state.resendSeconds, 0);
        expect(async.periodicTimerCount, 0);
      });
    });

    test('an expired recovery link shows its screen', () async {
      auth.failure = const ResetLinkExpired();
      await viewModel.start(resetToken: 'token');
      expect(viewModel.state.step, IamStep.linkExpired);
    });

    test('a valid recovery link saves a new password', () async {
      await viewModel.start(resetToken: 'token');
      expect(viewModel.state.step, IamStep.newPassword);

      viewModel
        ..onPassword('Clave1234')
        ..onConfirmPassword('Clave1234');
      await viewModel.saveNewPassword();

      expect(viewModel.state.step, IamStep.resetDone);
    });

    test('a reused password stays on the form', () async {
      await viewModel.start(resetToken: 'token');
      auth.failure = const PasswordReused();
      viewModel
        ..onPassword('Clave1234')
        ..onConfirmPassword('Clave1234');
      await viewModel.saveNewPassword();

      expect(viewModel.state.failure, isA<PasswordReused>());
      expect(viewModel.state.step, IamStep.newPassword);
    });

    test('back from the code goes to sign-in keeping the email', () async {
      fillAccount();
      await viewModel.signUp();

      expect(viewModel.back(), isTrue);
      expect(viewModel.state.step, IamStep.signIn);
      expect(viewModel.state.email, 'rosa@example.com');
    });
  });
}
