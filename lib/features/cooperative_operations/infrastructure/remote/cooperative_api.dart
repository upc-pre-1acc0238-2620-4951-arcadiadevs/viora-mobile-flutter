import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/cooperative_member_dto.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/invitation_code_dto.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/license_capacity_dto.dart';

/// The roster, the license capacity and the codes of the signed-in manager.
class CooperativeApi {
  const CooperativeApi({required this.client});

  final ApiClient client;

  /// The licenses the manager is in charge of, with their capacity: one at most.
  Future<List<LicenseCapacityDto>> licenses() async =>
      (await client.getList('cooperative-licenses')).map(LicenseCapacityDto.fromJson).toList();

  Future<List<CooperativeMemberDto>> members() async =>
      (await client.getList('cooperative-members')).map(CooperativeMemberDto.fromJson).toList();

  Future<MemberDetailDto> member(String id) async =>
      MemberDetailDto.fromJson(await client.get('cooperative-members/$id'));

  Future<List<InvitationCodeDto>> codes(String status) async =>
      (await client.getList('invitation-codes?status=$status')).map(InvitationCodeDto.fromJson).toList();

  Future<IssuedCodesDto> issue(IssueInvitationCodesRequestDto request) async =>
      IssuedCodesDto.fromJson(await client.post('invitation-codes', request.toMap()));

  Future<void> revoke(String id) async {
    await client.post('invitation-codes/$id/revocations', const {});
  }
}
