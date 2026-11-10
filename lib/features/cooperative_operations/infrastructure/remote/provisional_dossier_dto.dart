import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';

DateTime? _date(Object? value) => value is String && value.isNotEmpty ? DateTime.tryParse(value) : null;

double? _number(Object? value) => (value as num?)?.toDouble();

int _count(Object? value) => (value as num?)?.toInt() ?? 0;

/// A dossier as GET member-plots/{id}/provisional-dossier answers it.
class ProvisionalDossierDto {
  const ProvisionalDossierDto(this.json);

  factory ProvisionalDossierDto.fromJson(Map<String, dynamic> json) => ProvisionalDossierDto(json);

  final Map<String, dynamic> json;

  ProvisionalDossier toDomain() => ProvisionalDossier(
        plotId: json['plotId'] as String? ?? '',
        plotName: json['plotName'] as String? ?? '',
        producerName: json['producerName'] as String? ?? '',
        organizationName: json['organizationName'] as String? ?? '',
        variety: json['variety'] as String?,
        areaHa: _number(json['areaHa']),
        campaignYear: _count(json['campaignYear']),
        cutOffAt: _date(json['cutOffAt']),
        fruitsPerShoot: _number(json['preThinningFruitsPerShoot']),
        targetFruitsPerShoot: _number(json['targetFruitsPerShoot']),
        overTargetPercent: _number(json['overTargetPercentage']),
        removalPercent: _number(json['prescribedRemovalPercentage']),
        windowOpensOn: _date(json['windowOpensOn']),
        windowClosesOn: _date(json['windowClosesOn']),
        sampledTrees: _count(json['sampledTrees']),
        lastSampledOn: _date(json['lastSampledOn']),
        thinnedOn: _date(json['thinnedOn']),
        linkedNodes: _count(json['linkedNodes']),
        daysWithReadings: _count(json['daysWithReadings']),
      );
}
