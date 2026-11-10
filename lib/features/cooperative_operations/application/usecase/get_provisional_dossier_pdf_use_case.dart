import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';
import 'package:viora/features/cooperative_operations/domain/repository/dossier_repository.dart';

class GetProvisionalDossierPdfUseCase {
  const GetProvisionalDossierPdfUseCase({required this.repository});

  final DossierRepository repository;

  Future<DossierFile> execute(String plotId) => repository.provisionalPdf(plotId);
}
