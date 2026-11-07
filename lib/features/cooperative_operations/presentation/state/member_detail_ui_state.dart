import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// G41 · Socio and its "Retiró el acceso" variant.
class MemberDetailUiState {
  const MemberDetailUiState({this.loading = true, this.failure, this.member, this.organizationName});

  final bool loading;
  final CooperativeFailure? failure;
  final MemberDetail? member;
  final String? organizationName;
}
