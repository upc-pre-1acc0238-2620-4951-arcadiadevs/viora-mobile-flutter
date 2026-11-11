import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/sector_use_cases.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/sectors_ui_state.dart';

/// G45 · Sectores and its sheets: G46 · Revisar sector and G47 · Añadir sector (also to rename).
class SectorsViewModel extends Cubit<SectorsUiState> {
  SectorsViewModel({
    required this.getSectors,
    required this.saveSector,
    required this.resolvePending,
  }) : super(const SectorsUiState());

  final GetSectorsUseCase getSectors;
  final SaveSectorUseCase saveSector;
  final ResolvePendingSectorUseCase resolvePending;

  /// Reads the list again; what is on screen stays if it fails after a first read.
  Future<void> load() async {
    _emit(state.copyWith(loading: state.sectors.isEmpty && state.pending.isEmpty, failure: () => null));
    try {
      final read = await getSectors.execute();
      _emit(state.copyWith(loading: false, sectors: read.sectors, pending: read.pending));
    } on CooperativeFailure catch (failure) {
      final empty = state.sectors.isEmpty && state.pending.isEmpty;
      _emit(state.copyWith(loading: false, failure: empty ? () => failure : null));
    }
  }

  /// G47: adds [name], or renames [sectorId]. True when the sheet can close.
  Future<bool> save(String name, {String? sectorId}) =>
      _send(() => saveSector.execute(name, sectorId: sectorId));

  /// G46: «Añadir como sector» without [sectorId], «Es el mismo que…» with it. A plot someone
  /// already resolved closes the sheet as well: the list read again shows how it was left.
  Future<bool> resolve(String plotId, {String? sectorId}) =>
      _send(() => resolvePending.execute(plotId, sectorId: sectorId), alreadyDone: (f) => f is SectorAlreadyResolved);

  /// A sheet opens clean.
  void clearSheetFailure() => _emit(state.copyWith(sheetFailure: () => null));

  Future<bool> _send(Future<void> Function() request, {bool Function(CooperativeFailure)? alreadyDone}) async {
    if (state.saving) return false;
    _emit(state.copyWith(saving: true, sheetFailure: () => null));
    try {
      await request();
    } on CooperativeFailure catch (failure) {
      if (alreadyDone == null || !alreadyDone(failure)) {
        _emit(state.copyWith(saving: false, sheetFailure: () => failure));
        return false;
      }
    }
    _emit(state.copyWith(saving: false));
    await load();
    return true;
  }

  void _emit(SectorsUiState next) {
    if (!isClosed) emit(next);
  }
}
