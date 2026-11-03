import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class VerifyEmailUseCase {
  const VerifyEmailUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> execute(String email, String code) => repository.verifyEmail(email, code);
}
