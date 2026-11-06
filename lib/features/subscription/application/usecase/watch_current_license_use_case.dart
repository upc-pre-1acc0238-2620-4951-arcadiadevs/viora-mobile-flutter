import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/repository/license_repository.dart';

class WatchCurrentLicenseUseCase {
  const WatchCurrentLicenseUseCase({required this.repository});

  final LicenseRepository repository;

  Stream<ManagerLicense?> execute() => repository.watchCurrent();
}
