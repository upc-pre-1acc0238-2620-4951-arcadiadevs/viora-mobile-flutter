import 'package:viora/features/profiles/domain/repository/profile_repository.dart';

class RefreshProfileUseCase {
  const RefreshProfileUseCase({required this.repository});

  final ProfileRepository repository;

  Future<void> execute() => repository.refresh();
}
