import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_zone.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/sector_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/sector_api.dart';

class SectorRepositoryImpl implements SectorRepository {
  const SectorRepositoryImpl({required this.api});

  final SectorApi api;

  @override
  Future<List<SectorZone>> sectors() => _call(api.sectors, CooperativeErrorMapper.read);

  @override
  Future<List<PendingSector>> pending() => _call(api.pending, CooperativeErrorMapper.read);

  @override
  Future<SectorZone> add(String name) => _call(() => api.add(name.trim()), CooperativeErrorMapper.sector);

  @override
  Future<SectorZone> rename(String sectorId, String name) =>
      _call(() => api.rename(sectorId, name.trim()), CooperativeErrorMapper.sector);

  @override
  Future<void> resolve(String plotId, {String? sectorId}) =>
      _call(() => api.resolve(plotId, sectorId: sectorId), CooperativeErrorMapper.sector);

  Future<T> _call<T>(Future<T> Function() request, CooperativeFailure Function(ApiException) map) async {
    try {
      return await request();
    } on ApiUnreachableException {
      throw const CooperativeOffline();
    } on ApiException catch (error) {
      throw map(error);
    }
  }
}
