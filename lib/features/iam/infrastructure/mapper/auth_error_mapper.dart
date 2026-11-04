import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';

/// What each error of the server means for an operation. An error it doesn't recognize is
/// left unmapped, so the screens show a generic failure instead of a misleading one.
abstract final class AuthErrorMapper {
  static const _invalidCredentials = 'USER_FORBIDDEN';
  static const _emailNotVerified = 'EMAIL_VERIFICATION_FORBIDDEN';
  static const _otherRole = 'USER_ROLE_FORBIDDEN';
  static const _pendingWithOtherRole = 'user.role.sign_up_not_allowed';
  static const _invalidCode = 'user.email_verification.invalid_code';
  static const _codeAttemptsExceeded = 'user.email_verification.attempts_exceeded';
  static const _codeExpired = 'user.email_verification.code_expired';
  static const _noActiveCode = 'user.email_verification.no_active_code';
  static const _passwordReused = 'user.password.reused';
  static const _currentPasswordInvalid = 'user.password.current_invalid';

  static AuthFailure? signIn(ApiException error) {
    if (error.status != 403) return null;
    return switch (error.code) {
      _invalidCredentials => const InvalidCredentials(),
      _emailNotVerified => const EmailNotVerified(),
      _otherRole => const AccountOfOtherRole(),
      _ => null,
    };
  }

  static AuthFailure? signUp(ApiException error) => switch (error.status) {
        409 => const EmailTaken(),
        400 when error.reason == _pendingWithOtherRole => const EmailPendingWithOtherRole(),
        400 when _breaksPasswordRules(error) => const WeakPassword(),
        // The numbering plan of the server refuses the number as a business rule.
        422 => const PhoneRejected(),
        429 => CodeNotYetResendable(error.retryAfterSeconds),
        _ => null,
      };

  static AuthFailure? verifyEmail(ApiException error) {
    if (error.status != 422) return null;
    return switch (error.reason) {
      _invalidCode => InvalidCode((error.body['remainingAttempts'] as num?)?.toInt()),
      _codeAttemptsExceeded => const CodeAttemptsExceeded(),
      _codeExpired => const CodeExpired(),
      _noActiveCode => const NoActiveCode(),
      _ => null,
    };
  }

  static AuthFailure? resendCode(ApiException error) =>
      error.status == 429 ? CodeNotYetResendable(error.retryAfterSeconds) : null;

  static AuthFailure? checkPasswordResetLink(ApiException error) =>
      error.status == 404 ? const ResetLinkExpired() : null;

  static AuthFailure? resetPassword(ApiException error) => switch (error.status) {
        404 => const ResetLinkExpired(),
        422 when error.reason == _passwordReused => const PasswordReused(),
        400 when _breaksPasswordRules(error) => const WeakPassword(),
        _ => null,
      };

  static AuthFailure? changePassword(ApiException error) => switch (error.status) {
        422 when error.reason == _currentPasswordInvalid => const CurrentPasswordIncorrect(),
        422 when error.reason == _passwordReused => const PasswordReused(),
        400 when _breaksPasswordRules(error) => const WeakPassword(),
        _ => null,
      };

  static bool _breaksPasswordRules(ApiException error) => error.body['violations'] != null;
}
