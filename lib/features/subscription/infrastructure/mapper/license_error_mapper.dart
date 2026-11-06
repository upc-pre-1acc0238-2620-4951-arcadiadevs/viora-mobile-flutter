import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';

/// What each error of the server means for the license. An error it doesn't recognize is a
/// generic failure, so the screens never show a misleading one.
abstract final class LicenseErrorMapper {
  static const _notRedeemable = 'subscription.manager_code.not_redeemable';
  static const _alreadyLicensed = 'subscription.manager.already_licensed';

  static LicenseFailure activate(ApiException error) => switch (error.status) {
        // A malformed code never leaves the phone, so any 400 is a code that can't be used.
        400 when error.reason == _notRedeemable || error.reason == null =>
          const LicenseCodeNotRedeemable(),
        409 when error.reason == _alreadyLicensed => const LicenseAlreadyHeld(),
        429 => LicenseTooManyAttempts(error.retryAfterSeconds),
        _ => const LicenseUnexpected(),
      };

  static LicenseFailure refresh(ApiException error) => const LicenseUnexpected();
}
