import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// What each error of the server means for the roster and the codes. An error it doesn't
/// recognize is a generic failure, so the screens never show a misleading one.
abstract final class CooperativeErrorMapper {
  static const _insufficientSeats = 'subscription.license.insufficient_seats';
  static const _insufficientArea = 'subscription.license.insufficient_area';
  static const _alreadyRedeemed = 'subscription.invitation_code.already_redeemed';
  static const _notAvailable = 'subscription.invitation_code.not_available';

  static CooperativeFailure read(ApiException error) => switch (error.status) {
        403 => const CooperativeNoLicense(),
        _ => const CooperativeUnexpected(),
      };

  static CooperativeFailure issue(ApiException error) => switch (error.status) {
        409 when error.reason == _insufficientSeats =>
          NotEnoughSeats((error.body['seatsFree'] as num?)?.toInt()),
        409 when error.reason == _insufficientArea =>
          NotEnoughArea((error.body['freeAreaHa'] as num?)?.toDouble()),
        403 => const CooperativeNoLicense(),
        503 => const CodesUnavailable(),
        _ => const CooperativeUnexpected(),
      };

  static CooperativeFailure revoke(ApiException error) => switch (error.status) {
        409 when error.reason == _alreadyRedeemed => CodeAlreadyRedeemed(
            error.body['redeemedAt'] is String ? DateTime.tryParse(error.body['redeemedAt'] as String) : null,
          ),
        409 when error.reason == _notAvailable => const CodeNotAvailable(),
        404 => const CodeNotAvailable(),
        _ => const CooperativeUnexpected(),
      };
}
