import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';

/// How far a plot can be to count as near the manager ("A menos de 5 km").
const double nearbyRadiusKm = 5;

/// How close two critical plots must be to fit in one outing (G22).
const double sameOutingRadiusKm = 1.5;

/// Any set of plots read together: the whole valley, a sector, what is near the manager.
class RiskGroup {
  const RiskGroup(this.plots);

  final List<RiskPlot> plots;

  int get total => plots.length;
  int get critical => count(PlotRisk.critical);
  int get moderate => count(PlotRisk.moderate);
  int get optimal => count(PlotRisk.optimal);
  int get noData => count(PlotRisk.noData);

  int count(PlotRisk risk) => plots.where((plot) => plot.risk == risk).length;

  int get overloaded => plots.where((plot) => plot.isOverloaded).length;
  int get withFrost => plots.where((plot) => plot.frost != null).length;

  /// The color of its most urgent plot, the same rule as the server's sector alerts.
  /// Grey goes before green: not knowing is never good news.
  PlotRisk get level {
    if (critical > 0) return PlotRisk.critical;
    if (moderate > 0) return PlotRisk.moderate;
    if (noData > 0 || plots.isEmpty) return PlotRisk.noData;
    return PlotRisk.optimal;
  }

  /// The coldest frost forecast among its plots.
  PlotRiskReason? get coldestFrost {
    PlotRiskReason? coldest;
    for (final plot in plots) {
      final frost = plot.frost;
      if (frost == null) continue;
      if (coldest == null || (frost.value ?? double.infinity) < (coldest.value ?? double.infinity)) coldest = frost;
    }
    return coldest;
  }

  /// When these plots were read, the oldest if they differ.
  DateTime? get evaluatedAt {
    DateTime? oldest;
    for (final plot in plots) {
      final at = plot.evaluatedAt;
      if (at != null && (oldest == null || at.isBefore(oldest))) oldest = at;
    }
    return oldest;
  }

  /// The critical plots within one outing of the manager, the closest first, one per member.
  List<RiskPlot> get criticalWithinOneOuting {
    final close = plots
        .where((plot) =>
            plot.risk == PlotRisk.critical && plot.distanceKm != null && plot.distanceKm! <= sameOutingRadiusKm)
        .toList()
      ..sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));
    final seen = <String>{};
    return close.where((plot) => seen.add(plot.producerName)).toList();
  }
}

/// A sector of the license, as far as its plots tell.
class RiskSector {
  const RiskSector({required this.id, required this.name, required this.group});

  final String id;
  final String name;
  final RiskGroup group;

  /// Where its label goes: the middle of its plots. It marks a place, never a boundary.
  GeoCoordinate? get labelPosition {
    final centers = group.plots.map((plot) => plot.center).whereType<GeoCoordinate>().toList();
    if (centers.isEmpty) return null;
    final longitude = centers.map((c) => c.longitude).reduce((a, b) => a + b) / centers.length;
    final latitude = centers.map((c) => c.latitude).reduce((a, b) => a + b) / centers.length;
    return GeoCoordinate(longitude, latitude);
  }
}

/// Which plots a sector screen (G22) reads.
abstract final class RiskScopes {
  static const nearby = 'nearby';
  static const pending = 'pending';
  static const unassigned = 'unassigned';
}

/// What the manager reads of their valley: the plots in the server's visit order.
class RiskTerritory {
  const RiskTerritory(this.plots);

  final List<RiskPlot> plots;

  RiskGroup get valley => RiskGroup(plots);

  RiskGroup get nearby => RiskGroup(
        plots.where((plot) => plot.distanceKm != null && plot.distanceKm! <= nearbyRadiusKm).toList(),
      );

  RiskGroup get pending => RiskGroup(plots.where((plot) => plot.placement == SectorPlacement.pending).toList());

  /// The plots of members who never gave a sector.
  RiskGroup get unassigned => RiskGroup(
        plots.where((plot) => plot.placement == SectorPlacement.none && plot.sectorId == null).toList(),
      );

  /// Sectors with plots, the most urgent first, as the list of G20 shows them.
  List<RiskSector> get sectorsByUrgency {
    final sectors = _sectors();
    sectors.sort((a, b) {
      final byLevel = _urgency(a.group.level).compareTo(_urgency(b.group.level));
      if (byLevel != 0) return byLevel;
      final byCritical = b.group.critical.compareTo(a.group.critical);
      if (byCritical != 0) return byCritical;
      return _comparable(a.name).compareTo(_comparable(b.name));
    });
    return sectors;
  }

  /// Sectors with plots in alphabetical order, as the picker of G21 shows them.
  List<RiskSector> get sectorsByName =>
      _sectors()..sort((a, b) => _comparable(a.name).compareTo(_comparable(b.name)));

  RiskSector? sector(String id) {
    for (final sector in _sectors()) {
      if (sector.id == id) return sector;
    }
    return null;
  }

  List<RiskSector> _sectors() {
    final byId = <String, List<RiskPlot>>{};
    final names = <String, String>{};
    for (final plot in plots) {
      final id = plot.sectorId;
      if (id == null) continue;
      (byId[id] ??= []).add(plot);
      names[id] = plot.sectorName ?? '';
    }
    return [
      for (final entry in byId.entries)
        RiskSector(id: entry.key, name: names[entry.key]!, group: RiskGroup(entry.value)),
    ];
  }

  static int _urgency(PlotRisk risk) => switch (risk) {
        PlotRisk.critical => 0,
        PlotRisk.moderate => 1,
        PlotRisk.noData => 2,
        PlotRisk.optimal => 3,
      };

  static String _comparable(String name) => name.toLowerCase();
}
