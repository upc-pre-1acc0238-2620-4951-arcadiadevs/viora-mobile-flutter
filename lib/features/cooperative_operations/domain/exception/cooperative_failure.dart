/// Why reading the roster or handling codes failed, in the terms the screens react to.
sealed class CooperativeFailure implements Exception {
  const CooperativeFailure();
}

/// The server couldn't be reached.
class CooperativeOffline extends CooperativeFailure {
  const CooperativeOffline();
}

/// Anything else, shown as a generic failure.
class CooperativeUnexpected extends CooperativeFailure {
  const CooperativeUnexpected();
}

/// The manager has no license in force.
class CooperativeNoLicense extends CooperativeFailure {
  const CooperativeNoLicense();
}

/// The member stopped sharing the plot, or it isn't theirs anymore.
class PlotNotShared extends CooperativeFailure {
  const PlotNotShared();
}

/// Not enough free seats for the codes asked; [seatsFree] is what is left, when known.
class NotEnoughSeats extends CooperativeFailure {
  const NotEnoughSeats(this.seatsFree);

  final int? seatsFree;
}

/// Not enough free hectares for the codes asked; [freeAreaHa] is what is left, when known.
class NotEnoughArea extends CooperativeFailure {
  const NotEnoughArea(this.freeAreaHa);

  final double? freeAreaHa;
}

/// Codes can't be issued now (the server isn't set up to keep them).
class CodesUnavailable extends CooperativeFailure {
  const CodesUnavailable();
}

/// The code was redeemed before it could be revoked.
class CodeAlreadyRedeemed extends CooperativeFailure {
  const CodeAlreadyRedeemed(this.redeemedAt);

  final DateTime? redeemedAt;
}

/// The code had already expired or been revoked.
class CodeNotAvailable extends CooperativeFailure {
  const CodeNotAvailable();
}

/// The list already has a sector with that name, ignoring accents and case.
class SectorNameTaken extends CooperativeFailure {
  const SectorNameTaken();
}

/// The server refused the name: blank, too short or too long.
class SectorNameInvalid extends CooperativeFailure {
  const SectorNameInvalid();
}

/// The plot was no longer «Por confirmar»: another review got there first.
class SectorAlreadyResolved extends CooperativeFailure {
  const SectorAlreadyResolved();
}
