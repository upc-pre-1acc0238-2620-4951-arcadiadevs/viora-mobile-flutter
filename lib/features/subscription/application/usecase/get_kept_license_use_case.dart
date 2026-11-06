import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/repository/license_repository.dart';

class GetKeptLicenseUseCase {
  const GetKeptLicenseUseCase({required this.repository});

  final LicenseRepository repository;

  Future<ManagerLicense?> execute() => repository.kept();
}
