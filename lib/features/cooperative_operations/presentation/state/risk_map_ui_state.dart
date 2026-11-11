import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';

/// G20 · Riesgo territorial with its map and list, and G21 when there is no GPS.
class RiskMapUiState {
  const RiskMapUiState({
    this.loading = true,
    this.failure,
    this.plots = const [],
    this.location,
    this.gpsOff = false,
    this.explainLocation = false,
    this.showList = false,
    this.selectedSectorId,
    this.selectedPlotId,
    this.selectedDetail,
    this.hasActiveAlerts = false,
    this.readAt,
    this.savedAt,
  });

  final bool loading;
  final CooperativeFailure? failure;
  final List<RiskPlot> plots;
  final ManagerLocation? location;

  /// The manager said no to the GPS, or the phone couldn't find them (G21).
  final bool gpsOff;

  /// The first opening: G20 · Permiso de ubicación explains what the GPS is for.
  final bool explainLocation;
  final bool showList;
  final String? selectedSectorId;
  final String? selectedPlotId;

  /// What the panel adds about the chosen plot, once read.
  final RiskPlotDetail? selectedDetail;
  final bool hasActiveAlerts;

  /// When the plots on screen were read from the server.
  final DateTime? readAt;

  /// Without a connection: when the plots on screen were saved (G20 · Sin conexión). Null while
  /// they are fresh.
  final DateTime? savedAt;

  RiskTerritory get territory => RiskTerritory(plots);

  RiskPlot? get selectedPlot {
    for (final plot in plots) {
      if (plot.id == selectedPlotId) return plot;
    }
    return null;
  }

  RiskSector? get selectedSector {
    final id = selectedSectorId;
    return id == null ? null : territory.sector(id);
  }

  RiskMapUiState copyWith({
    bool? loading,
    CooperativeFailure? Function()? failure,
    List<RiskPlot>? plots,
    ManagerLocation? Function()? location,
    bool? gpsOff,
    bool? explainLocation,
    bool? showList,
    String? Function()? selectedSectorId,
    String? Function()? selectedPlotId,
    RiskPlotDetail? Function()? selectedDetail,
    bool? hasActiveAlerts,
    DateTime? readAt,
    DateTime? Function()? savedAt,
  }) =>
      RiskMapUiState(
        loading: loading ?? this.loading,
        failure: failure == null ? this.failure : failure(),
        plots: plots ?? this.plots,
        location: location == null ? this.location : location(),
        gpsOff: gpsOff ?? this.gpsOff,
        explainLocation: explainLocation ?? this.explainLocation,
        showList: showList ?? this.showList,
        selectedSectorId: selectedSectorId == null ? this.selectedSectorId : selectedSectorId(),
        selectedPlotId: selectedPlotId == null ? this.selectedPlotId : selectedPlotId(),
        selectedDetail: selectedDetail == null ? this.selectedDetail : selectedDetail(),
        hasActiveAlerts: hasActiveAlerts ?? this.hasActiveAlerts,
        readAt: readAt ?? this.readAt,
        savedAt: savedAt == null ? this.savedAt : savedAt(),
      );
}
