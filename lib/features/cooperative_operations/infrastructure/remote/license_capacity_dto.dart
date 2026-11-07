import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';

/// A license as GET cooperative-licenses answers it, with what is used and what is free.
class LicenseCapacityDto {
  const LicenseCapacityDto(this.json);

  factory LicenseCapacityDto.fromJson(Map<String, dynamic> json) => LicenseCapacityDto(json);

  final Map<String, dynamic> json;

  LicenseCapacity toDomain() {
    final seats = (json['seats'] as num).toInt();
    final contracted = (json['contractedAreaHa'] as num).toDouble();
    return LicenseCapacity(
      organizationName: json['organizationName'] as String,
      seats: seats,
      contractedAreaHa: contracted,
      seatsUsed: (json['seatsUsed'] as num?)?.toInt() ?? 0,
      seatsFree: (json['seatsFree'] as num?)?.toInt() ?? seats,
      reservedAreaHa: (json['reservedAreaHa'] as num?)?.toDouble() ?? 0,
      freeAreaHa: (json['freeAreaHa'] as num?)?.toDouble() ?? contracted,
      suggestedHectaresPerCode: (json['suggestedHectaresPerCode'] as num?)?.toDouble() ?? 0,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
    );
  }
}
