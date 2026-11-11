import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';

/// The territorial traffic light of the manager's license.
abstract class RiskRepository {
  /// The plots of the members who share, in visit order. [origin] breaks ties by closeness and
  /// gives each plot its distance; the server doesn't keep it.
  Future<List<RiskPlot>> plots({GeoCoordinate? origin});

  /// The plots of the last [plots] read, for the map without a connection.
  Future<Kept<List<RiskPlot>>?> keptPlots();

  Future<RiskPlotDetail> plot(String id);

  /// The last [plot] read of [id], for its screen without a connection.
  Future<Kept<RiskPlotDetail>?> keptPlot(String id);

  /// Whether any sector of the license has an active alert.
  Future<bool> hasActiveAlerts();

  /// The alerts of the license's sectors: the active ones and those normalized in the last 7 days.
  Future<List<SectorAlert>> alerts();

  /// The alerts of the last [alerts] read, for T14 without a connection.
  Future<Kept<List<SectorAlert>>?> keptAlerts();
}

/// Where the manager stands, and how well the phone knows it.
class ManagerLocation {
  const ManagerLocation({required this.coordinate, required this.accuracyMeters});

  final GeoCoordinate coordinate;
  final double accuracyMeters;
}

/// What the manager answered about using their location on the map.
enum LocationChoice { allowed, declined }

/// The phone's GPS. It's only asked while the manager looks at the map, and never stored.
abstract class LocationRepository {
  Future<bool> hasPermission();

  /// Asks the system for the permission. With [openSettings], when the system no longer asks it
  /// opens the app's settings; that needs a request of the manager, never an automatic one.
  Future<bool> requestPermission({required bool openSettings});

  /// Null when the phone can't tell in time.
  Future<ManagerLocation?> current();

  /// The last place [current] found in this session, for the screens opened from the map.
  ManagerLocation? get lastKnown;

  /// The last answer, null until the first opening of the map explains what the GPS is for.
  Future<LocationChoice?> choice();

  Future<void> saveChoice(LocationChoice choice);
}
