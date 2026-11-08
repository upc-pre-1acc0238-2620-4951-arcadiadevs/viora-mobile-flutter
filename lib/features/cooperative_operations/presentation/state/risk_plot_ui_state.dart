import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// G23 · Parcela del socio and its "Sin datos suficientes" variant.
class RiskPlotUiState {
  const RiskPlotUiState({this.loading = true, this.failure, this.plot});

  final bool loading;
  final CooperativeFailure? failure;
  final RiskPlotDetail? plot;
}
