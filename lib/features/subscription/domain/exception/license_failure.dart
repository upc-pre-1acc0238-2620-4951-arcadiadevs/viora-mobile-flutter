/// Why reading or activating the license failed, in the terms the screens react to. Screens
/// never see HTTP.
sealed class LicenseFailure implements Exception {
  const LicenseFailure();
}

/// The server couldn't be reached.
class LicenseOffline extends LicenseFailure {
  const LicenseOffline();
}

/// Anything else, shown as a generic failure.
class LicenseUnexpected extends LicenseFailure {
  const LicenseUnexpected();
}

/// The code doesn't exist, expired, was used or revoked, or its license isn't in force. The
/// server doesn't say which.
class LicenseCodeNotRedeemable extends LicenseFailure {
  const LicenseCodeNotRedeemable();
}

/// Too many codes tried; [retryAfterSeconds] says how long to wait, when known.
class LicenseTooManyAttempts extends LicenseFailure {
  const LicenseTooManyAttempts(this.retryAfterSeconds);

  final int? retryAfterSeconds;
}

/// The manager is already in charge of a license in force.
class LicenseAlreadyHeld extends LicenseFailure {
  const LicenseAlreadyHeld();
}
