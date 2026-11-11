import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// How many suggested visits the Home lists; «Ver todas» opens the rest.
const int homeVisitsShown = 3;

/// G10 · Inicio: the summary of the license the manager is in charge of.
class ManagerHomeUiState {
  const ManagerHomeUiState({
    this.loading = true,
    this.failure,
    this.territory,
    this.capacity,
    this.frostAlerts,
    this.intake,
  });

  final bool loading;

  /// Only when the valley could not be read; the rest of the cards are optional.
  final CooperativeFailure? failure;
  final RiskTerritory? territory;
  final LicenseCapacity? capacity;

  /// Active frost alerts of the license's sectors; null when they could not be read.
  final int? frostAlerts;

  /// The newest campaign; null when there is none or it could not be read.
  final IntakeForecast? intake;

  ManagerHomeUiState copyWith({
    bool? loading,
    CooperativeFailure? Function()? failure,
    RiskTerritory? territory,
    LicenseCapacity? Function()? capacity,
    int? Function()? frostAlerts,
    IntakeForecast? Function()? intake,
  }) =>
      ManagerHomeUiState(
        loading: loading ?? this.loading,
        failure: failure != null ? failure() : this.failure,
        territory: territory ?? this.territory,
        capacity: capacity != null ? capacity() : this.capacity,
        frostAlerts: frostAlerts != null ? frostAlerts() : this.frostAlerts,
        intake: intake != null ? intake() : this.intake,
      );
}
