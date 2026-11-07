import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';

/// The members and codes of the manager's license. Everything is read from the server: the
/// roster and the seats change as producers redeem codes. Fails with a `CooperativeFailure`.
abstract interface class CooperativeRepository {
  Future<LicenseCapacity> capacity();

  Future<List<CooperativeMember>> members();

  Future<MemberDetail> member(String id);

  Future<List<InvitationCode>> codes(InvitationCodeFilter filter);

  /// Issues [quantity] codes of [hectaresPerCode] each, valid for [validityDays].
  Future<IssuedCodes> issue({
    required int quantity,
    required double hectaresPerCode,
    required int validityDays,
  });

  /// Nobody can use the code afterwards; its seat and hectares return to the license.
  Future<void> revoke(String codeId);
}
