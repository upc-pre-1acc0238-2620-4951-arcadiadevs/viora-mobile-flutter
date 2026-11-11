import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_intake_forecasts_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plots_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/presentation/state/manager_home_ui_state.dart';

/// G10 · Inicio: the valley's traffic light, the license and the suggested visits.
///
/// The valley is what the Home is about, so only its failure is shown. The seats, the frost
/// alerts and the intake are read alongside; a card whose read fails is simply left out.
class ManagerHomeViewModel extends Cubit<ManagerHomeUiState> {
  ManagerHomeViewModel({
    required this.getPlots,
    required this.getCapacity,
    required this.getAlerts,
    required this.getIntake,
    required this.location,
  }) : super(const ManagerHomeUiState());

  final GetRiskPlotsUseCase getPlots;
  final GetLicenseCapacityUseCase getCapacity;
  final GetSectorAlertsUseCase getAlerts;
  final GetIntakeForecastsUseCase getIntake;

  /// The GPS is only asked on the map; the Home uses the last place the map found, if any.
  final LocationRepository location;

  /// Reads everything again. What is on screen stays if the valley can't be read.
  Future<void> load() async {
    _emit(state.copyWith(loading: true, failure: () => null));
    final capacity = _optional(getCapacity.execute());
    final frost = _optional(getAlerts.execute().then(
          (alerts) => alerts.where((alert) => alert.active && alert.type == SectorAlertType.frost).length,
        ));
    final intake = _optional(getIntake.execute().then((campaigns) => campaigns.isEmpty ? null : campaigns.first));
    try {
      final plots = await getPlots.execute(origin: location.lastKnown?.coordinate);
      _emit(state.copyWith(loading: false, territory: RiskTerritory(plots)));
    } on CooperativeFailure catch (failure) {
      _emit(state.copyWith(loading: false, failure: state.territory == null ? () => failure : null));
    }
    final values = (await capacity, await frost, await intake);
    _emit(state.copyWith(capacity: () => values.$1, frostAlerts: () => values.$2, intake: () => values.$3));
  }

  /// A card is a hint: its failure leaves it out instead of hiding the Home.
  Future<T?> _optional<T>(Future<T?> read) async {
    try {
      return await read;
    } on CooperativeFailure {
      return null;
    }
  }

  void _emit(ManagerHomeUiState next) {
    if (!isClosed) emit(next);
  }
}
