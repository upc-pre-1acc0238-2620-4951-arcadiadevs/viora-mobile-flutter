import 'package:viora/features/cooperative_operations/domain/entity/sector_zone.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// G45 · Sectores, with what its sheets (G46 and G47) are doing.
class SectorsUiState {
  const SectorsUiState({
    this.loading = true,
    this.failure,
    this.sectors = const [],
    this.pending = const [],
    this.saving = false,
    this.sheetFailure,
  });

  final bool loading;

  /// The list could not be read.
  final CooperativeFailure? failure;
  final List<SectorZone> sectors;
  final List<PendingSector> pending;

  /// A sheet is sending its answer.
  final bool saving;

  /// Why the open sheet could not save: a name taken or invalid, or the connection.
  final CooperativeFailure? sheetFailure;

  SectorsUiState copyWith({
    bool? loading,
    CooperativeFailure? Function()? failure,
    List<SectorZone>? sectors,
    List<PendingSector>? pending,
    bool? saving,
    CooperativeFailure? Function()? sheetFailure,
  }) =>
      SectorsUiState(
        loading: loading ?? this.loading,
        failure: failure != null ? failure() : this.failure,
        sectors: sectors ?? this.sectors,
        pending: pending ?? this.pending,
        saving: saving ?? this.saving,
        sheetFailure: sheetFailure != null ? sheetFailure() : this.sheetFailure,
      );
}
