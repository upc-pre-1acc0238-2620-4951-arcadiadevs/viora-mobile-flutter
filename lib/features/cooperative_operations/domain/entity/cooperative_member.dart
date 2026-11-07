/// Whether a member shares their data with the manager.
enum MemberSharing {
  sharing,

  /// The member stopped sharing; their plan and seat go on.
  withdrawn,

  /// The member redeemed a code without accepting to share.
  notSharing;

  static MemberSharing parse(String? value) => switch (value) {
        'SHARING' => sharing,
        'WITHDRAWN' => withdrawn,
        _ => notSharing,
      };
}

/// How a plot stands, as the server reads its sampling, thinning and incidents.
enum PlotRisk {
  critical,
  moderate,
  optimal,
  noData;

  static PlotRisk parse(String? value) => switch (value) {
        'CRITICAL' => critical,
        'MODERATE' => moderate,
        'OPTIMAL' => optimal,
        _ => noData,
      };
}

/// Why a plot is at risk. The screens only name the first one.
enum RiskReason {
  overload,
  criticalIncident,
  frostForecast,
  warningIncident,
  other;

  static RiskReason parse(String? value) => switch (value) {
        'OVERLOAD' => overload,
        'CRITICAL_INCIDENT' => criticalIncident,
        'FROST_FORECAST' => frostForecast,
        'WARNING_INCIDENT' => warningIncident,
        _ => other,
      };
}

/// A producer who redeemed one of the license's codes, as the roster lists them (G40).
class CooperativeMember {
  const CooperativeMember({
    required this.id,
    required this.fullName,
    required this.sharing,
    required this.withdrawnAt,
    required this.plotCount,
    required this.registeredAreaHa,
    required this.sectorNames,
    required this.worstRisk,
  });

  final String id;
  final String fullName;
  final MemberSharing sharing;
  final DateTime? withdrawnAt;
  final int plotCount;
  final double registeredAreaHa;
  final List<String> sectorNames;
  final PlotRisk worstRisk;
}

/// One plot of a member, as the member detail shows it (G41).
class MemberPlot {
  const MemberPlot({
    required this.id,
    required this.name,
    required this.variety,
    required this.areaHa,
    required this.sectorName,
    required this.risk,
    required this.reason,
  });

  final String id;
  final String name;
  final String? variety;
  final double areaHa;

  /// Null while the member's sector waits for the manager ("Por confirmar") or was never given.
  final String? sectorName;
  final PlotRisk risk;
  final RiskReason? reason;
}

/// A member in full (G41). While they don't share, the server leaves out their contact and
/// plots, so [phone], [email] and [plots] are empty.
class MemberDetail {
  const MemberDetail({
    required this.id,
    required this.fullName,
    required this.sharing,
    required this.withdrawnAt,
    required this.memberSince,
    required this.quotaHa,
    required this.maskedCode,
    required this.phone,
    required this.email,
    required this.registeredAreaHa,
    required this.plots,
  });

  final String id;
  final String fullName;
  final MemberSharing sharing;
  final DateTime? withdrawnAt;
  final DateTime? memberSince;
  final double? quotaHa;
  final String? maskedCode;
  final String? phone;
  final String? email;
  final double? registeredAreaHa;
  final List<MemberPlot> plots;
}
