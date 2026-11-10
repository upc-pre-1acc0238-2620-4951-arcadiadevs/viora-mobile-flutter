import 'dart:typed_data';

/// T16 · Expediente técnico: the provisional dossier of a member plot. It is read when asked,
/// with the instant its data was cut off; it isn't certified and carries no verification code.
/// Any figure without records is null and reads as «No disponible».
class ProvisionalDossier {
  const ProvisionalDossier({
    required this.plotId,
    required this.plotName,
    required this.producerName,
    required this.organizationName,
    required this.variety,
    required this.areaHa,
    required this.campaignYear,
    required this.cutOffAt,
    required this.fruitsPerShoot,
    required this.targetFruitsPerShoot,
    required this.overTargetPercent,
    required this.removalPercent,
    required this.windowOpensOn,
    required this.windowClosesOn,
    required this.sampledTrees,
    required this.lastSampledOn,
    required this.thinnedOn,
    required this.linkedNodes,
    required this.daysWithReadings,
  });

  final String plotId;
  final String plotName;
  final String producerName;
  final String organizationName;
  final String? variety;
  final double? areaHa;
  final int campaignYear;

  /// When the data was read; null only if the server didn't say.
  final DateTime? cutOffAt;

  final double? fruitsPerShoot;
  final double? targetFruitsPerShoot;
  final double? overTargetPercent;

  /// The prescribed thinning, in percent of the fruits.
  final double? removalPercent;
  final DateTime? windowOpensOn;
  final DateTime? windowClosesOn;
  final int sampledTrees;
  final DateTime? lastSampledOn;

  /// Null while the thinning isn't registered: «Aún no».
  final DateTime? thinnedOn;
  final int linkedNodes;
  final int daysWithReadings;
}

/// The PDF of a dossier, ready to keep or send.
class DossierFile {
  const DossierFile({required this.bytes, required this.fileName});

  final Uint8List bytes;
  final String fileName;
}
