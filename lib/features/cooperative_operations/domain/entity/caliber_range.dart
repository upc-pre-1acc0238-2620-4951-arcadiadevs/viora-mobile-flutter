/// A caliber class of the plant, in fruits per kilogram: a lower number means bigger fruit. Both ends belong to it.
class CaliberRange {
  const CaliberRange({required this.minFruitsPerKg, required this.maxFruitsPerKg});

  final int minFruitsPerKg;
  final int maxFruitsPerKg;

  @override
  bool operator ==(Object other) =>
      other is CaliberRange && other.minFruitsPerKg == minFruitsPerKg && other.maxFruitsPerKg == maxFruitsPerKg;

  @override
  int get hashCode => Object.hash(minFruitsPerKg, maxFruitsPerKg);
}
