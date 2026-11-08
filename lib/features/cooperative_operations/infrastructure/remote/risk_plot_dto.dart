import 'dart:convert';

import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';

DateTime? _date(Object? value) => value is String && value.isNotEmpty ? DateTime.tryParse(value) : null;

double? _number(Object? value) => (value as num?)?.toDouble();

List<PlotRiskReason> _reasons(Object? reasons) => [
      for (final reason in (reasons as List? ?? const []).whereType<Map<String, dynamic>>())
        PlotRiskReason(
          type: RiskReason.parse(reason['type'] as String?),
          incidentType: reason['incidentType'] as String?,
          value: _number(reason['value']),
          date: _date(reason['date']),
        ),
    ];

/// The exterior ring of a GeoJSON Polygon, without its closing corner. Anything else reads as
/// empty: a plot that can't be drawn must not take the map down.
List<GeoCoordinate> parseOutline(String? geoJson) {
  if (geoJson == null || geoJson.isEmpty) return const [];
  try {
    final json = jsonDecode(geoJson);
    if (json is! Map<String, dynamic> || json['type'] != 'Polygon') return const [];
    final ring = (json['coordinates'] as List).first as List;
    final corners = [
      for (final corner in ring.cast<List<dynamic>>())
        GeoCoordinate((corner[0] as num).toDouble(), (corner[1] as num).toDouble()),
    ];
    if (corners.length > 1 &&
        corners.first.longitude == corners.last.longitude &&
        corners.first.latitude == corners.last.latitude) {
      corners.removeLast();
    }
    return corners.length < 3 ? const [] : corners;
  } on FormatException {
    return const [];
  } on TypeError {
    return const [];
  } on RangeError {
    return const [];
  } on StateError {
    return const [];
  }
}

/// A plot as GET member-plots lists it.
class RiskPlotDto {
  const RiskPlotDto(this.json);

  factory RiskPlotDto.fromJson(Map<String, dynamic> json) => RiskPlotDto(json);

  final Map<String, dynamic> json;

  RiskPlot toDomain() {
    final latitude = _number(json['latitude']);
    final longitude = _number(json['longitude']);
    return RiskPlot(
      id: json['plotId'] as String,
      name: json['plotName'] as String? ?? '',
      producerName: json['producerName'] as String? ?? '',
      areaHa: _number(json['areaHa']),
      center: latitude == null || longitude == null ? null : GeoCoordinate(longitude, latitude),
      outline: parseOutline(json['geoJson'] as String?),
      sectorId: json['sectorZoneId'] as String?,
      sectorName: json['sectorZoneName'] as String?,
      placement: SectorPlacement.parse(json['sectorStatus'] as String?),
      proposedSectorName: json['proposedSectorName'] as String?,
      risk: PlotRisk.parse(json['riskLevel'] as String?),
      reasons: _reasons(json['reasons']),
      overloadPercent: _number(json['overloadPercent']),
      distanceKm: _number(json['distanceKm']),
      evaluatedAt: _date(json['evaluatedAt']),
    );
  }
}

/// A plot as GET member-plots/{id} answers it.
class RiskPlotDetailDto {
  const RiskPlotDetailDto(this.json);

  factory RiskPlotDetailDto.fromJson(Map<String, dynamic> json) => RiskPlotDetailDto(json);

  final Map<String, dynamic> json;

  RiskPlotDetail toDomain() => RiskPlotDetail(
        id: json['plotId'] as String,
        name: json['plotName'] as String? ?? '',
        producerName: json['producerName'] as String? ?? '',
        producerPhone: json['producerPhone'] as String?,
        areaHa: _number(json['areaHa']),
        // A sector the manager hasn't confirmed yet doesn't count as the plot's sector.
        sectorName: json['sectorStatus'] == 'PENDING' ? null : json['sectorZoneName'] as String?,
        risk: PlotRisk.parse(json['riskLevel'] as String?),
        reasons: _reasons(json['reasons']),
        overloadPercent: _number(json['overloadPercent']),
        sampledTrees: (json['sampledTrees'] as num?)?.toInt() ?? 0,
        lastSampledOn: _date(json['lastSampledOn']),
        fruitsPerShoot: _number(json['preThinningFruitsPerShoot']),
        targetFruitsPerShoot: _number(json['targetFruitsPerShoot']),
        percentageToRemove: _number(json['percentageToRemove']),
        windowOpensOn: _date(json['windowOpensOn']),
        windowClosesOn: _date(json['windowClosesOn']),
        thinnedOn: _date(json['thinningExecutedOn']),
        kgPerHaAfterThinning: _number(json['estimatedKgPerHaAfterThinning']),
        bearingIndex: _number(json['bearingIndex']),
        evaluatedAt: _date(json['evaluatedAt']),
      );
}
