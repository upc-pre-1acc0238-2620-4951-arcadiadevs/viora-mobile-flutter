import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plot_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plots_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/has_active_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/presentation/state/risk_map_ui_state.dart';

/// G20 · Riesgo territorial: the plots of the valley, where the manager stands and what they chose.
class RiskMapViewModel extends Cubit<RiskMapUiState> {
  RiskMapViewModel({
    required this.getPlots,
    this.getKeptPlots,
    required this.getPlot,
    required this.hasActiveAlerts,
    required this.location,
    DateTime Function()? clock,
  })  : clock = clock ?? DateTime.now,
        super(const RiskMapUiState());

  final GetRiskPlotsUseCase getPlots;

  /// The last map read, for G20 · Sin conexión. Null shows the failure instead.
  final GetKeptRiskPlotsUseCase? getKeptPlots;
  final DateTime Function() clock;
  final GetRiskPlotUseCase getPlot;
  final HasActiveSectorAlertsUseCase hasActiveAlerts;
  final LocationRepository location;

  Future<void> start() async {
    if (await location.hasPermission()) {
      await _locate();
    } else {
      final choice = await location.choice();
      if (choice == LocationChoice.allowed) {
        // They said yes and the permission is gone, as «Solo esta vez» does: the system asks again,
        // once the valley is on screen behind its dialog.
        _emit(state.copyWith(gpsOff: true));
        await refresh();
        await _ask(openSettings: false);
        return;
      }
      _emit(state.copyWith(gpsOff: choice != null, explainLocation: choice == null));
    }
    await refresh();
  }

  /// Back in the app, perhaps from the settings: the colors may have changed, and so the permission.
  Future<void> resume() async {
    if (state.location == null && await location.hasPermission()) await _locate();
    await refresh();
  }

  /// Reads the valley again. What is on screen stays if the read fails.
  Future<void> refresh() async {
    _emit(state.copyWith(loading: state.plots.isEmpty, failure: () => null));
    _readAlerts();
    try {
      final plots = await getPlots.execute(origin: state.location?.coordinate);
      _show(plots, readAt: clock(), savedAt: null);
    } on CooperativeOffline catch (failure) {
      // Without a connection the map stays as it was last read, with its date, never as fresh.
      if (state.plots.isNotEmpty) {
        _emit(state.copyWith(loading: false, savedAt: () => state.savedAt ?? state.readAt));
        return;
      }
      final kept = await getKeptPlots?.execute();
      if (kept == null) {
        _emit(state.copyWith(loading: false, failure: () => failure));
      } else {
        _show(kept.value, readAt: kept.savedAt, savedAt: kept.savedAt);
      }
    } on CooperativeFailure catch (failure) {
      _emit(state.copyWith(loading: false, failure: state.plots.isEmpty ? () => failure : null));
    }
  }

  void _show(List<RiskPlot> plots, {required DateTime readAt, required DateTime? savedAt}) {
    final selectionGone = !plots.any((plot) => plot.id == state.selectedPlotId);
    _emit(state.copyWith(
      loading: false,
      plots: plots,
      readAt: readAt,
      savedAt: () => savedAt,
      selectedPlotId: selectionGone ? () => null : null,
      selectedDetail: selectionGone ? () => null : null,
    ));
  }

  /// «Permitir ubicación» and «Reintentar».
  Future<void> allowLocation() async {
    _emit(state.copyWith(explainLocation: false));
    await location.saveChoice(LocationChoice.allowed);
    await _ask(openSettings: true);
  }

  /// A no to the system's dialog counts as a no: it isn't asked again until «Reintentar».
  Future<void> _ask({required bool openSettings}) async {
    if (!await location.requestPermission(openSettings: openSettings)) {
      await location.saveChoice(LocationChoice.declined);
      _emit(state.copyWith(gpsOff: true, location: () => null));
      return;
    }
    await _locate();
    await refresh();
  }

  /// «Ahora no»: the whole valley, and the manager filters by hand (G21).
  Future<void> declineLocation() async {
    _emit(state.copyWith(explainLocation: false, gpsOff: true));
    await location.saveChoice(LocationChoice.declined);
  }

  void showList(bool show) => _emit(state.copyWith(showList: show));

  /// Touching a sector's label filters by it; touching it again goes back.
  void toggleSector(String sectorId) {
    final same = state.selectedSectorId == sectorId;
    _emit(state.copyWith(
      selectedSectorId: () => same ? null : sectorId,
      selectedPlotId: () => null,
      selectedDetail: () => null,
    ));
  }

  /// Touching a plot opens its summary; touching it again or the bare map closes it.
  Future<void> tapPlot(String? plotId) async {
    final next = plotId == state.selectedPlotId ? null : plotId;
    _emit(state.copyWith(selectedPlotId: () => next, selectedDetail: () => null));
    if (next == null) return;
    try {
      final detail = await getPlot.execute(next);
      if (state.selectedPlotId == next) _emit(state.copyWith(selectedDetail: () => detail));
    } on CooperativeFailure {
      // The panel still has what the list tells; the plot's screen reports the failure.
    }
  }

  Future<void> _locate() async {
    final found = await location.current();
    _emit(state.copyWith(location: () => found, gpsOff: found == null));
  }

  Future<void> _readAlerts() async {
    try {
      final active = await hasActiveAlerts.execute();
      _emit(state.copyWith(hasActiveAlerts: active));
    } on CooperativeFailure {
      // The dot is a hint: without it the map keeps working.
    }
  }

  void _emit(RiskMapUiState next) {
    if (!isClosed) emit(next);
  }
}
