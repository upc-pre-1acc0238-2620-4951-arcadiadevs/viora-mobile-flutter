import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/risk_api.dart';

class RiskRepositoryImpl implements RiskRepository {
  const RiskRepositoryImpl({required this.api});

  final RiskApi api;

  @override
  Future<List<RiskPlot>> plots({GeoCoordinate? origin}) =>
      _call(() async => (await api.plots(origin: origin)).map((dto) => dto.toDomain()).toList());

  @override
  Future<RiskPlotDetail> plot(String id) => _call(() async => (await api.plot(id)).toDomain());

  @override
  Future<bool> hasActiveAlerts() => _call(api.hasActiveAlerts);

  @override
  Future<List<SectorAlert>> alerts() =>
      _call(() async => (await api.alerts()).map((dto) => dto.toDomain()).toList());

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
