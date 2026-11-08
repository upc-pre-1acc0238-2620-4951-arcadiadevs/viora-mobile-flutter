import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plot_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/risk_plot_ui_state.dart';

/// G23 · Parcela del socio: one plot, read-only, as the manager prepares a visit.
class RiskPlotViewModel extends Cubit<RiskPlotUiState> {
  RiskPlotViewModel({required this.getPlot}) : super(const RiskPlotUiState());

  final GetRiskPlotUseCase getPlot;

  Future<void> load(String plotId) async {
    emit(const RiskPlotUiState());
    try {
      final plot = await getPlot.execute(plotId);
      if (!isClosed) emit(RiskPlotUiState(loading: false, plot: plot));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(RiskPlotUiState(loading: false, failure: failure));
    }
  }
}
