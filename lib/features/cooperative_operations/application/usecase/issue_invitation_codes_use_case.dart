import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';

/// G43: issues a batch of codes; the server checks the seats and hectares again.
class IssueInvitationCodesUseCase {
  const IssueInvitationCodesUseCase({required this.repository});

  final CooperativeRepository repository;

  Future<IssuedCodes> execute({
    required int quantity,
    required double hectaresPerCode,
    required int validityDays,
  }) =>
      repository.issue(quantity: quantity, hectaresPerCode: hectaresPerCode, validityDays: validityDays);
}
