import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/manager_alerts_ui_state.dart';

/// T14 · Alertas del gestor: the alerts of the license's sectors, which stay visible even when
/// the producer silenced them on their phone (US31).
class ManagerAlertsViewModel extends Cubit<ManagerAlertsUiState> {
  ManagerAlertsViewModel({required this.getAlerts, this.getKeptAlerts, DateTime Function()? clock})
      : clock = clock ?? DateTime.now,
        super(const ManagerAlertsUiState());

  final GetSectorAlertsUseCase getAlerts;

  /// The alerts of the last read, shown with their date when there is no connection.
  final GetKeptSectorAlertsUseCase? getKeptAlerts;
  final DateTime Function() clock;

  Future<void> load() async {
    final filter = state.filter;
    emit(ManagerAlertsUiState(filter: filter));
    try {
      final alerts = await getAlerts.execute();
      if (!isClosed) emit(ManagerAlertsUiState(loading: false, alerts: alerts, readAt: clock(), filter: filter));
    } on CooperativeOffline catch (failure) {
      final kept = await getKeptAlerts?.execute();
      if (isClosed) return;
      emit(
        kept == null
            ? ManagerAlertsUiState(loading: false, failure: failure, filter: filter)
            : ManagerAlertsUiState(
                loading: false,
                alerts: kept.value,
                readAt: kept.savedAt,
                offline: true,
                filter: filter,
              ),
      );
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(ManagerAlertsUiState(loading: false, failure: failure, filter: filter));
    }
  }

  /// A second tap on the same capsule shows every alert again.
  void toggleFilter(AlertFilter filter) => emit(state.withFilter(state.filter == filter ? null : filter));
}
