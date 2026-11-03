import 'package:viora/features/iam/domain/repository/auth_repository.dart';

class IsSignedInUseCase {
  const IsSignedInUseCase({required this.repository});

  final AuthRepository repository;

  Future<bool> execute() => repository.isSignedIn();
}
