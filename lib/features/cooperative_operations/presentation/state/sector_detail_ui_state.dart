import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// G22 · Detalle del sector, and the same reading for what is near the manager or has no sector.
class SectorDetailUiState {
  const SectorDetailUiState({
    this.loading = true,
    this.failure,
    this.scope = '',
    this.title = '',
    this.plots = const [],
    this.nearestFirst = false,
    this.expanded = const {},
  });

  final bool loading;
  final CooperativeFailure? failure;

  /// A sector's id or one of [RiskScopes].
  final String scope;
  final String title;

  /// In the server's visit order.
  final List<RiskPlot> plots;
  final bool nearestFirst;

  /// The groups of "Resto del sector" opened in place.
  final Set<PlotRisk> expanded;

  RiskGroup get group => RiskGroup(plots);

  bool get canSortByDistance => plots.any((plot) => plot.distanceKm != null);

  /// The plots to visit first, numbered on screen.
  List<RiskPlot> get priority {
    final critical = plots.where((plot) => plot.risk == PlotRisk.critical).toList();
    if (nearestFirst) {
      critical.sort((a, b) => (a.distanceKm ?? double.infinity).compareTo(b.distanceKm ?? double.infinity));
    }
    return critical;
  }

  List<RiskPlot> of(PlotRisk risk) => plots.where((plot) => plot.risk == risk).toList();

  SectorDetailUiState copyWith({bool? nearestFirst, Set<PlotRisk>? expanded}) => SectorDetailUiState(
        loading: loading,
        failure: failure,
        scope: scope,
        title: title,
        plots: plots,
        nearestFirst: nearestFirst ?? this.nearestFirst,
        expanded: expanded ?? this.expanded,
      );
}
