import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// G30 · Acopio: the campaigns of the license and the one on screen, with its sectors.
class IntakeUiState {
  const IntakeUiState({
    this.loading = true,
    this.failure,
    this.campaigns = const [],
    this.selectedYear,
    this.forecast,
    this.hasActiveAlerts = false,
  });

  final bool loading;
  final CooperativeFailure? failure;

  /// Every campaign, the newest first, for «Elige la campaña».
  final List<IntakeForecast> campaigns;
  final int? selectedYear;

  /// The chosen campaign read alone, with its sectors. Null until it is read.
  final IntakeForecast? forecast;
  final bool hasActiveAlerts;

  IntakeUiState copyWith({
    bool? loading,
    CooperativeFailure? Function()? failure,
    List<IntakeForecast>? campaigns,
    int? selectedYear,
    IntakeForecast? Function()? forecast,
    bool? hasActiveAlerts,
  }) =>
      IntakeUiState(
        loading: loading ?? this.loading,
        failure: failure == null ? this.failure : failure(),
        campaigns: campaigns ?? this.campaigns,
        selectedYear: selectedYear ?? this.selectedYear,
        forecast: forecast == null ? this.forecast : forecast(),
        hasActiveAlerts: hasActiveAlerts ?? this.hasActiveAlerts,
      );
}
