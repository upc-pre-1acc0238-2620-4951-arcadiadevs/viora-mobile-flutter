import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';

/// The members and codes of the manager's license. Everything is read from the server: the
/// roster and the seats change as producers redeem codes. Fails with a `CooperativeFailure`.
/// The last capacity, roster and codes read are kept for the screens without a connection.
abstract interface class CooperativeRepository {
  Future<LicenseCapacity> capacity();

  Future<Kept<LicenseCapacity>?> keptCapacity();

  Future<List<CooperativeMember>> members();

  Future<Kept<List<CooperativeMember>>?> keptMembers();

  Future<MemberDetail> member(String id);

  Future<List<InvitationCode>> codes(InvitationCodeFilter filter);

  Future<Kept<List<InvitationCode>>?> keptCodes(InvitationCodeFilter filter);

  /// Issues [quantity] codes of [hectaresPerCode] each, valid for [validityDays].
  Future<IssuedCodes> issue({
    required int quantity,
    required double hectaresPerCode,
    required int validityDays,
  });

  /// Nobody can use the code afterwards; its seat and hectares return to the license.
  Future<void> revoke(String codeId);
}
