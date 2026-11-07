/// Identity supplied by the subscription catalog, never inferred from a display name.
final class ProducerPlanCode {
  ProducerPlanCode(this.value) {
    if (value.trim().isEmpty) throw ArgumentError('subscription.plan.code.blank');
  }

  final String value;

  @override
  bool operator ==(Object other) => other is ProducerPlanCode && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
