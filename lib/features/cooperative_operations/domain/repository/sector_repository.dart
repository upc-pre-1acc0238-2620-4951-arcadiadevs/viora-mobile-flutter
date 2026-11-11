import 'package:viora/features/cooperative_operations/domain/entity/sector_zone.dart';

/// The license's list of sectors and the plots «Por confirmar». Sectors are added and renamed,
/// never deleted, in the MVP.
abstract class SectorRepository {
  Future<List<SectorZone>> sectors();

  /// The plots whose member wrote a sector the list doesn't have.
  Future<List<PendingSector>> pending();

  /// Throws [SectorNameTaken] when the list already has it, ignoring accents and case.
  Future<SectorZone> add(String name);

  /// Every plot in the sector shows the new name. Throws [SectorNameTaken] like [add].
  Future<SectorZone> rename(String sectorId, String name);

  /// «Añadir como sector» without [sectorId]; «Es el mismo que…» with it. Every plot where the
  /// same name was written is resolved alike. Throws [SectorAlreadyResolved] when it no longer
  /// waits.
  Future<void> resolve(String plotId, {String? sectorId});
}
