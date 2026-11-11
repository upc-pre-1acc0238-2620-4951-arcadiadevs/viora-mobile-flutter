/// Whether a campaign is still being projected or its harvests are already settled.
enum IntakeKind {
  projection,
  settled;

  static IntakeKind parse(String? value) => value == 'SETTLED' ? settled : projection;
}

/// How much the figure of a campaign can be trusted.
enum IntakeStatus {
  /// No plot was sampled: there is no figure.
  noData,

  /// Fewer plots sampled than the threshold: the figure is preliminary.
  preliminary,

  /// Enough plots sampled.
  sufficient,

  /// A past campaign with some harvests not settled.
  partial;

  static IntakeStatus parse(String? value) => switch (value) {
        'PRELIMINARY' => preliminary,
        'SUFFICIENT' => sufficient,
        'PARTIAL' => partial,
        _ => noData,
      };
}

/// The intake of one sector in a campaign.
class SectorIntake {
  const SectorIntake({
    required this.sectorId,
    required this.sectorName,
    required this.plots,
    required this.sampledPlots,
    required this.tons,
  });

  /// Null for the plots without a sector.
  final String? sectorId;
  final String? sectorName;
  final int plots;
  final int sampledPlots;

  /// Null without any sampling in the sector.
  final double? tons;
}

/// The intake of a campaign: the tons the members of the license should deliver, green and
/// black, projected from the estimable plots or added up from the settled harvests.
class IntakeForecast {
  const IntakeForecast({
    required this.campaignYear,
    required this.kind,
    required this.status,
    required this.totalTons,
    required this.greenTons,
    required this.blackTons,
    required this.unclassifiedTons,
    required this.plots,
    required this.sampledPlots,
    required this.estimablePlots,
    required this.coveragePercent,
    required this.preliminaryThresholdPercent,
    required this.sectors,
    required this.evaluatedAt,
  });

  final int campaignYear;
  final IntakeKind kind;
  final IntakeStatus status;

  /// Null when there is no figure ([IntakeStatus.noData]).
  final double? totalTons;
  final double greenTons;
  final double blackTons;

  /// Tons of plots without a settled history that tells green from black.
  final double unclassifiedTons;
  final int plots;
  final int sampledPlots;
  final int estimablePlots;

  /// The share of plots sampled, from 0 to 100.
  final double coveragePercent;
  final double preliminaryThresholdPercent;

  /// Empty in the list of campaigns; only one campaign read alone has them.
  final List<SectorIntake> sectors;
  final DateTime? evaluatedAt;
}
