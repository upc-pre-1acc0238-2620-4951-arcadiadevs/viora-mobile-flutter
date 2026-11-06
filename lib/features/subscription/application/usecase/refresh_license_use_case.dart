import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/repository/license_repository.dart';

class RefreshLicenseUseCase {
  const RefreshLicenseUseCase({required this.repository});

  final LicenseRepository repository;

  Future<ManagerLicense?> execute() => repository.refresh();
}
