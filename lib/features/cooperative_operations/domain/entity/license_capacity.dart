/// The seats and hectares of the license the manager is in charge of, as the server counts
/// them now: a code to redeem holds its seat and hectares until it expires or is revoked.
class LicenseCapacity {
  const LicenseCapacity({
    required this.organizationName,
    required this.seats,
    required this.contractedAreaHa,
    required this.seatsUsed,
    required this.seatsFree,
    required this.reservedAreaHa,
    required this.freeAreaHa,
    required this.suggestedHectaresPerCode,
    required this.startsAt,
    required this.endsAt,
  });

  final String organizationName;
  final int seats;
  final double contractedAreaHa;

  /// Seats held by codes to redeem and by members.
  final int seatsUsed;
  final int seatsFree;
  final double reservedAreaHa;
  final double freeAreaHa;

  /// Hectares per code the license suggests: its free area spread over its free seats.
  final double suggestedHectaresPerCode;
  final DateTime startsAt;
  final DateTime endsAt;
}
