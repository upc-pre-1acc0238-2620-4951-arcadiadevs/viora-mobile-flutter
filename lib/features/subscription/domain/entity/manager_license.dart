/// The license a technical manager is in charge of: the organization that contracted it and
/// what it covers.
class ManagerLicense {
  const ManagerLicense({
    required this.id,
    required this.organizationName,
    required this.seats,
    required this.contractedAreaHa,
    required this.startsAt,
    required this.endsAt,
  });

  final String id;
  final String organizationName;

  /// Producers the license covers.
  final int seats;
  final double contractedAreaHa;
  final DateTime startsAt;

  /// The license ends at this instant, exclusive.
  final DateTime endsAt;

  /// Whether the license is in force at [now]. Computed on the phone, so a kept license also
  /// runs out without a connection.
  bool isActiveAt(DateTime now) => !now.isBefore(startsAt) && now.isBefore(endsAt);
}
