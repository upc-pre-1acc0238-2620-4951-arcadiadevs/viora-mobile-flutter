import 'package:viora/core/domain/decimal.dart';
import 'package:viora/features/subscription/domain/entity/producer_plan_offer.dart';
import 'package:viora/features/subscription/domain/valueobject/plan_capacity.dart';
import 'package:viora/features/subscription/domain/valueobject/producer_plan_code.dart';

/// Required catalog fields from GET subscription-plans; independent of redemption DTOs.
class ProducerPlanOfferDto {
  const ProducerPlanOfferDto({
    required this.code,
    required this.currency,
    required this.monthlyRatePerHa,
    required this.taxRate,
    required this.minimumQuotaHa,
    required this.quotaIncrementHa,
    required this.billingMonths,
    required this.tariffVersion,
    required this.taxIncluded,
  });

  /// A missing or mistyped field throws, so an incomplete plan never reaches the catalog.
  factory ProducerPlanOfferDto.fromJson(Map<String, dynamic> json) => ProducerPlanOfferDto(
        code: json['code'] as String,
        currency: json['currency'] as String,
        monthlyRatePerHa: _decimal(json['monthlyRatePerHa']),
        taxRate: _decimal(json['taxRate']),
        minimumQuotaHa: _decimal(json['minimumQuotaHa']),
        quotaIncrementHa: _decimal(json['quotaIncrementHa']),
        billingMonths: (json['billingMonths'] as num).toInt(),
        tariffVersion: json['tariffVersion'] as String,
        taxIncluded: json['taxIncluded'] as bool,
      );

  final String code;
  final String currency;
  final Decimal monthlyRatePerHa;
  final Decimal taxRate;
  final Decimal minimumQuotaHa;
  final Decimal quotaIncrementHa;
  final int billingMonths;
  final String tariffVersion;
  final bool taxIncluded;

  // The decoded JSON already holds a number: its shortest text ("0.18") is the original decimal.
  static Decimal _decimal(Object? value) {
    if (value is! num && value is! String) throw FormatException('Invalid catalog decimal', value);
    return Decimal.parse('$value');
  }

  /// Rejects incomplete or inconsistent policies before they replace a valid kept catalog.
  ProducerPlanOffer toDomain() => ProducerPlanOffer(
        code: ProducerPlanCode(code),
        currency: currency,
        monthlyRatePerHa: monthlyRatePerHa,
        taxRate: taxRate,
        minimumQuota: PlanCapacity.of(minimumQuotaHa),
        quotaIncrement: PlanCapacity.of(quotaIncrementHa),
        billingMonths: billingMonths,
        tariffVersion: tariffVersion,
        taxIncluded: taxIncluded,
      );
}
