import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/iam/application/usecase/check_password_reset_link_use_case.dart';
import 'package:viora/features/iam/application/usecase/request_password_reset_use_case.dart';
import 'package:viora/features/iam/application/usecase/resend_code_use_case.dart';
import 'package:viora/features/iam/application/usecase/reset_password_use_case.dart';
import 'package:viora/features/iam/application/usecase/sign_in_use_case.dart';
import 'package:viora/features/iam/application/usecase/sign_up_use_case.dart';
import 'package:viora/features/iam/application/usecase/verify_email_use_case.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/domain/repository/onboarding_repository.dart';
import 'package:viora/features/iam/domain/valueobject/registration.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';

/// Signing in, creating the account, verifying the email and recovering the password.
class IamViewModel extends Cubit<IamUiState> {
  IamViewModel({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.verifyEmailUseCase,
    required this.resendCodeUseCase,
    required this.requestPasswordResetUseCase,
    required this.checkPasswordResetLinkUseCase,
    required this.resetPasswordUseCase,
    required this.onboardingRepository,
  }) : super(const IamUiState());

  static const _resendCooldownSeconds = 45;

  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ResendCodeUseCase resendCodeUseCase;
  final RequestPasswordResetUseCase requestPasswordResetUseCase;
  final CheckPasswordResetLinkUseCase checkPasswordResetLinkUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final OnboardingRepository onboardingRepository;

  Timer? _countdown;

  /// Picks the first screen: creating the account, or the recovery link of an email.
  Future<void> start({bool createAccount = false, String? resetToken}) async {
    if (resetToken != null) {
      emit(state.copyWith(step: IamStep.checkingLink, resetToken: resetToken));
      await checkResetLink();
    } else if (createAccount) {
      emit(state.copyWith(step: IamStep.createAccount));
    }
    final answers = await onboardingRepository.answers();
    if (!isClosed) emit(state.copyWith(firstName: answers.firstName));
  }

  void goTo(IamStep step) => emit(state.copyWith(step: step, failure: null, notice: null));

  /// Back arrow and system back. False on the first screen, so the screen can be left.
  bool back() {
    final target = switch (state.step) {
      IamStep.signIn || IamStep.createAccount => null,
      // The account already waits for its code: going back to create it would only end
      // in a repeated code, so back leaves to sign-in with the email still filled in.
      IamStep.verify ||
      IamStep.forgot ||
      IamStep.newPassword ||
      IamStep.checkingLink ||
      IamStep.linkExpired ||
      IamStep.resetDone =>
        IamStep.signIn,
      IamStep.linkSent => IamStep.forgot,
    };
    if (target == null) return false;
    goTo(target);
    return true;
  }

  void onEmail(String value) => emit(state.copyWith(email: value, failure: null));

  void onPassword(String value) => emit(state.copyWith(password: value, failure: null));

  void onConfirmPassword(String value) =>
      emit(state.copyWith(confirmPassword: value, failure: null));

