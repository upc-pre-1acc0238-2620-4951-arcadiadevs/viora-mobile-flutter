import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class ChangePasswordUseCase {
  const ChangePasswordUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> execute(String currentPassword, String newPassword) =>
      repository.changePassword(currentPassword, newPassword);
}
