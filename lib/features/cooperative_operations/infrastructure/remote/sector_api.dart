import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_zone.dart';

/// The list of sectors of the license and the plots «Por confirmar».
class SectorApi {
  const SectorApi({required this.client});

  final ApiClient client;

  Future<List<SectorZone>> sectors() async => (await client.getList('sector-zones')).map(_sector).toList();

  Future<List<PendingSector>> pending() async => (await client.getList('plot-sector-assignments?status=pending'))
      .map((json) => PendingSector(
            plotId: json['plotId'] as String,
            plotName: json['plotName'] as String? ?? '',
            producerName: json['producerName'] as String? ?? '',
            proposedName: json['proposedName'] as String? ?? '',
          ))
      .toList();

  Future<SectorZone> add(String name) async => _sector(await client.post('sector-zones', {'name': name}));

  Future<SectorZone> rename(String id, String name) async =>
      _sector(await client.patch('sector-zones/$id', {'name': name}));

  Future<void> resolve(String plotId, {String? sectorId}) async {
    await client.post('plot-sector-assignments/$plotId/resolutions', {'sectorZoneId': ?sectorId});
  }

  static SectorZone _sector(Map<String, dynamic> json) => SectorZone(
        id: json['id'] as String,
        name: json['name'] as String,
        plotCount: (json['plotCount'] as num?)?.toInt() ?? 0,
      );
}
