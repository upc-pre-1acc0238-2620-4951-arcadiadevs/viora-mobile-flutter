import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/state/issue_codes_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/issue_codes_view_model.dart';

/// Opens G43 over the current screen. Answers the codes issued, or null when it was closed.
Future<IssuedCodes?> showIssueCodesSheet(BuildContext context, LicenseCapacity capacity) =>
    showModalBottomSheet<IssuedCodes>(
      context: context,
      // Over the floating tab bar, which would otherwise cover the end of the sheet.
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: VioraColors.neutral100,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      builder: (context) => BlocProvider(
        create: (context) => getIt<IssueCodesViewModel>(param1: capacity),
        child: BlocConsumer<IssueCodesViewModel, IssueCodesUiState>(
          listenWhen: (previous, current) => current.issued != null && previous.issued == null,
          listener: (context, state) => Navigator.of(context).pop(state.issued),
          builder: (context, state) {
            final viewModel = context.read<IssueCodesViewModel>();
            return IssueCodesSheetContent(
              state: state,
              now: DateTime.now(),
              onClose: () => Navigator.of(context).pop(),
              onIncreaseQuantity: viewModel.increaseQuantity,
              onDecreaseQuantity: viewModel.decreaseQuantity,
              onIncreaseHectares: viewModel.increaseHectares,
              onDecreaseHectares: viewModel.decreaseHectares,
              onValidity: viewModel.selectValidity,
              onIssue: viewModel.issue,
            );
          },
        ),
      ),
    );

/// G43 · Generar códigos and its "Cupo excedido" and "Hectáreas insuficientes" variants.
class IssueCodesSheetContent extends StatelessWidget {
  const IssueCodesSheetContent({
    super.key,
    required this.state,
    required this.now,
    required this.onClose,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onIncreaseHectares,
    required this.onDecreaseHectares,
    required this.onValidity,
    required this.onIssue,
  });

  final IssueCodesUiState state;
  final DateTime now;
  final VoidCallback onClose;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onIncreaseHectares;
  final VoidCallback onDecreaseHectares;
  final ValueChanged<int> onValidity;
  final VoidCallback onIssue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final capacity = state.capacity;
    final failure = state.failure;
    String ha(double value) => formatHectares(value, locale);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          Spacing.lg,
          Spacing.sm,
          Spacing.lg,
          Spacing.lg + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: const ShapeDecoration(color: VioraColors.neutral300, shape: StadiumBorder()),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: VioraEditorialTitle(l10n.issueHeadline, fontSize: 32, lineHeight: 36)),
                VioraCircleButton(
                  iconAsset: VioraIcons.close,
                  label: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              l10n.issueSubtitle(capacity.organizationName, capacity.seatsFree, ha(capacity.freeAreaHa)),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
            ),
            const SizedBox(height: Spacing.md),
            _StepperCard(
              title: l10n.issueQuantity,
              value: '${state.quantity}',
              caption: state.exceedsSeats ? l10n.issueSeatsExceeded(capacity.seatsFree) : l10n.issueQuantityCaption,
              error: state.exceedsSeats,
              decreaseLabel: l10n.issueDecrease,
              increaseLabel: l10n.issueIncrease,
              onDecrease: state.quantity > 1 ? onDecreaseQuantity : null,
              onIncrease: state.exceedsSeats ? null : onIncreaseQuantity,
            ),
            const SizedBox(height: Spacing.sm),
            _StepperCard(
              title: l10n.issueHectares,
              value: ha(state.hectaresPerCode),
              caption: state.exceedsArea
                  ? l10n.issueAreaExceeded(ha(state.totalHectares), ha(capacity.freeAreaHa))
                  : state.hectaresSuggested
                  ? l10n.issueHectaresSuggested
                  : l10n.issueHectaresCaption,
              error: state.exceedsArea && !state.exceedsSeats,
              decreaseLabel: l10n.issueDecrease,
              increaseLabel: l10n.issueIncrease,
              onDecrease: state.hectaresPerCode > IssueCodesViewModel.hectareStep ? onDecreaseHectares : null,
              onIncrease: state.exceedsArea ? null : onIncreaseHectares,
            ),
            const SizedBox(height: Spacing.sm),
            _ValidityCard(selected: state.validityDays, onSelect: onValidity),
            const SizedBox(height: Spacing.sm),
            _PreviewBanner(state: state, now: now),
            if (failure != null && failure is! NotEnoughSeats && failure is! NotEnoughArea) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                cooperativeFailureMessage(l10n, failure),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.terracotta600),
              ),
            ],
            const SizedBox(height: Spacing.md),
            CooperativeActionPill(
              label: l10n.issueAction(state.quantity),
              iconAsset: VioraIcons.check,
              loading: state.issuing,
              onPressed: state.canIssue ? onIssue : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperCard extends StatelessWidget {
  const _StepperCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.error,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String title;
  final String value;
  final String caption;
  final bool error;
  final String decreaseLabel;
  final String increaseLabel;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = error ? VioraColors.terracotta600 : VioraColors.neutral900;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: VioraColors.neutral0,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: error ? VioraColors.terracotta500 : VioraColors.neutral0, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(letterSpacing: 1.2, color: VioraColors.neutral600),
            ),
            const SizedBox(height: Spacing.xs),
            Row(
              children: [
                _RoundStep(asset: VioraIcons.remove, label: decreaseLabel, onPressed: onDecrease, filled: false),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        value,
                        style: TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 44, height: 1.1, color: accent),
                      ),
                      Text(
                        caption,
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(color: error ? accent : VioraColors.neutral600),
                      ),
                    ],
                  ),
                ),
                _RoundStep(asset: VioraIcons.add, label: increaseLabel, onPressed: onIncrease, filled: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundStep extends StatelessWidget {
  const _RoundStep({required this.asset, required this.label, required this.onPressed, required this.filled});

  final String asset;
  final String label;
  final VoidCallback? onPressed;

  /// The plus of the design is dark green; disabled, both are light.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final background = filled && enabled ? VioraColors.green800 : VioraColors.neutral100;
    final foreground = filled && enabled
        ? VioraColors.neutral50
        : enabled
        ? VioraColors.neutral900
        : VioraColors.neutral500;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: Spacing.minTouchTarget,
            child: Center(child: VioraIcon(asset, color: foreground)),
          ),
        ),
      ),
    );
  }
}

