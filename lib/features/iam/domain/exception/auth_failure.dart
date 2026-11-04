/// Why an account operation failed, in the terms the screens react to. Screens never see
/// HTTP.
sealed class AuthFailure implements Exception {
  const AuthFailure();
}

/// The server couldn't be reached.
class AuthOffline extends AuthFailure {
  const AuthOffline();
}

/// Too many attempts in a short time.
class AuthTooManyRequests extends AuthFailure {
  const AuthTooManyRequests();
}

/// Anything else, shown as a generic failure.
class AuthUnexpected extends AuthFailure {
  const AuthUnexpected();
}

/// Wrong email or password. The server doesn't say which one.
class InvalidCredentials extends AuthFailure {
  const InvalidCredentials();
}

/// The current password typed to change it is wrong.
class CurrentPasswordIncorrect extends AuthFailure {
  const CurrentPasswordIncorrect();
}

/// Right password, but the account has a role this app doesn't serve.
class AccountOfOtherRole extends AuthFailure {
  const AccountOfOtherRole();
}

/// Right password, but the email was never verified.
class EmailNotVerified extends AuthFailure {
  const EmailNotVerified();
}

/// The email is still signing up with a role this app doesn't serve.
class EmailPendingWithOtherRole extends AuthFailure {
  const EmailPendingWithOtherRole();
}

/// The email already has an active account.
class EmailTaken extends AuthFailure {
  const EmailTaken();
}

/// The server refused the mobile number of the profile.
class PhoneRejected extends AuthFailure {
  const PhoneRejected();
}

/// The password doesn't meet the server's rules.
class WeakPassword extends AuthFailure {
  const WeakPassword();
}

/// The new password repeats a recent one.
class PasswordReused extends AuthFailure {
  const PasswordReused();
}

/// A code was sent too recently; [retryAfterSeconds] says how long to wait, when known.
class CodeNotYetResendable extends AuthFailure {
  const CodeNotYetResendable(this.retryAfterSeconds);

  final int? retryAfterSeconds;
}

/// The email code is wrong; [remainingAttempts] are left, when the server says.
class InvalidCode extends AuthFailure {
  const InvalidCode(this.remainingAttempts);

  final int? remainingAttempts;
}

/// Too many wrong codes: this one no longer works.
class CodeAttemptsExceeded extends AuthFailure {
  const CodeAttemptsExceeded();
}

/// The code expired.
class CodeExpired extends AuthFailure {
  const CodeExpired();
}

/// There is no code waiting for this email.
class NoActiveCode extends AuthFailure {
  const NoActiveCode();
}

/// The recovery link expired, was used or was replaced by a newer one.
class ResetLinkExpired extends AuthFailure {
  const ResetLinkExpired();
}
