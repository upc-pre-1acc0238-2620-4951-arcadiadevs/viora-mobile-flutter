import 'package:viora/core/domain/decimal.dart';

/// Exact hectare capacity; the offer owns its minimum and selectable increment.
final class PlanCapacity {
  PlanCapacity._(this.hectares);

  factory PlanCapacity.of(Decimal hectares) {
    if (hectares.signum <= 0) throw ArgumentError('subscription.capacity.positive');
    return PlanCapacity._(hectares.stripTrailingZeros());
  }

  final Decimal hectares;

  @override
  bool operator ==(Object other) => other is PlanCapacity && other.hectares == hectares;

  @override
  int get hashCode => hectares.hashCode;
}
