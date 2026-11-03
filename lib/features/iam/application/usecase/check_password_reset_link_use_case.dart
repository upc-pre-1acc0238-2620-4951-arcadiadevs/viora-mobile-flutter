import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class CheckPasswordResetLinkUseCase {
  const CheckPasswordResetLinkUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> execute(String token) => repository.checkPasswordResetLink(token);
}
