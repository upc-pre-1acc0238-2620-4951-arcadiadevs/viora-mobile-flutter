import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';

/// What a sector alert is about.
enum SectorAlertType {
  /// The sector has plots in red for overload or a critical incident: «La Yarada Baja pasó a Crítico».
  sectorCritical,

  /// Frost is forecast or open in the sector: «Helada radiativa en La Yarada Alta».
  frost;

  static SectorAlertType parse(String? value) => value == 'FROST' ? frost : sectorCritical;
}

/// How urgent an alert is, as the alert center groups them.
enum AlertSeverity {
  /// «Críticas».
  critical,

  /// «Atención».
  attention;

  static AlertSeverity parse(String? value) => value == 'ATTENTION' ? attention : critical;
}

/// An alert about one sector of the manager's license. It names its leading plot while its
/// owner shares, and normalizes once the cause is gone, telling how the sector was left.
class SectorAlert {
  const SectorAlert({
    required this.id,
    required this.sectorId,
    required this.sectorName,
    required this.type,
    required this.severity,
    required this.active,
    required this.openedAt,
    required this.updatedAt,
    required this.normalizedAt,
    required this.sectorLevelAfter,
    required this.affectedPlots,
    required this.sectorPlots,
    required this.leadPlotId,
    required this.leadPlotName,
    required this.leadProducerName,
    required this.leadReason,
    required this.leadValue,
    required this.leadDate,
  });

  final String id;
  final String sectorId;
  final String sectorName;
  final SectorAlertType type;
  final AlertSeverity severity;

  /// False once it normalized; the server lists those for 7 days.
  final bool active;
  final DateTime? openedAt;
  final DateTime? updatedAt;
  final DateTime? normalizedAt;

  /// The sector's color when it normalized («volvió a Moderado»); null while active.
  final PlotRisk? sectorLevelAfter;
  final int affectedPlots;
  final int sectorPlots;

  /// Null when its owner no longer shares.
  final String? leadPlotId;
  final String? leadPlotName;
  final String? leadProducerName;
  final RiskReason? leadReason;

  /// The overload percentage or the forecast minimum; null for an incident.
  final double? leadValue;

  /// The day of the forecast minimum.
  final DateTime? leadDate;

  /// When it last changed: what the alert center shows and sorts by.
  DateTime? get changedAt => active ? (updatedAt ?? openedAt) : (normalizedAt ?? updatedAt);
}
