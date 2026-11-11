import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plots_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/presentation/state/sector_detail_ui_state.dart';

/// G22 · Detalle del sector: the plots of one scope, in visit order.
class SectorDetailViewModel extends Cubit<SectorDetailUiState> {
  SectorDetailViewModel({required this.getPlots, required this.location, this.getKeptPlots})
      : super(const SectorDetailUiState());

  final GetRiskPlotsUseCase getPlots;
  final LocationRepository location;

  /// The map of the last read, shown with its date when there is no connection.
  final GetKeptRiskPlotsUseCase? getKeptPlots;

  Future<void> load(String scope) async {
    emit(SectorDetailUiState(scope: scope));
    try {
      final plots = await getPlots.execute(origin: location.lastKnown?.coordinate);
      if (!isClosed) _show(scope, plots, savedAt: null);
    } on CooperativeOffline catch (failure) {
      final kept = await getKeptPlots?.execute();
      if (isClosed) return;
      if (kept == null) {
        emit(SectorDetailUiState(loading: false, scope: scope, failure: failure));
      } else {
        _show(scope, kept.value, savedAt: kept.savedAt);
      }
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(SectorDetailUiState(loading: false, scope: scope, failure: failure));
    }
  }

  void _show(String scope, List<RiskPlot> plots, {required DateTime? savedAt}) {
    final territory = RiskTerritory(plots);
    final sector = territory.sector(scope);
    final group = switch (scope) {
      RiskScopes.nearby => territory.nearby,
      RiskScopes.pending => territory.pending,
      RiskScopes.unassigned => territory.unassigned,
      RiskScopes.visits => territory.visits,
      _ => sector?.group ?? const RiskGroup([]),
    };
    emit(SectorDetailUiState(
      loading: false,
      scope: scope,
      title: sector?.name ?? '',
      plots: group.plots,
      // "Ver visitas por cercanía" arrives with the closest first.
      nearestFirst: scope == RiskScopes.nearby,
      savedAt: savedAt,
    ));
  }

  void toggleOrder() => emit(state.copyWith(nearestFirst: !state.nearestFirst));

  void toggleGroup(PlotRisk risk) {
    final expanded = {...state.expanded};
    if (!expanded.remove(risk)) expanded.add(risk);
    emit(state.copyWith(expanded: expanded));
  }
}
