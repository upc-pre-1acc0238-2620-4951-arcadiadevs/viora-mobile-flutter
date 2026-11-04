import 'package:viora/features/profiles/domain/repository/profile_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase({required this.repository});

  final ProfileRepository repository;

  Future<void> execute({
    required String fullName,
    required String countryIso,
    required String phoneNumber,
  }) =>
      repository.update(fullName: fullName, countryIso: countryIso, phoneNumber: phoneNumber);
}
