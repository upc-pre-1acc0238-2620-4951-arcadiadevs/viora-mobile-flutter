import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_provisional_dossier_pdf_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_provisional_dossier_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/dossier_repository.dart';
import 'package:viora/features/cooperative_operations/presentation/state/provisional_dossier_ui_state.dart';

/// T16 · Expediente técnico: the provisional dossier of a member plot, and its PDF. The PDF is
/// asked again each time, so it carries the cut-off of that moment.
class ProvisionalDossierViewModel extends Cubit<ProvisionalDossierUiState> {
  ProvisionalDossierViewModel({required this.getDossier, required this.getPdf, required this.exporter})
      : super(const ProvisionalDossierUiState());

  final GetProvisionalDossierUseCase getDossier;
  final GetProvisionalDossierPdfUseCase getPdf;
  final DocumentExporter exporter;

  String? _plotId;

  Future<void> load(String plotId) async {
    _plotId = plotId;
    emit(const ProvisionalDossierUiState());
    try {
      final dossier = await getDossier.execute(plotId);
      if (!isClosed) emit(ProvisionalDossierUiState(loading: false, dossier: dossier));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(ProvisionalDossierUiState(loading: false, failure: failure));
    }
  }

  /// Keeps the PDF where the manager picks.
  Future<void> download() => _export(DossierExport.download, (file) async {
        final saved = await exporter.save(file);
        return saved ? const DossierNotice.saved() : null;
      });

  /// Sends the PDF to another app.
  Future<void> share({required String subject}) => _export(DossierExport.share, (file) async {
        await exporter.share(file, subject: subject);
        return null;
      });

  Future<void> _export(DossierExport kind, Future<DossierNotice?> Function(DossierFile file) send) async {
    final plotId = _plotId;
    if (plotId == null || state.dossier == null || state.exporting != null) return;
    emit(state.exportingAs(kind));
    try {
      final notice = await send(await getPdf.execute(plotId));
      if (!isClosed) emit(state.exported(notice));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(state.exported(DossierNotice.failed(failure)));
    }
  }
}
