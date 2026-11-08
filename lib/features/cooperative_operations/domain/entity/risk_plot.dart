import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';

/// Where a plot stands in the license's list of sectors.
enum SectorPlacement {
  assigned,

  /// The member wrote a sector that the manager hasn't confirmed ("Por confirmar").
  pending,

  /// The member never gave one.
  none;

  static SectorPlacement parse(String? value) => switch (value) {
        'ASSIGNED' => assigned,
        'PENDING' => pending,
        _ => none,
      };
}

/// A longitude and latitude on the map.
class GeoCoordinate {
  const GeoCoordinate(this.longitude, this.latitude);

  final double longitude;
  final double latitude;
}

/// One reason of a plot's color. [value] is the overload percentage or the forecast minimum;
/// [date] is the day of that minimum.
class PlotRiskReason {
  const PlotRiskReason({required this.type, this.incidentType, this.value, this.date});

  final RiskReason type;
  final String? incidentType;
  final double? value;
  final DateTime? date;

  bool get isFrost => type == RiskReason.frostForecast || incidentType == 'FROST_WARNING';
}

/// A plot of a member who shares, on the map and the lists of the manager.
class RiskPlot {
  const RiskPlot({
    required this.id,
    required this.name,
    required this.producerName,
    required this.areaHa,
    required this.center,
    required this.outline,
    required this.sectorId,
    required this.sectorName,
    required this.placement,
    required this.proposedSectorName,
    required this.risk,
    required this.reasons,
    required this.overloadPercent,
    required this.distanceKm,
    required this.evaluatedAt,
  });

  final String id;
  final String name;
  final String producerName;
  final double? areaHa;
  final GeoCoordinate? center;

  /// The exterior ring of its polygon, empty when it can't be read; the plot then stays out of
  /// the map but not out of the lists.
  final List<GeoCoordinate> outline;
  final String? sectorId;
  final String? sectorName;
  final SectorPlacement placement;
  final String? proposedSectorName;
  final PlotRisk risk;
  final List<PlotRiskReason> reasons;
  final double? overloadPercent;

  /// Null without the manager's location.
  final double? distanceKm;
  final DateTime? evaluatedAt;

  /// The first reason, the most serious one.
  PlotRiskReason? get mainReason => reasons.isEmpty ? null : reasons.first;

  PlotRiskReason? get frost {
    for (final reason in reasons) {
      if (reason.isFrost) return reason;
    }
    return null;
  }

  bool get isOverloaded => reasons.any((reason) => reason.type == RiskReason.overload);

  /// Whether the point falls inside its polygon.
  bool contains(double longitude, double latitude) {
    var inside = false;
    for (var i = 0, j = outline.length - 1; i < outline.length; j = i++) {
      final a = outline[i];
      final b = outline[j];
      final crosses = (a.latitude > latitude) != (b.latitude > latitude) &&
          longitude < (b.longitude - a.longitude) * (latitude - a.latitude) / (b.latitude - a.latitude) + a.longitude;
      if (crosses) inside = !inside;
    }
    return inside;
  }
}

/// One plot in full, as the manager prepares a visit (G23). Read-only.
class RiskPlotDetail {
  const RiskPlotDetail({
    required this.id,
    required this.name,
    required this.producerName,
    required this.producerPhone,
    required this.areaHa,
    required this.sectorName,
    required this.risk,
    required this.reasons,
    required this.overloadPercent,
    required this.sampledTrees,
    required this.lastSampledOn,
    required this.fruitsPerShoot,
    required this.targetFruitsPerShoot,
    required this.percentageToRemove,
    required this.windowOpensOn,
    required this.windowClosesOn,
    required this.thinnedOn,
    required this.kgPerHaAfterThinning,
    required this.bearingIndex,
    required this.evaluatedAt,
  });

  final String id;
  final String name;
  final String producerName;
  final String? producerPhone;
  final double? areaHa;
  final String? sectorName;
  final PlotRisk risk;
  final List<PlotRiskReason> reasons;
  final double? overloadPercent;
  final int sampledTrees;
  final DateTime? lastSampledOn;
  final double? fruitsPerShoot;
  final double? targetFruitsPerShoot;
  final double? percentageToRemove;
  final DateTime? windowOpensOn;
  final DateTime? windowClosesOn;
  final DateTime? thinnedOn;
  final double? kgPerHaAfterThinning;
  final double? bearingIndex;
  final DateTime? evaluatedAt;

  /// Without a valid sampling nothing can be said about its load, whatever its color.
  bool get hasLoad => fruitsPerShoot != null && targetFruitsPerShoot != null;

  PlotRiskReason? get frost {
    for (final reason in reasons) {
      if (reason.isFrost) return reason;
    }
    return null;
  }
}
