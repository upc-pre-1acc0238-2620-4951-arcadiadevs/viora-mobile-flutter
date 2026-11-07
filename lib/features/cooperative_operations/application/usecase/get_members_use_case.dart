import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';

/// G40: the roster of the license.
class GetMembersUseCase {
  const GetMembersUseCase({required this.repository});

  final CooperativeRepository repository;

  Future<List<CooperativeMember>> execute() => repository.members();
}
