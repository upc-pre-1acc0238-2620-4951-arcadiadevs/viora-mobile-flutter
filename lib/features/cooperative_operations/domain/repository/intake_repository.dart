import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';

/// The intake the license can expect from its members, campaign by campaign.
abstract class IntakeRepository {
  /// Every campaign of the license, the newest first, without sectors.
  Future<List<IntakeForecast>> campaigns();

  /// One campaign with its sectors.
  Future<IntakeForecast> campaign(int year);

  /// The campaigns of the last [campaigns] read, for G30 without a connection.
  Future<Kept<List<IntakeForecast>>?> keptCampaigns();

  /// The last [campaign] read of [year].
  Future<Kept<IntakeForecast>?> keptCampaign(int year);
}
