import 'package:viora/core/domain/decimal.dart';
import 'package:viora/features/subscription/domain/valueobject/plan_capacity.dart';
import 'package:viora/features/subscription/domain/valueobject/producer_plan_code.dart';

/// Commercial conditions read from the server; an estimate is never proof of a purchase.
final class ProducerPlanOffer {
  ProducerPlanOffer({
    required this.code,
    required this.currency,
    required this.monthlyRatePerHa,
    required this.taxRate,
    required this.minimumQuota,
    required this.quotaIncrement,
    required this.billingMonths,
    required this.tariffVersion,
    required this.taxIncluded,
  }) {
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(currency)) {
      throw ArgumentError('subscription.currency.invalid');
    }
    if (monthlyRatePerHa.signum < 0) throw ArgumentError('subscription.rate.invalid');
    if (taxRate < Decimal.zero || taxRate > Decimal.one) {
      throw ArgumentError('subscription.tax.invalid');
    }
    if (billingMonths <= 0) throw ArgumentError('subscription.billing.invalid');
    if (tariffVersion.trim().isEmpty) throw ArgumentError('subscription.tariff.blank');
    if (!minimumQuota.hectares.isMultipleOf(quotaIncrement.hectares)) {
      throw ArgumentError('subscription.capacity.increment.invalid');
    }
  }

  final ProducerPlanCode code;
  final String currency;
  final Decimal monthlyRatePerHa;
  final Decimal taxRate;
  final PlanCapacity minimumQuota;
  final PlanCapacity quotaIncrement;
  final int billingMonths;
  final String tariffVersion;
  final bool taxIncluded;

  bool accepts(PlanCapacity capacity) =>
      capacity.hectares >= minimumQuota.hectares &&
      capacity.hectares.isMultipleOf(quotaIncrement.hectares);

  /// Mirrors server rounding for display only; checkout must use the server's confirmed total.
  PlanEstimate estimate(PlanCapacity capacity) {
    if (!accepts(capacity)) throw ArgumentError('subscription.capacity.invalid');
    final months = Decimal.fromInt(billingMonths);
    final annualRate = (monthlyRatePerHa * capacity.hectares * months).setScale(2);
    // Retain explicit legacy catalog semantics; never assume a missing remote flag is inclusive.
    final base = taxIncluded ? annualRate.divide(Decimal.one + taxRate, 2) : annualRate;
    final tax = taxIncluded ? annualRate - base : (base * taxRate).setScale(2);
    final total = base + tax;
    return PlanEstimate(
      base: base,
      tax: tax,
      total: total,
      monthlyTotal: total.divide(months, 2),
    );
  }
}

/// Exact estimated breakdown in the currency of its offer.
final class PlanEstimate {
  const PlanEstimate({
    required this.base,
    required this.tax,
    required this.total,
    required this.monthlyTotal,
  });

  final Decimal base;
  final Decimal tax;
  final Decimal total;
  final Decimal monthlyTotal;
}
