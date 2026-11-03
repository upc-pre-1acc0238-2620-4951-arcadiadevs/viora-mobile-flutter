import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class ResendCodeUseCase {
  const ResendCodeUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> execute(String email) => repository.resendCode(email);
}
