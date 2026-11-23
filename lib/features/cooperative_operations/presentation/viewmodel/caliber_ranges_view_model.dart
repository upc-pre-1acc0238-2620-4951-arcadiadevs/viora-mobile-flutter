import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/caliber_range_use_cases.dart';
import 'package:viora/features/cooperative_operations/domain/entity/caliber_range.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/caliber_ranges_ui_state.dart';

/// The caliber ranges of the plant: read, edited row by row and stored as a whole.
class CaliberRangesViewModel extends Cubit<CaliberRangesUiState> {
  CaliberRangesViewModel({required this.getRanges, required this.replaceRanges})
      : super(const CaliberRangesUiState());

  /// Where a first range starts when the plant set none: the large end of a usual table olive.
  static const firstMin = 140;

  final GetCaliberRangesUseCase getRanges;
  final ReplaceCaliberRangesUseCase replaceRanges;

  Future<void> load() async {
    _emit(state.copyWith(loading: true, failure: () => null));
    try {
      final ranges = await getRanges.execute();
      _emit(state.copyWith(loading: false, drafts: [for (final range in ranges) CaliberRangeDraft.of(range)]));
    } on CooperativeFailure catch (failure) {
      _emit(state.copyWith(loading: false, failure: () => failure));
    }
  }

  void editMin(int index, String value) => _edit(index, state.drafts[index].copyWith(min: value));

  void editMax(int index, String value) => _edit(index, state.drafts[index].copyWith(max: value));

  /// A new range starts right after the last one, so they stay consecutive.
  void add() {
    final last = state.drafts.isEmpty ? null : state.drafts.last.range;
    final min = last == null ? firstMin : last.maxFruitsPerKg + 1;
    _emit(state.copyWith(drafts: [...state.drafts, CaliberRangeDraft(min: '$min')], conflict: (null, null)));
  }

  void remove(int index) =>
      _emit(state.copyWith(drafts: [...state.drafts]..removeAt(index), conflict: (null, null)));

  Future<void> save() async {
    final ranges = <CaliberRange>[];
    for (var i = 0; i < state.drafts.length; i++) {
      final range = state.drafts[i].range;
      if (range == null) {
        _emit(state.copyWith(conflict: (i, 'territory.caliber_range.incomplete')));
        return;
      }
      ranges.add(range);
    }
    _emit(state.copyWith(saving: true, conflict: (null, null)));
    try {
      final stored = await replaceRanges.execute(ranges);
      _emit(state.copyWith(
        saving: false,
        saved: true,
        drafts: [for (final range in stored) CaliberRangeDraft.of(range)],
      ));
    } on CaliberRangeConflict catch (conflict) {
      _emit(state.copyWith(saving: false, conflict: (conflict.rangeIndex, conflict.reason)));
    } on CooperativeFailure catch (failure) {
      _emit(state.copyWith(saving: false, failure: () => failure));
    }
  }

  void _edit(int index, CaliberRangeDraft draft) {
    final drafts = [...state.drafts]..[index] = draft;
    _emit(state.copyWith(drafts: drafts, conflict: state.conflictIndex == index ? (null, null) : null));
  }

  void _emit(CaliberRangesUiState next) {
    if (!isClosed) emit(next);
  }
}
