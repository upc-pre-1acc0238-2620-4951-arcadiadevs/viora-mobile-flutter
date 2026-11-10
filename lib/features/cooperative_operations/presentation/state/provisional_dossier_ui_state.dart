import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// What T16 is doing with the PDF.
enum DossierExport { download, share }

/// A message T16 shows once: the PDF was kept, or taking it out failed.
class DossierNotice {
  const DossierNotice.saved() : failure = null;

  const DossierNotice.failed(CooperativeFailure this.failure);

  final CooperativeFailure? failure;
}

/// T16 · Expediente técnico.
class ProvisionalDossierUiState {
  const ProvisionalDossierUiState({this.loading = true, this.failure, this.dossier, this.exporting, this.notice});

  final bool loading;
  final CooperativeFailure? failure;
  final ProvisionalDossier? dossier;

  /// The PDF being asked for; the buttons wait while it arrives.
  final DossierExport? exporting;

  /// Each new notice is a new instance, so the same message can be shown twice in a row.
  final DossierNotice? notice;

  ProvisionalDossierUiState exportingAs(DossierExport kind) =>
      ProvisionalDossierUiState(loading: false, dossier: dossier, exporting: kind);

  ProvisionalDossierUiState exported([DossierNotice? notice]) =>
      ProvisionalDossierUiState(loading: false, dossier: dossier, notice: notice);
}
