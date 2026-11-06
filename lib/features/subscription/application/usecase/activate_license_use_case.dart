import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/repository/license_repository.dart';
import 'package:viora/features/subscription/domain/valueobject/manager_code.dart';

class ActivateLicenseUseCase {
  const ActivateLicenseUseCase({required this.repository});

  final LicenseRepository repository;

  Future<ManagerLicense> execute(ManagerCode code) => repository.activate(code);
}
