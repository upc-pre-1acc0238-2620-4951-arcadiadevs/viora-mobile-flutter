import 'package:viora/features/profiles/domain/entity/profile.dart';
import 'package:viora/features/profiles/domain/repository/profile_repository.dart';

class WatchCurrentProfileUseCase {
  const WatchCurrentProfileUseCase({required this.repository});

  final ProfileRepository repository;

  Stream<Profile?> execute() => repository.watchCurrent();
}
