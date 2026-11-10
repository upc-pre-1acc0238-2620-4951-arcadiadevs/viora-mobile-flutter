import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';

DateTime? _date(Object? value) => value is String && value.isNotEmpty ? DateTime.tryParse(value) : null;

/// An alert as GET sector-alerts lists it.
class SectorAlertDto {
  const SectorAlertDto(this.json);

  factory SectorAlertDto.fromJson(Map<String, dynamic> json) => SectorAlertDto(json);

  final Map<String, dynamic> json;

  SectorAlert toDomain() {
    final levelAfter = json['sectorLevelAfter'] as String?;
    final leadReason = json['leadReason'] as String?;
    return SectorAlert(
      id: json['id'] as String? ?? '',
      sectorId: json['sectorZoneId'] as String? ?? '',
      sectorName: json['sectorZoneName'] as String? ?? '',
      type: SectorAlertType.parse(json['type'] as String?),
      severity: AlertSeverity.parse(json['severity'] as String?),
      active: json['status'] != 'NORMALIZED',
      openedAt: _date(json['openedAt']),
      updatedAt: _date(json['updatedAt']),
      normalizedAt: _date(json['normalizedAt']),
      sectorLevelAfter: levelAfter == null ? null : PlotRisk.parse(levelAfter),
      affectedPlots: (json['affectedPlots'] as num?)?.toInt() ?? 0,
      sectorPlots: (json['sectorPlots'] as num?)?.toInt() ?? 0,
      leadPlotId: json['leadPlotId'] as String?,
      leadPlotName: json['leadPlotName'] as String?,
      leadProducerName: json['leadProducerName'] as String?,
      leadReason: leadReason == null ? null : RiskReason.parse(leadReason),
      leadValue: (json['leadValue'] as num?)?.toDouble(),
      leadDate: _date(json['leadDate']),
    );
  }
}
