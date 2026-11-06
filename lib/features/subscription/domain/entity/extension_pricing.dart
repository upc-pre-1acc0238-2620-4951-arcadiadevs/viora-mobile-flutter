import 'package:viora/core/domain/decimal.dart';

/// The terms of a paid extension. The backend prorates it by the days left of the plan and
/// publishes the price of one hectare for those days, IGV included, as [ratePerHa]: the total is
/// hectares × [ratePerHa] rounded to cents, the same product the backend charges. [billableDays]
/// is null against a backend that billed whole months; [ratePerHa] is then the monthly rate ×
/// [billableMonths].
final class ExtensionPricing {
  ExtensionPricing({
    required this.billableMonths,
    required this.monthlyRatePerHa,
    required this.currency,
    required this.minimum,
    required this.increment,
    this.billableDays,
    Decimal? ratePerHa,
  }) : ratePerHa = ratePerHa ?? monthlyRatePerHa * Decimal.fromInt(billableMonths);

  final int billableMonths;
  final Decimal monthlyRatePerHa;
  final String currency;
  final Decimal minimum;
  final Decimal increment;
  final int? billableDays;
  final Decimal ratePerHa;

  Decimal total(Decimal addedHectares) => (addedHectares * ratePerHa).setScale(2);
}
