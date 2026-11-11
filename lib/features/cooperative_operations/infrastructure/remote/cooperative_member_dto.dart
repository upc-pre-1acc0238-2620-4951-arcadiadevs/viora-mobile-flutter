import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';

DateTime? _date(Object? value) => value is String && value.isNotEmpty ? DateTime.parse(value) : null;

double? _number(Object? value) => (value as num?)?.toDouble();

RiskReason? _firstReason(Object? reasons) {
  if (reasons is! List || reasons.isEmpty) return null;
  final first = reasons.first;
  return first is Map<String, dynamic> ? RiskReason.parse(first['type'] as String?) : null;
}

/// A member as GET cooperative-members lists them.
class CooperativeMemberDto {
  const CooperativeMemberDto(this.json);

  factory CooperativeMemberDto.fromJson(Map<String, dynamic> json) => CooperativeMemberDto(json);

  final Map<String, dynamic> json;

  CooperativeMember toDomain() => CooperativeMember(
        id: json['id'] as String,
        fullName: json['fullName'] as String? ?? '',
        sharing: MemberSharing.parse(json['sharing'] as String?),
        withdrawnAt: _date(json['withdrawnAt']),
        plotCount: (json['plotCount'] as num?)?.toInt() ?? 0,
        registeredAreaHa: _number(json['registeredAreaHa']) ?? 0,
        sectorNames: (json['sectorNames'] as List?)?.whereType<String>().toList() ?? const [],
        worstRisk: PlotRisk.parse(json['worstRiskLevel'] as String?),
        unsampledPlots: (json['unsampledPlots'] as num?)?.toInt() ?? 0,
      );
}

/// A member as GET cooperative-members/{id} answers it.
class MemberDetailDto {
  const MemberDetailDto(this.json);

  factory MemberDetailDto.fromJson(Map<String, dynamic> json) => MemberDetailDto(json);

  final Map<String, dynamic> json;

  MemberDetail toDomain() => MemberDetail(
        id: json['id'] as String,
        fullName: json['fullName'] as String? ?? '',
        sharing: MemberSharing.parse(json['sharing'] as String?),
        withdrawnAt: _date(json['withdrawnAt']),
        memberSince: _date(json['memberSince']),
        quotaHa: _number(json['quotaHa']),
        maskedCode: json['maskedCode'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        registeredAreaHa: _number(json['registeredAreaHa']),
        plots: [
          for (final plot in (json['plots'] as List? ?? const []).whereType<Map<String, dynamic>>())
            MemberPlot(
              id: plot['plotId'] as String,
              name: plot['plotName'] as String? ?? '',
              variety: plot['variety'] as String?,
              areaHa: _number(plot['areaHa']) ?? 0,
              // A sector the manager hasn't confirmed yet doesn't count as the plot's sector.
              sectorName: plot['sectorStatus'] == 'PENDING' ? null : plot['sectorZoneName'] as String?,
              risk: PlotRisk.parse(plot['riskLevel'] as String?),
              reason: _firstReason(plot['reasons']),
            ),
        ],
      );
}
