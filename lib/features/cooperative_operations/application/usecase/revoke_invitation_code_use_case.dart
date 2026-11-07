import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';

/// G42 "Revocar": the code can't be used anymore and frees its seat and hectares.
class RevokeInvitationCodeUseCase {
  const RevokeInvitationCodeUseCase({required this.repository});

  final CooperativeRepository repository;

  Future<void> execute(String codeId) => repository.revoke(codeId);
}
