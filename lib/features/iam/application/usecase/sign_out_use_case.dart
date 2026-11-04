import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> execute() => repository.signOut();
}
