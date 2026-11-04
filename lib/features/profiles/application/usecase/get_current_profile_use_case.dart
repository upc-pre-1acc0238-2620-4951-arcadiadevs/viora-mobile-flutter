import 'package:viora/features/profiles/domain/entity/profile.dart';
import 'package:viora/features/profiles/domain/repository/profile_repository.dart';

class GetCurrentProfileUseCase {
  const GetCurrentProfileUseCase({required this.repository});

  final ProfileRepository repository;

  Future<Profile?> execute() => repository.current();
}
