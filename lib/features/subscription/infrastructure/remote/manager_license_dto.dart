import 'package:viora/features/subscription/domain/entity/manager_license.dart';

class ManagerLicenseDto {
  const ManagerLicenseDto({
    required this.id,
    required this.organizationName,
    required this.seats,
    required this.contractedAreaHa,
    required this.startsAt,
    required this.endsAt,
  });

  factory ManagerLicenseDto.fromJson(Map<String, dynamic> json) => ManagerLicenseDto(
        id: json['id'] as String,
        organizationName: json['organizationName'] as String,
        seats: (json['seats'] as num).toInt(),
        contractedAreaHa: (json['contractedAreaHa'] as num).toDouble(),
        startsAt: DateTime.parse(json['startsAt'] as String),
        endsAt: DateTime.parse(json['endsAt'] as String),
      );

  final String id;
  final String organizationName;
  final int seats;
  final double contractedAreaHa;
  final DateTime startsAt;
  final DateTime endsAt;

  ManagerLicense toDomain() => ManagerLicense(
        id: id,
        organizationName: organizationName,
        seats: seats,
        contractedAreaHa: contractedAreaHa,
        startsAt: startsAt,
        endsAt: endsAt,
      );
}
