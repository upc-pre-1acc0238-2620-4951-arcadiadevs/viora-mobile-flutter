import 'package:viora/features/cooperative_operations/domain/entity/caliber_range.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// One range as the manager types it, before it is a number.
class CaliberRangeDraft {
  const CaliberRangeDraft({this.min = '', this.max = ''});

  CaliberRangeDraft.of(CaliberRange range)
      : min = '${range.minFruitsPerKg}',
        max = '${range.maxFruitsPerKg}';

  final String min;
  final String max;

  /// Null while an end is empty or not a whole number.
  CaliberRange? get range {
    final from = int.tryParse(min.trim());
    final to = int.tryParse(max.trim());
    return from == null || to == null ? null : CaliberRange(minFruitsPerKg: from, maxFruitsPerKg: to);
  }

  CaliberRangeDraft copyWith({String? min, String? max}) =>
      CaliberRangeDraft(min: min ?? this.min, max: max ?? this.max);
}

/// The caliber ranges of the plant, as the manager edits them.
class CaliberRangesUiState {
  const CaliberRangesUiState({
    this.loading = true,
    this.failure,
    this.drafts = const [],
    this.saving = false,
    this.conflictIndex,
    this.conflictReason,
    this.saved = false,
  });

  final bool loading;

  /// Only when the ranges could not be read.
  final CooperativeFailure? failure;
  final List<CaliberRangeDraft> drafts;
  final bool saving;

  /// The range the server refused, or the one left incomplete, and why.
  final int? conflictIndex;
  final String? conflictReason;

  /// The ranges were stored: the screen can close.
  final bool saved;

  CaliberRangesUiState copyWith({
    bool? loading,
    CooperativeFailure? Function()? failure,
    List<CaliberRangeDraft>? drafts,
    bool? saving,
    (int?, String?)? conflict,
    bool? saved,
  }) =>
      CaliberRangesUiState(
        loading: loading ?? this.loading,
        failure: failure != null ? failure() : this.failure,
        drafts: drafts ?? this.drafts,
        saving: saving ?? this.saving,
        conflictIndex: conflict != null ? conflict.$1 : conflictIndex,
        conflictReason: conflict != null ? conflict.$2 : conflictReason,
        saved: saved ?? this.saved,
      );
}