  void onCode(String value) {
    var digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > IamUiState.codeLength) digits = digits.substring(0, IamUiState.codeLength);
    emit(state.copyWith(code: digits, failure: null));
    if (digits.length == IamUiState.codeLength) unawaited(_verify());
  }

  /// The sign-in link of the taken-email error: sign-in with the email prefilled.
  void goToSignInWithEmail() =>
      emit(state.copyWith(step: IamStep.signIn, password: '', failure: null));

  Future<void> signIn() async {
    if (!state.canSignIn || state.loading) return;
    await _request(() async {
      try {
        await signInUseCase.execute(state.normalizedEmail, state.password);
        await onboardingRepository.clear();
        emit(state.copyWith(authenticated: true, password: ''));
      } on EmailNotVerified {
        // Right password, unverified email: continue with a fresh code.
        emit(state.copyWith(step: IamStep.verify, pendingEmail: state.normalizedEmail, code: ''));
        unawaited(resend());
      }
    });
  }

  Future<void> signUp() async {
    if (!state.canCreateAccount || state.loading) return;
    await _request(() async {
      final answers = await onboardingRepository.answers();
      try {
        final email = await signUpUseCase.execute(Registration(
          email: state.normalizedEmail,
          password: state.password,
          fullName: answers.fullName,
          countryIso: answers.countryIso,
          nationalPhone: answers.nationalPhone,
          termsAccepted: answers.termsAccepted,
        ));
        emit(state.copyWith(step: IamStep.verify, pendingEmail: email, code: '', notice: null));
        _startCountdown(_resendCooldownSeconds);
      } on CodeNotYetResendable catch (failure) {
        // The pending account got a code moments ago: wait for that one.
        emit(state.copyWith(step: IamStep.verify, pendingEmail: state.normalizedEmail, code: ''));
        _startCountdown(failure.retryAfterSeconds ?? _resendCooldownSeconds);
      }
    });
  }

  Future<void> _verify() async {
    if (state.code.length != IamUiState.codeLength || state.loading) return;
    await _request(() async {
      try {
        await verifyEmailUseCase.execute(state.pendingEmail, state.code);
        // The answers only live until the email is verified: they're on the profile now.
        await onboardingRepository.clear();
        emit(state.copyWith(authenticated: true, password: '', confirmPassword: ''));
      } on AuthFailure catch (failure) {
        // A dead code can be replaced right away, with no need to wait out the cooldown.
        if (failure is CodeAttemptsExceeded || failure is CodeExpired || failure is NoActiveCode) {
          _stopCountdown();
        }
        rethrow;
      }
    });
  }

  Future<void> resend() async {
    final target = state.pendingEmail.isEmpty ? state.normalizedEmail : state.pendingEmail;
    if (target.isEmpty || state.resendSeconds > 0) return;
    try {
      await resendCodeUseCase.execute(target);
      if (isClosed) return;
      emit(state.copyWith(code: '', failure: null, notice: IamNotice.codeResent));
      _startCountdown(_resendCooldownSeconds);
    } on CodeNotYetResendable catch (failure) {
      if (!isClosed) _startCountdown(failure.retryAfterSeconds ?? _resendCooldownSeconds);
    } on AuthFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(failure: failure));
    }
  }

  Future<void> requestResetLink({bool isResend = false}) async {
    if (!state.emailValid || state.loading) return;
    await _request(() async {
      await requestPasswordResetUseCase.execute(state.normalizedEmail);
      emit(state.copyWith(
        step: IamStep.linkSent,
        notice: isResend ? IamNotice.linkResent : null,
      ));
    });
  }

  Future<void> checkResetLink() async {
    final token = state.resetToken;
    if (token == null) {
      emit(state.copyWith(step: IamStep.linkExpired));
      return;
    }
    await _request(() async {
      try {
        await checkPasswordResetLinkUseCase.execute(token);
        emit(state.copyWith(step: IamStep.newPassword));
      } on ResetLinkExpired {
        emit(state.copyWith(step: IamStep.linkExpired));
      }
    });
  }

  Future<void> saveNewPassword() async {
    final token = state.resetToken;
    if (!state.canSaveNewPassword || state.loading || token == null) return;
    await _request(() async {
      try {
        await resetPasswordUseCase.execute(token, state.password);
        emit(state.copyWith(
          step: IamStep.resetDone,
          password: '',
          confirmPassword: '',
          resetToken: null,
        ));
      } on ResetLinkExpired {
        emit(state.copyWith(step: IamStep.linkExpired));
      }
    });
  }

  Future<void> _request(Future<void> Function() block) async {
    emit(state.copyWith(loading: true, failure: null));
    try {
      await block();
    } on AuthFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(failure: failure));
    } finally {
      if (!isClosed) emit(state.copyWith(loading: false));
    }
  }

  void _startCountdown(int seconds) {
    _countdown?.cancel();
    emit(state.copyWith(resendSeconds: seconds));
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      final left = state.resendSeconds - 1;
      emit(state.copyWith(resendSeconds: left));
      if (left <= 0) timer.cancel();
    });
  }

  void _stopCountdown() {
    _countdown?.cancel();
    emit(state.copyWith(resendSeconds: 0));
  }

  @override
  Future<void> close() {
    _countdown?.cancel();
    return super.close();
  }
}
