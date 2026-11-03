import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class SignInUseCase {
  const SignInUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> execute(String email, String password) => repository.signIn(email, password);
}
