import 'package:viora/features/cooperative_operations/domain/entity/caliber_range.dart';
import 'package:viora/features/cooperative_operations/domain/repository/caliber_range_repository.dart';

/// The caliber ranges of the plant.
class GetCaliberRangesUseCase {
  const GetCaliberRangesUseCase({required this.repository});

  final CaliberRangeRepository repository;

  Future<List<CaliberRange>> execute() => repository.ranges();
}

/// Replaces the caliber ranges of the plant; the intake splits by them from then on.
class ReplaceCaliberRangesUseCase {
  const ReplaceCaliberRangesUseCase({required this.repository});

  final CaliberRangeRepository repository;

  Future<List<CaliberRange>> execute(List<CaliberRange> ranges) => repository.replace(ranges);
}
