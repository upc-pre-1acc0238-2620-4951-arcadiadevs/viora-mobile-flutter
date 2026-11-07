import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';

/// G41: one member in full.
class GetMemberUseCase {
  const GetMemberUseCase({required this.repository});

  final CooperativeRepository repository;

  Future<MemberDetail> execute(String id) => repository.member(id);
}
