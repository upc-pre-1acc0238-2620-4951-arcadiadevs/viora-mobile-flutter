import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plot_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/risk_plot_ui_state.dart';

/// G23 · Parcela del socio: one plot, read-only, as the manager prepares a visit.
class RiskPlotViewModel extends Cubit<RiskPlotUiState> {
  RiskPlotViewModel({required this.getPlot, this.getKeptPlot}) : super(const RiskPlotUiState());

  final GetRiskPlotUseCase getPlot;

  /// The plot as last read, shown with its date when there is no connection.
  final GetKeptRiskPlotUseCase? getKeptPlot;

  Future<void> load(String plotId) async {
    emit(const RiskPlotUiState());
    try {
      final plot = await getPlot.execute(plotId);
      if (!isClosed) emit(RiskPlotUiState(loading: false, plot: plot));
    } on CooperativeOffline catch (failure) {
      final kept = await getKeptPlot?.execute(plotId);
      if (isClosed) return;
      emit(kept == null
          ? RiskPlotUiState(loading: false, failure: failure)
          : RiskPlotUiState(loading: false, plot: kept.value, savedAt: kept.savedAt));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(RiskPlotUiState(loading: false, failure: failure));
    }
  }
}
