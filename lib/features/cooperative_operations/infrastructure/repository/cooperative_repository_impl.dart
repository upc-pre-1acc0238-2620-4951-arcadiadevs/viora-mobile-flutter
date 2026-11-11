import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';
import 'package:viora/features/cooperative_operations/infrastructure/local/manager_snapshot_store.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/cooperative_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/cooperative_member_dto.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/invitation_code_dto.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/license_capacity_dto.dart';

class CooperativeRepositoryImpl implements CooperativeRepository {
  const CooperativeRepositoryImpl({required this.api, this.snapshots});

  static const _capacityKey = 'license-capacity';
  static const _membersKey = 'cooperative-members';
  static const _codesKey = 'invitation-codes';

  final CooperativeApi api;

  /// Keeps the last capacity, roster and codes for the screens without a connection. Null keeps
  /// nothing.
  final ManagerSnapshotStore? snapshots;

  @override
  Future<LicenseCapacity> capacity() => _call(() async {
        final licenses = await api.licenses();
        if (licenses.isEmpty) throw const CooperativeNoLicense();
        await snapshots?.keep(_capacityKey, licenses.first.json);
        return licenses.first.toDomain();
      }, CooperativeErrorMapper.read);

  @override
  Future<Kept<LicenseCapacity>?> keptCapacity() async {
    final kept = await snapshots?.read(_capacityKey);
    if (kept == null) return null;
    return Kept(LicenseCapacityDto(kept.value! as Map<String, dynamic>).toDomain(), kept.savedAt);
  }

  @override
  Future<List<CooperativeMember>> members() => _call(() async {
        final dtos = await api.members();
        await snapshots?.keep(_membersKey, [for (final dto in dtos) dto.json]);
        return dtos.map((dto) => dto.toDomain()).toList();
      }, CooperativeErrorMapper.read);

  @override
  Future<Kept<List<CooperativeMember>>?> keptMembers() async {
    final kept = await snapshots?.read(_membersKey);
    if (kept == null) return null;
    return Kept([for (final json in _objects(kept.value)) CooperativeMemberDto(json).toDomain()], kept.savedAt);
  }

  @override
  Future<MemberDetail> member(String id) =>
      _call(() async => (await api.member(id)).toDomain(), CooperativeErrorMapper.read);

  @override
  Future<List<InvitationCode>> codes(InvitationCodeFilter filter) => _call(() async {
        final dtos = await api.codes(filter.query);
        await snapshots?.keep('$_codesKey/${filter.query}', [for (final dto in dtos) dto.json]);
        return dtos.map((dto) => dto.toDomain()).toList();
      }, CooperativeErrorMapper.read);

  @override
  Future<Kept<List<InvitationCode>>?> keptCodes(InvitationCodeFilter filter) async {
    final kept = await snapshots?.read('$_codesKey/${filter.query}');
    if (kept == null) return null;
    return Kept([for (final json in _objects(kept.value)) InvitationCodeDto(json).toDomain()], kept.savedAt);
  }

  @override
  Future<IssuedCodes> issue({
    required int quantity,
    required double hectaresPerCode,
    required int validityDays,
  }) =>
      _call(
        () async => (await api.issue(IssueInvitationCodesRequestDto(
          quantity: quantity,
          hectaresPerCode: hectaresPerCode,
          validityDays: validityDays,
        )))
            .toDomain(),
        CooperativeErrorMapper.issue,
      );

  @override
  Future<void> revoke(String codeId) => _call(() => api.revoke(codeId), CooperativeErrorMapper.revoke);

  static List<Map<String, dynamic>> _objects(Object? json) => (json! as List<dynamic>).cast<Map<String, dynamic>>();

  Future<T> _call<T>(Future<T> Function() request, CooperativeFailure Function(ApiException) map) async {
    try {
      return await request();
    } on ApiUnreachableException {
      throw const CooperativeOffline();
    } on ApiException catch (error) {
      throw map(error);
    }
  }
}
