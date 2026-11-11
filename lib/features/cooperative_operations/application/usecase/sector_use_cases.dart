import 'package:viora/features/cooperative_operations/domain/entity/sector_zone.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/sector_repository.dart';

/// G45 · Sectores and the «Sectores» card of G40: the list and what waits for review.
class GetSectorsUseCase {
  const GetSectorsUseCase({required this.repository});

  final SectorRepository repository;

  Future<({List<SectorZone> sectors, List<PendingSector> pending})> execute() async {
    final sectors = await repository.sectors();
    final pending = await repository.pending();
    return (sectors: sectors, pending: pending);
  }
}

/// G47 · Añadir sector, and renaming one: a name outside 2 to 60 letters is refused before
/// sending.
class SaveSectorUseCase {
  const SaveSectorUseCase({required this.repository});

  final SectorRepository repository;

  /// Adds [name], or renames [sectorId] to it when given.
  Future<SectorZone> execute(String name, {String? sectorId}) {
    final trimmed = name.trim();
    if (!SectorNames.isValid(trimmed)) throw const SectorNameInvalid();
    return sectorId == null ? repository.add(trimmed) : repository.rename(sectorId, trimmed);
  }
}

/// G46 · Revisar sector: «Añadir como sector», or «Es el mismo que…» with [sectorId].
class ResolvePendingSectorUseCase {
  const ResolvePendingSectorUseCase({required this.repository});

  final SectorRepository repository;

  Future<void> execute(String plotId, {String? sectorId}) => repository.resolve(plotId, sectorId: sectorId);
}
