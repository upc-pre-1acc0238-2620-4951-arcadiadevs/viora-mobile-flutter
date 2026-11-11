import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// G23 · Parcela del socio and its "Sin datos suficientes" variant.
class RiskPlotUiState {
  const RiskPlotUiState({this.loading = true, this.failure, this.plot, this.savedAt});

  final bool loading;
  final CooperativeFailure? failure;
  final RiskPlotDetail? plot;

  /// When the plot shown was kept, without a connection; null when it was just read.
  final DateTime? savedAt;
}
