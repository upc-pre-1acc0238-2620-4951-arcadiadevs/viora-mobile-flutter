import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/risk_plot_dto.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/sector_alert_dto.dart';

/// The plots of the members who share and the alerts of their sectors.
class RiskApi {
  const RiskApi({required this.client});

  final ApiClient client;

  Future<List<RiskPlotDto>> plots({GeoCoordinate? origin}) async {
    final query = origin == null ? '' : '?latitude=${origin.latitude}&longitude=${origin.longitude}';
    return (await client.getList('member-plots$query')).map(RiskPlotDto.fromJson).toList();
  }

  Future<RiskPlotDetailDto> plot(String id) async => RiskPlotDetailDto.fromJson(await client.get('member-plots/$id'));

  Future<bool> hasActiveAlerts() async =>
      (await client.getList('sector-alerts')).any((alert) => alert['status'] == 'ACTIVE');

  Future<List<SectorAlertDto>> alerts() async =>
      (await client.getList('sector-alerts')).map(SectorAlertDto.fromJson).toList();
}
