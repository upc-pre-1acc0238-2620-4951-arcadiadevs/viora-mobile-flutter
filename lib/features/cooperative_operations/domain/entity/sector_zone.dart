/// A sector of the license's list: a label the members give their plots, never a boundary on
/// the map.
class SectorZone {
  const SectorZone({required this.id, required this.name, required this.plotCount});

  final String id;
  final String name;

  /// How many member plots carry it.
  final int plotCount;
}

/// A plot «Por confirmar»: its member wrote a sector the list doesn't have, and the manager
/// decides whether it becomes a sector or is the same as one of the list.
class PendingSector {
  const PendingSector({
    required this.plotId,
    required this.plotName,
    required this.producerName,
    required this.proposedName,
  });

  final String plotId;
  final String plotName;
  final String producerName;

  /// What the member wrote: «Cerro Blanco».
  final String proposedName;
}

/// How long a sector name can be, as the server checks it.
abstract final class SectorNames {
  static const minLength = 2;
  static const maxLength = 60;

  static bool isValid(String name) {
    final length = name.trim().length;
    return length >= minLength && length <= maxLength;
  }
}
