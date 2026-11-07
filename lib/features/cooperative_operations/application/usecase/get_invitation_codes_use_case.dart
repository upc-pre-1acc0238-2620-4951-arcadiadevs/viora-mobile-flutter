import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';

/// G42: the codes of one list.
class GetInvitationCodesUseCase {
  const GetInvitationCodesUseCase({required this.repository});

  final CooperativeRepository repository;

  Future<List<InvitationCode>> execute(InvitationCodeFilter filter) => repository.codes(filter);
}
