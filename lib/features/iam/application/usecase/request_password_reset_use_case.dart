import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class RequestPasswordResetUseCase {
  const RequestPasswordResetUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> execute(String email) => repository.requestPasswordReset(email);
}
