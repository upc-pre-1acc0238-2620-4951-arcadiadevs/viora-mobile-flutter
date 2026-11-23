import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_underline_field.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/presentation/state/caliber_ranges_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/caliber_ranges_view_model.dart';

/// The caliber ranges of the plant, in fruits per kilogram: the classes the intake projection splits by. It closes
/// once they are stored.
class CaliberRangesPage extends StatelessWidget {
  const CaliberRangesPage({super.key, required this.onBack});

  static const path = 'caliber-ranges';

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CaliberRangesViewModel>()..load(),
      child: BlocConsumer<CaliberRangesViewModel, CaliberRangesUiState>(
        listenWhen: (previous, current) => current.saved && !previous.saved,
        listener: (context, state) => onBack(),
        builder: (context, state) {
          final viewModel = context.read<CaliberRangesViewModel>();
          return CaliberRangesPageContent(
            state: state,
            onBack: onBack,
            onRetry: viewModel.load,
            onEditMin: viewModel.editMin,
            onEditMax: viewModel.editMax,
            onAdd: viewModel.add,
            onRemove: viewModel.remove,
            onSave: viewModel.save,
          );
        },
      ),
    );
  }
}

/// Visual content of the caliber ranges, without Bloc, so it can be tested with a fixed state.
class CaliberRangesPageContent extends StatelessWidget {
  const CaliberRangesPageContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onRetry,
    required this.onEditMin,
    required this.onEditMax,
    required this.onAdd,
    required this.onRemove,
    required this.onSave,
  });

  final CaliberRangesUiState state;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final void Function(int index, String value) onEditMin;
  final void Function(int index, String value) onEditMax;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failure = state.failure;
    final reason = state.conflictReason;
    final index = state.conflictIndex;
    final loaded = failure == null && !state.loading;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.sm, Spacing.lg, Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CooperativeTopBar(title: l10n.caliberRangesTitle, subtitle: l10n.caliberRangesSubtitle, onBack: onBack),
              const SizedBox(height: Spacing.sm),
              // The ranges scroll; saving stays at hand under them, as in the account details.
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: Spacing.sm, bottom: Spacing.md),
                  children: [
                    if (failure != null)
                      CooperativeFailureView(failure: failure, onRetry: onRetry)
                    else if (state.loading)
                      const Padding(
                        padding: EdgeInsets.all(Spacing.xl),
                        child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
                      )
                    else ...[
                      VioraVoice(text: l10n.caliberRangesVoice),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        l10n.caliberRangesHint,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700),
                      ),
                      const SizedBox(height: Spacing.md),
                      if (state.drafts.isEmpty)
                        Text(
                          l10n.caliberRangesEmpty,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700),
                        ),
                      for (var i = 0; i < state.drafts.length; i++) ...[
                        _RangeCard(
                          position: i + 1,
                          draft: state.drafts[i],
                          error: index == i && reason != null ? caliberReasonText(l10n, reason) : null,
                          onEditMin: (value) => onEditMin(i, value),
                          onEditMax: (value) => onEditMax(i, value),
                          onRemove: () => onRemove(i),
                        ),
                        const SizedBox(height: Spacing.sm),
                      ],
                      // A refusal that names no range, such as too many of them, goes under the list.
                      if (reason != null && index == null) ...[
                        Text(
                          caliberReasonText(l10n, reason),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.terracotta700),
                        ),
                        const SizedBox(height: Spacing.sm),
                      ],
                      VioraTextButton(label: l10n.caliberRangesAdd, onPressed: state.saving ? null : onAdd),
                    ],
                  ],
                ),
              ),
              if (loaded) VioraButton(label: l10n.caliberRangesSave, loading: state.saving, onPressed: onSave),
            ],
          ),
        ),
      ),
    );
  }
}

/// Why a range was refused, in the manager's words.
String caliberReasonText(AppLocalizations l10n, String reason) => switch (reason) {
      'territory.caliber_range.incomplete' => l10n.caliberRangeIncomplete,
      'territory.caliber_range.overlapping' => l10n.caliberRangeOverlapping,
      'territory.caliber_range.gap' => l10n.caliberRangeGap,
      'territory.caliber_range.inverted' => l10n.caliberRangeInverted,
      'territory.caliber_range.off_scale' => l10n.caliberRangeOffScale,
      'territory.caliber_range_set.too_many' => l10n.caliberRangesTooMany,
      _ => l10n.caliberRangeInvalid,
    };

class _RangeCard extends StatelessWidget {
  const _RangeCard({
    required this.position,
    required this.draft,
    required this.error,
    required this.onEditMin,
    required this.onEditMax,
    required this.onRemove,
  });

  final int position;
  final CaliberRangeDraft draft;
  final String? error;
  final ValueChanged<String> onEditMin;
  final ValueChanged<String> onEditMax;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final digits = [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)];
    return VioraCard(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.caliberRangeLabel(position), style: Theme.of(context).textTheme.titleMedium)),
              IconButton(
                tooltip: l10n.caliberRangeRemove,
                onPressed: onRemove,
                icon: const VioraIcon(VioraIcons.close, size: 20, color: VioraColors.neutral700),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: VioraUnderlineField(
                    label: l10n.caliberRangeFrom,
                    value: draft.min,
                    onChanged: onEditMin,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: VioraUnderlineField(
                    label: l10n.caliberRangeTo,
                    value: draft.max,
                    onChanged: onEditMax,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    error: error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
