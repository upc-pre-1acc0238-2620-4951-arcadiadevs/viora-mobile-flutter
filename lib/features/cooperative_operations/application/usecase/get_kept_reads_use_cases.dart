import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';
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

/// The last detail read of a plot, for G23 without a connection.
class GetKeptRiskPlotUseCase {
  const GetKeptRiskPlotUseCase({required this.repository});

  final RiskRepository repository;

  Future<Kept<RiskPlotDetail>?> execute(String plotId) => repository.keptPlot(plotId);
}

/// The last seats and hectares read of the license, for G10 and G40 without a connection.
class GetKeptLicenseCapacityUseCase {
  const GetKeptLicenseCapacityUseCase({required this.repository});

  final CooperativeRepository repository;

  Future<Kept<LicenseCapacity>?> execute() => repository.keptCapacity();
}

/// The last roster read, for G40 without a connection.
class GetKeptMembersUseCase {
  const GetKeptMembersUseCase({required this.repository});

  final CooperativeRepository repository;

  Future<Kept<List<CooperativeMember>>?> execute() => repository.keptMembers();
}

/// The last codes read of a filter, for G40 without a connection.
class GetKeptInvitationCodesUseCase {
  const GetKeptInvitationCodesUseCase({required this.repository});

  final CooperativeRepository repository;

  Future<Kept<List<InvitationCode>>?> execute(InvitationCodeFilter filter) => repository.keptCodes(filter);
}
