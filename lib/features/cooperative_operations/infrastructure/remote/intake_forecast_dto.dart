import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';

double _tons(Object? value) => (value as num?)?.toDouble() ?? 0;

/// A campaign as GET intake-forecasts answers it.
class IntakeForecastDto {
  const IntakeForecastDto(this.json);

  factory IntakeForecastDto.fromJson(Map<String, dynamic> json) => IntakeForecastDto(json);

  final Map<String, dynamic> json;

  IntakeForecast toDomain() {
    final evaluatedAt = json['evaluatedAt'] as String?;
    final sectors = (json['sectors'] as List<dynamic>?) ?? const [];
    return IntakeForecast(
      campaignYear: (json['campaignYear'] as num).toInt(),
      kind: IntakeKind.parse(json['kind'] as String?),
      status: IntakeStatus.parse(json['status'] as String?),
      totalTons: (json['totalTons'] as num?)?.toDouble(),
      greenTons: _tons(json['greenTons']),
      blackTons: _tons(json['blackTons']),
      unclassifiedTons: _tons(json['unclassifiedTons']),
      plots: (json['plots'] as num?)?.toInt() ?? 0,
      sampledPlots: (json['sampledPlots'] as num?)?.toInt() ?? 0,
      estimablePlots: (json['estimablePlots'] as num?)?.toInt() ?? 0,
      coveragePercent: _tons(json['coveragePercent']),
      preliminaryThresholdPercent: (json['preliminaryThresholdPercent'] as num?)?.toDouble() ?? 50,
      sectors: [
        for (final sector in sectors.cast<Map<String, dynamic>>())
          SectorIntake(
            sectorId: sector['sectorZoneId'] as String?,
            sectorName: sector['sectorZoneName'] as String?,
            placement: SectorPlacement.parse(sector['sectorStatus'] as String?),
            plots: (sector['plots'] as num?)?.toInt() ?? 0,
            sampledPlots: (sector['sampledPlots'] as num?)?.toInt() ?? 0,
            tons: (sector['tons'] as num?)?.toDouble(),
            greenTons: (sector['greenTons'] as num?)?.toDouble(),
            blackTons: (sector['blackTons'] as num?)?.toDouble(),
            unclassifiedTons: (sector['unclassifiedTons'] as num?)?.toDouble(),
          ),
      ],
      evaluatedAt: evaluatedAt == null ? null : DateTime.tryParse(evaluatedAt),
    );
  }
}
