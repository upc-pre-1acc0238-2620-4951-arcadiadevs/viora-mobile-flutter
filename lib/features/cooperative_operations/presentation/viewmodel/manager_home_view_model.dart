import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_intake_forecasts_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plots_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
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
    this.getKeptPlots,
    this.getKeptCapacity,
    this.getKeptAlerts,
    this.getKeptIntake,
  }) : super(const ManagerHomeUiState());

  final GetRiskPlotsUseCase getPlots;
  final GetLicenseCapacityUseCase getCapacity;
  final GetSectorAlertsUseCase getAlerts;
  final GetIntakeForecastsUseCase getIntake;

  /// The GPS is only asked on the map; the Home uses the last place the map found, if any.
  final LocationRepository location;

  /// The last reads, shown with their date when there is no connection.
  final GetKeptRiskPlotsUseCase? getKeptPlots;
  final GetKeptLicenseCapacityUseCase? getKeptCapacity;
  final GetKeptSectorAlertsUseCase? getKeptAlerts;
  final GetKeptIntakeForecastsUseCase? getKeptIntake;

  /// When the valley on screen was last read from the server.
  DateTime? _readAt;

  /// Reads everything again. What is on screen stays if the valley can't be read.
  Future<void> load() async {
    _emit(state.copyWith(loading: true, failure: () => null));
    final capacity = _optional(getCapacity.execute(), () async => (await getKeptCapacity?.execute())?.value);
    final frost = _optional(
      getAlerts.execute().then(_frost),
      () async {
        final kept = await getKeptAlerts?.execute();
        return kept == null ? null : _frost(kept.value);
      },
    );
    final intake = _optional(
      getIntake.execute().then(_newest),
      () async {
        final kept = await getKeptIntake?.execute();
        return kept == null ? null : _newest(kept.value);
      },
    );
    try {
      final plots = await getPlots.execute(origin: location.lastKnown?.coordinate);
      _readAt = DateTime.now();
      _emit(state.copyWith(loading: false, territory: RiskTerritory(plots), savedAt: () => null));
    } on CooperativeOffline catch (failure) {
      // Without a connection the Home shows the valley as last read, with its date, never as fresh.
      final kept = state.territory == null ? await getKeptPlots?.execute() : null;
      if (kept != null) {
        _emit(state.copyWith(loading: false, territory: RiskTerritory(kept.value), savedAt: () => kept.savedAt));
      } else {
        _emit(state.copyWith(
          loading: false,
          failure: state.territory == null ? () => failure : null,
          savedAt: state.territory == null ? null : () => state.savedAt ?? _readAt,
        ));
      }
    } on CooperativeFailure catch (failure) {
      _emit(state.copyWith(loading: false, failure: state.territory == null ? () => failure : null));
    }
    final values = (await capacity, await frost, await intake);
    _emit(state.copyWith(capacity: () => values.$1, frostAlerts: () => values.$2, intake: () => values.$3));
  }

  static int _frost(List<SectorAlert> alerts) =>
      alerts.where((alert) => alert.active && alert.type == SectorAlertType.frost).length;

  static IntakeForecast? _newest(List<IntakeForecast> campaigns) => campaigns.isEmpty ? null : campaigns.first;

  /// A card is a hint: its failure leaves it out instead of hiding the Home. Without a connection
  /// it shows what [kept] last read, if anything.
  Future<T?> _optional<T>(Future<T?> read, Future<T?> Function() kept) async {
    try {
      return await read;
    } on CooperativeOffline {
      return kept();
    } on CooperativeFailure {
      return null;
    }
  }

  void _emit(ManagerHomeUiState next) {
    if (!isClosed) emit(next);
  }
}
