import 'package:flutter/foundation.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/core/domain/account_rules.dart';

/// The screens of the account flow.
enum IamStep {
  signIn,
  createAccount,
  verify,
  forgot,
  linkSent,
  checkingLink,
  newPassword,
  resetDone,
  linkExpired,
}

enum IamNotice { codeResent, linkResent }

@immutable
class IamUiState {
  const IamUiState({
    this.step = IamStep.signIn,
    this.loading = false,
    this.authenticated = false,
    this.firstName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.code = '',
    this.failure,
    this.pendingEmail = '',
    this.resendSeconds = 0,
    this.resetToken,
    this.notice,
  });

  static const codeLength = 6;

  final IamStep step;
  final bool loading;
  final bool authenticated;
  final String firstName;
  final String email;
  final String password;
  final String confirmPassword;
  final String code;

  /// Why the last request failed. Each screen shows it where it belongs.
  final AuthFailure? failure;

  /// Email waiting for its verification code.
  final String pendingEmail;

  /// Seconds until the code can be sent again.
  final int resendSeconds;

  /// Token of the recovery link the backend emailed.
  final String? resetToken;
  final IamNotice? notice;

  bool get emailValid => EmailAddress.isValid(email);
  String get normalizedEmail => EmailAddress.normalize(email);
  bool get passwordLongEnough => PasswordPolicy.isLongEnough(password);
  bool get passwordHasLettersAndDigits => PasswordPolicy.hasLettersAndDigits(password);
  bool get passwordOk => PasswordPolicy.isValid(password);
  bool get confirmOk => password.isNotEmpty && password == confirmPassword;
  bool get canSignIn => emailValid && password.isNotEmpty;
  bool get canCreateAccount =>
      emailValid && passwordOk && failure is! EmailTaken && failure is! EmailPendingWithOtherRole;
  bool get canSaveNewPassword => passwordOk && confirmOk && failure is! PasswordReused;

  static const _keep = Object();

  IamUiState copyWith({
    IamStep? step,
    bool? loading,
    bool? authenticated,
    String? firstName,
    String? email,
    String? password,
    String? confirmPassword,
    String? code,
    Object? failure = _keep,
    String? pendingEmail,
    int? resendSeconds,
    Object? resetToken = _keep,
    Object? notice = _keep,
  }) {
    return IamUiState(
      step: step ?? this.step,
      loading: loading ?? this.loading,
      authenticated: authenticated ?? this.authenticated,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      code: code ?? this.code,
      failure: identical(failure, _keep) ? this.failure : failure as AuthFailure?,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      resendSeconds: resendSeconds ?? this.resendSeconds,
      resetToken: identical(resetToken, _keep) ? this.resetToken : resetToken as String?,
      notice: identical(notice, _keep) ? this.notice : notice as IamNotice?,
    );
  }
}
