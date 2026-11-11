import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';

/// The intake the license can expect from its members, campaign by campaign.
abstract class IntakeRepository {
  /// Every campaign of the license, the newest first, without sectors.
  Future<List<IntakeForecast>> campaigns();

  /// One campaign with its sectors.
  Future<IntakeForecast> campaign(int year);
}
