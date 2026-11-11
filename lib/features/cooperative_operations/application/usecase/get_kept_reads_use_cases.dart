import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/repository/intake_repository.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';

// What the phone kept of the last reads, for the screens without a connection (US12, US32).

/// The map of the last time G20 read it.
class GetKeptRiskPlotsUseCase {
  const GetKeptRiskPlotsUseCase({required this.repository});

  final RiskRepository repository;

  Future<Kept<List<RiskPlot>>?> execute() => repository.keptPlots();
}

/// The alerts of the last time T14 read them.
class GetKeptSectorAlertsUseCase {
  const GetKeptSectorAlertsUseCase({required this.repository});

  final RiskRepository repository;

  Future<Kept<List<SectorAlert>>?> execute() => repository.keptAlerts();
}

/// The campaigns of the last time G30 read them.
class GetKeptIntakeForecastsUseCase {
  const GetKeptIntakeForecastsUseCase({required this.repository});

  final IntakeRepository repository;

  Future<Kept<List<IntakeForecast>>?> execute() => repository.keptCampaigns();
}

/// A campaign of the last time G30 read it, with its sectors.
class GetKeptIntakeForecastUseCase {
  const GetKeptIntakeForecastUseCase({required this.repository});

  final IntakeRepository repository;

  Future<Kept<IntakeForecast>?> execute(int campaignYear) => repository.keptCampaign(campaignYear);
}
