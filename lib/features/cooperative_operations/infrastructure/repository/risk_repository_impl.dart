import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';
import 'package:viora/features/cooperative_operations/infrastructure/local/manager_snapshot_store.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/risk_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/risk_plot_dto.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/sector_alert_dto.dart';

class RiskRepositoryImpl implements RiskRepository {
  const RiskRepositoryImpl({required this.api, this.snapshots});

  static const _plotsKey = 'member-plots';
  static const _alertsKey = 'sector-alerts';

  final RiskApi api;

  /// Keeps the last map and alerts for the screens without a connection. Null keeps nothing.
  final ManagerSnapshotStore? snapshots;

  @override
  Future<List<RiskPlot>> plots({GeoCoordinate? origin}) => _call(() async {
        final dtos = await api.plots(origin: origin);
        await snapshots?.keep(_plotsKey, [for (final dto in dtos) dto.json]);
        return dtos.map((dto) => dto.toDomain()).toList();
      });

  @override
  Future<Kept<List<RiskPlot>>?> keptPlots() async {
    final kept = await snapshots?.read(_plotsKey);
    if (kept == null) return null;
    return Kept([for (final json in _objects(kept.value)) RiskPlotDto(json).toDomain()], kept.savedAt);
  }

  @override
  Future<RiskPlotDetail> plot(String id) => _call(() async => (await api.plot(id)).toDomain());

  @override
  Future<bool> hasActiveAlerts() => _call(api.hasActiveAlerts);

  @override
  Future<List<SectorAlert>> alerts() => _call(() async {
        final dtos = await api.alerts();
        await snapshots?.keep(_alertsKey, [for (final dto in dtos) dto.json]);
        return dtos.map((dto) => dto.toDomain()).toList();
      });

  @override
  Future<Kept<List<SectorAlert>>?> keptAlerts() async {
    final kept = await snapshots?.read(_alertsKey);
    if (kept == null) return null;
    return Kept([for (final json in _objects(kept.value)) SectorAlertDto(json).toDomain()], kept.savedAt);
  }

  static List<Map<String, dynamic>> _objects(Object? json) => (json! as List<dynamic>).cast<Map<String, dynamic>>();

  Future<T> _call<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on ApiUnreachableException {
      throw const CooperativeOffline();
    } on ApiException catch (error) {
      throw CooperativeErrorMapper.read(error);
    }
  }
}
