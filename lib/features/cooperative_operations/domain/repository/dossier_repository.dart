import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';

/// The provisional dossier of the plots of the members who share.
abstract class DossierRepository {
  Future<ProvisionalDossier> provisional(String plotId);

  /// The same dossier as a PDF, cut off at the moment it is asked.
  Future<DossierFile> provisionalPdf(String plotId);
}

/// Takes a document out of Viora: to a folder the manager picks, or to another app.
abstract class DocumentExporter {
  /// Asks where to keep [file]; false when the manager cancels.
  Future<bool> save(DossierFile file);

  /// Opens the share sheet of the phone with [file].
  Future<void> share(DossierFile file, {required String subject});
}