class _ValidityCard extends StatelessWidget {
  const _ValidityCard({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(color: VioraColors.neutral0, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.issueValidity.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(letterSpacing: 1.2, color: VioraColors.neutral600),
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                for (final days in IssueCodesUiState.validities) ...[
                  if (days != IssueCodesUiState.validities.first) const SizedBox(width: Spacing.xs),
                  // The three share the width, so they fit on narrow phones too.
                  Expanded(
                    child: Semantics(
                      selected: days == selected,
                      button: true,
                      child: Material(
                        color: days == selected ? VioraColors.green900 : VioraColors.neutral100,
                        shape: const StadiumBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => onSelect(days),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: 10),
                            child: Text(
                              l10n.issueDays(days),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: textTheme.labelLarge?.copyWith(
                                color: days == selected ? VioraColors.neutral50 : VioraColors.neutral900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// What issuing changes ("48 → 53 de 60 plazas"), or why it can't be done.
class _PreviewBanner extends StatelessWidget {
  const _PreviewBanner({required this.state, required this.now});

  final IssueCodesUiState state;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final capacity = state.capacity;
    String ha(double value) => formatHectares(value, locale);
    final seatsAfter = capacity.seatsUsed + state.quantity;
    final (Color background, Widget child) = state.exceedsSeats
        ? (
            VioraColors.terracotta100,
            FigureLine(
              figure: '$seatsAfter',
              text: l10n.issueSeatsExceededBanner(capacity.seats, capacity.seatsFree),
              color: VioraColors.terracotta700,
            ),
          )
        : state.exceedsArea
        ? (
            VioraColors.terracotta100,
            FigureLine(
              figure: ha(state.totalHectares),
              text: l10n.issueAreaExceededBanner(ha(capacity.freeAreaHa)),
              color: VioraColors.terracotta700,
            ),
          )
        : (
            VioraColors.harvest100,
            FigureLine(
              figure: '${capacity.seatsUsed} → $seatsAfter',
              text: l10n.issuePreview(
                capacity.seats,
                ha(capacity.reservedAreaHa),
                ha(capacity.reservedAreaHa + state.totalHectares),
                ha(capacity.contractedAreaHa),
                DateFormat('d MMM', locale).format(state.expiresOn(now)).replaceAll('.', ''),
              ),
            ),
          );
    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Padding(padding: const EdgeInsets.all(Spacing.md), child: child),
    );
  }
}
