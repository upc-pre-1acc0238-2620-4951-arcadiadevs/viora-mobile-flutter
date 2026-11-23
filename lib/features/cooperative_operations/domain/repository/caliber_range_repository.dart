import 'package:viora/features/cooperative_operations/domain/entity/caliber_range.dart';

/// The caliber ranges the plant of the license sorts olives by. Fails with a `CooperativeFailure`.
abstract interface class CaliberRangeRepository {
  /// The ranges, from the biggest fruit to the smallest; empty when the plant set none.
  Future<List<CaliberRange>> ranges();

  /// Replaces every range at once and answers the ones stored; an empty list clears them.
  Future<List<CaliberRange>> replace(List<CaliberRange> ranges);
}
