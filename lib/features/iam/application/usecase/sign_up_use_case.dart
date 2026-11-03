import 'package:viora/features/iam/domain/valueobject/registration.dart';
import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase({required this.repository});

  final AuthRepository repository;

  Future<String> execute(Registration registration) => repository.signUp(registration);
}
