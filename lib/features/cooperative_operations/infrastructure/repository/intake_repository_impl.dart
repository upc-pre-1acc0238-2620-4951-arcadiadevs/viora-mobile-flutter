import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/intake_repository.dart';
import 'package:viora/features/cooperative_operations/domain/valueobject/kept.dart';
import 'package:viora/features/cooperative_operations/infrastructure/local/manager_snapshot_store.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/intake_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/intake_forecast_dto.dart';

class IntakeRepositoryImpl implements IntakeRepository {
  const IntakeRepositoryImpl({required this.api, this.snapshots});

  static const _campaignsKey = 'intake-forecasts';

  final IntakeApi api;

  /// Keeps the last campaigns read for G30 without a connection. Null keeps nothing.
  final ManagerSnapshotStore? snapshots;

  @override
  Future<List<IntakeForecast>> campaigns() => _call(() async {
        final dtos = await api.campaigns();
        await snapshots?.keep(_campaignsKey, [for (final dto in dtos) dto.json]);
        return dtos.map((dto) => dto.toDomain()).toList();
      });

  @override
  Future<IntakeForecast> campaign(int year) => _call(() async {
        final dto = await api.campaign(year);
        await snapshots?.keep('$_campaignsKey/$year', dto.json);
        return dto.toDomain();
      });

  @override
  Future<Kept<List<IntakeForecast>>?> keptCampaigns() async {
    final kept = await snapshots?.read(_campaignsKey);
    if (kept == null) return null;
    final campaigns = (kept.value! as List<dynamic>).cast<Map<String, dynamic>>();
    return Kept([for (final json in campaigns) IntakeForecastDto(json).toDomain()], kept.savedAt);
  }

  @override
  Future<Kept<IntakeForecast>?> keptCampaign(int year) async {
    final kept = await snapshots?.read('$_campaignsKey/$year');
    if (kept == null) return null;
    return Kept(IntakeForecastDto(kept.value! as Map<String, dynamic>).toDomain(), kept.savedAt);
  }

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
