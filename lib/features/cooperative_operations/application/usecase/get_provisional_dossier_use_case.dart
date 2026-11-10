import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';
import 'package:viora/features/cooperative_operations/domain/repository/dossier_repository.dart';

class GetProvisionalDossierUseCase {
  const GetProvisionalDossierUseCase({required this.repository});

  final DossierRepository repository;

  Future<ProvisionalDossier> execute(String plotId) => repository.provisional(plotId);
}
