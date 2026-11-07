import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';

/// G40 and G43: the seats and hectares the license has left.
class GetLicenseCapacityUseCase {
  const GetLicenseCapacityUseCase({required this.repository});

  final CooperativeRepository repository;

  Future<LicenseCapacity> execute() => repository.capacity();
}
