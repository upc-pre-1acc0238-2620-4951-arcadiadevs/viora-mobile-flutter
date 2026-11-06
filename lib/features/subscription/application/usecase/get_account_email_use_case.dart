import 'package:viora/features/subscription/domain/repository/license_repository.dart';

class GetAccountEmailUseCase {
  const GetAccountEmailUseCase({required this.repository});

  final LicenseRepository repository;

  Future<String?> execute() => repository.accountEmail();
}
