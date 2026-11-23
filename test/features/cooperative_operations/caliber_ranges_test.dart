import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/application/usecase/caliber_range_use_cases.dart';
import 'package:viora/features/cooperative_operations/domain/entity/caliber_range.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/caliber_range_repository.dart';
import 'package:viora/features/cooperative_operations/presentation/state/caliber_ranges_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/caliber_ranges_page.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/caliber_ranges_view_model.dart';

class _FakeRanges implements CaliberRangeRepository {
  List<CaliberRange> stored = const [];
  CooperativeFailure? refusal;
  List<CaliberRange>? sent;

  @override
  Future<List<CaliberRange>> ranges() async => stored;

  @override
  Future<List<CaliberRange>> replace(List<CaliberRange> ranges) async {
    sent = ranges;
    final refusal = this.refusal;
    if (refusal != null) throw refusal;
    return stored = ranges;
  }
}

Widget _app(Widget home) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

void main() {
  late _FakeRanges repository;
  late CaliberRangesViewModel viewModel;

  setUp(() {
    repository = _FakeRanges();
    viewModel = CaliberRangesViewModel(
      getRanges: GetCaliberRangesUseCase(repository: repository),
      replaceRanges: ReplaceCaliberRangesUseCase(repository: repository),
    );
  });

  tearDown(() => viewModel.close());

  group('Rangos de calibre', () {
    test('reads the ranges, and a new one starts right after the last', () async {
      repository.stored = const [CaliberRange(minFruitsPerKg: 140, maxFruitsPerKg: 180)];
      await viewModel.load();
      viewModel.add();

      expect(viewModel.state.drafts.map((draft) => draft.min), ['140', '181']);
    });

    test('the first range of a plant without ranges starts at 140', () async {
      await viewModel.load();
      viewModel.add();

      expect(viewModel.state.drafts.single.min, '140');
    });

    test('an incomplete range is pointed out before anything is sent', () async {
      await viewModel.load();
      viewModel.add();
      await viewModel.save();

      expect(viewModel.state.conflictIndex, 0);
      expect(viewModel.state.conflictReason, 'territory.caliber_range.incomplete');
      expect(repository.sent, isNull);
    });

    test('stored ranges close the screen; a refused one is pointed out and the screen stays', () async {
      await viewModel.load();
      viewModel
        ..add()
        ..editMax(0, '180')
        ..add()
        ..editMin(1, '170')
        ..editMax(1, '220');
      repository.refusal = const CaliberRangeConflict(reason: 'territory.caliber_range.overlapping', rangeIndex: 1);
      await viewModel.save();
      expect(viewModel.state.saved, isFalse);
      expect(viewModel.state.conflictIndex, 1);

      viewModel.editMin(1, '181');
      expect(viewModel.state.conflictIndex, isNull);
      repository.refusal = null;
      await viewModel.save();
      expect(viewModel.state.saved, isTrue);
      expect(repository.stored, const [
        CaliberRange(minFruitsPerKg: 140, maxFruitsPerKg: 180),
        CaliberRange(minFruitsPerKg: 181, maxFruitsPerKg: 220),
      ]);
    });

    testWidgets('the refused range says why, under its own fields', (tester) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(CaliberRangesPageContent(
        state: const CaliberRangesUiState(
          loading: false,
          drafts: [CaliberRangeDraft(min: '140', max: '180'), CaliberRangeDraft(min: '170', max: '220')],
          conflictIndex: 1,
          conflictReason: 'territory.caliber_range.overlapping',
        ),
        onBack: () {},
        onRetry: () {},
        onEditMin: (_, _) {},
        onEditMax: (_, _) {},
        onAdd: () {},
        onRemove: (_) {},
        onSave: () {},
      )));

      expect(find.text('Rango 2'), findsOneWidget);
      expect(find.text('Se superpone con el rango anterior.'), findsOneWidget);
      expect(find.text('Guardar rangos'), findsOneWidget);
    });
  });
}
