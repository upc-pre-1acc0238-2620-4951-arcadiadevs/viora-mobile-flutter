import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plots_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/presentation/state/sector_detail_ui_state.dart';

/// G22 · Detalle del sector: the plots of one scope, in visit order.
class SectorDetailViewModel extends Cubit<SectorDetailUiState> {
  SectorDetailViewModel({required this.getPlots, required this.location}) : super(const SectorDetailUiState());

  final GetRiskPlotsUseCase getPlots;
  final LocationRepository location;

  Future<void> load(String scope) async {
    emit(SectorDetailUiState(scope: scope));
    try {
      final territory = RiskTerritory(await getPlots.execute(origin: location.lastKnown?.coordinate));
      if (isClosed) return;
      final sector = territory.sector(scope);
      final group = switch (scope) {
        RiskScopes.nearby => territory.nearby,
        RiskScopes.pending => territory.pending,
        RiskScopes.unassigned => territory.unassigned,
        _ => sector?.group ?? const RiskGroup([]),
      };
      emit(SectorDetailUiState(
        loading: false,
        scope: scope,
        title: sector?.name ?? '',
        plots: group.plots,
        // "Ver visitas por cercanía" arrives with the closest first.
        nearestFirst: scope == RiskScopes.nearby,
      ));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(SectorDetailUiState(loading: false, scope: scope, failure: failure));
    }
  }

  void toggleOrder() => emit(state.copyWith(nearestFirst: !state.nearestFirst));

  void toggleGroup(PlotRisk risk) {
    final expanded = {...state.expanded};
    if (!expanded.remove(risk)) expanded.add(risk);
    emit(state.copyWith(expanded: expanded));
  }
}
