import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class ResetPasswordUseCase {
  const ResetPasswordUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> execute(String token, String newPassword) => repository.resetPassword(token, newPassword);
}
