import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/domain/decimal.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/presentation/number_formats.dart';
import 'package:viora/features/subscription/domain/exception/plan_catalog_failure.dart';
import 'package:viora/features/subscription/presentation/state/producer_plan_ui_state.dart';
import 'package:viora/features/subscription/presentation/viewmodel/producer_plan_view_model.dart';

/// Browsing and sizing the Producer Plan: the tariff per hectare, the capacity and the annual
/// estimate. Payment is deliberately outside this screen. With [onCooperativeCode] it also offers
/// the way in for members whose cooperative covers the plan.
class ProducerPlanPage extends StatelessWidget {
  const ProducerPlanPage({super.key, this.hectares, this.onCooperativeCode});

  static const path = '/plans';

  /// Seeds the first selection, such as the hectares answered in the onboarding.
  final Decimal? hectares;
  final VoidCallback? onCooperativeCode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProducerPlanViewModel>()..start(hectares: hectares),
      child: Scaffold(
        backgroundColor: VioraColors.neutral50,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xs),
                  child: IconButton(
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ProducerPlanViewModel, ProducerPlanUiState>(
                  builder: (context, state) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
                    child: _Body(state: state, onCooperativeCode: onCooperativeCode),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.onCooperativeCode});

  final ProducerPlanUiState state;
  final VoidCallback? onCooperativeCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<ProducerPlanViewModel>();
    final state = this.state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VioraEyebrow(l10n.producerPlanEyebrow, dotColor: VioraColors.harvest300),
        const SizedBox(height: Spacing.xs),
        VioraEditorialTitle(l10n.producerPlanTitle, fontSize: 40, lineHeight: 44),
        const SizedBox(height: Spacing.lg),
        const Divider(color: VioraColors.neutral200, height: 1),
        switch (state) {
          ProducerPlanLoading() => _Message(l10n.producerPlanLoading),
          ProducerPlanFailed(:final failure) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Message(_failureText(l10n, failure), isError: true),
                VioraTextButton(label: l10n.commonRetry, onPressed: viewModel.refresh),
              ],
            ),
          ProducerPlanEmpty(:final isRefreshing, :final failure) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Message(l10n.producerPlanEmpty),
                if (failure != null) _Message(_failureText(l10n, failure), isError: true),
                VioraTextButton(
                  label: l10n.commonRetry,
                  onPressed: isRefreshing ? null : viewModel.refresh,
                ),
              ],
            ),
          final ProducerPlanContent content => _Content(content: content),
        },
        if (onCooperativeCode != null) ...[
          const SizedBox(height: Spacing.lg),
          VioraTextButton(label: l10n.producerPlanCooperative, onPressed: onCooperativeCode),
        ],
      ],
    );
  }
}

String _failureText(AppLocalizations l10n, PlanCatalogFailure failure) => switch (failure) {
      PlanCatalogOffline() => l10n.licenseErrorOffline,
      PlanCatalogUnexpected() => l10n.licenseErrorGeneric,
    };

class _Message extends StatelessWidget {
  const _Message(this.text, {this.isError = false});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      child: Semantics(
        liveRegion: true,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isError ? VioraColors.terracotta600 : VioraColors.neutral700,
              ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.content});

  final ProducerPlanContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final viewModel = context.read<ProducerPlanViewModel>();
    final offer = content.selectedOffer;
    final estimate = content.estimate;
    final capacity = formatPlanCapacity(content.capacity.hectares, locale);
    final step = formatPlanCapacity(content.step, locale);
    final eyebrow = theme.labelSmall?.copyWith(letterSpacing: 1.54, color: VioraColors.neutral600);
    final failure = content.failure;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.offers.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.md),
            child: Wrap(
              spacing: Spacing.xs,
              children: [
                for (final other in content.offers)
                  ChoiceChip(
                    label: Text(other.code.value),
                    selected: other.code == offer.code,
                    onSelected: (_) => viewModel.selectOffer(other.code.value),
                  ),
              ],
            ),
          ),
        const SizedBox(height: Spacing.lg),
        Text(l10n.producerPlanHectares, style: eyebrow),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: capacity,
                  children: const [
                    TextSpan(text: ' ha', style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
                key: const Key('producer-plan-capacity'),
                style: theme.displaySmall?.copyWith(color: VioraColors.neutral900),
              ),
            ),
            IconButton.outlined(
              tooltip: l10n.producerPlanDecrease(step),
              onPressed: content.canDecrease ? viewModel.decrease : null,
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: Spacing.xs),
            IconButton.filled(
              tooltip: l10n.producerPlanIncrease(step),
              style: IconButton.styleFrom(backgroundColor: VioraColors.green900),
              onPressed: viewModel.increase,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        const Divider(color: VioraColors.neutral200, height: 1),
        const SizedBox(height: Spacing.lg),
        Text(l10n.producerPlanIncludes, style: eyebrow),
        const SizedBox(height: Spacing.xs),
        for (final benefit in [
          l10n.producerPlanBenefitBbi,
          l10n.producerPlanBenefitClimate,
          l10n.producerPlanBenefitSampling,
          l10n.producerPlanBenefitCapacity(capacity),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
            child: Row(
              children: [
                const SizedBox(
                  width: Spacing.md,
                  child: Divider(color: VioraColors.neutral700, height: 1),
                ),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: Text(
                    benefit,
                    style: theme.bodyLarge?.copyWith(color: VioraColors.neutral700),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: Spacing.md),
        const Divider(color: VioraColors.neutral200, height: 1),
        const SizedBox(height: Spacing.lg),
        Text(l10n.producerPlanTotal, style: eyebrow),
        Text(
          formatMoney(estimate.total, offer.currency, locale),
          key: const Key('producer-plan-total'),
          style: theme.displaySmall?.copyWith(color: VioraColors.neutral900),
        ),
        Text(
          l10n.producerPlanTaxIncluded,
          style: theme.bodySmall?.copyWith(color: VioraColors.neutral700),
        ),
        Padding(
          padding: const EdgeInsets.only(top: Spacing.xs),
          child: Text(
            l10n.producerPlanMonthly(formatMoney(estimate.monthlyTotal, offer.currency, locale)),
            style: theme.bodySmall?.copyWith(color: VioraColors.neutral700),
          ),
        ),
        if (content.isSavedCopy && !content.isRefreshing) ...[
          const SizedBox(height: Spacing.lg),
          Text(
            l10n.producerPlanSavedCopy,
            style: theme.bodySmall?.copyWith(color: VioraColors.neutral600),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            l10n.producerPlanUpdated(
              DateFormat.yMd(locale).add_jm().format(content.fetchedAt.toLocal()),
            ),
            style: theme.bodySmall?.copyWith(color: VioraColors.neutral600),
          ),
        ],
        if (content.isRefreshing)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.md),
            child: Text(
              l10n.producerPlanLoading,
              style: theme.bodySmall?.copyWith(color: VioraColors.neutral600),
            ),
          ),
        if (failure != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: Spacing.xs),
            child: Text(
              _failureText(l10n, failure),
              style: theme.bodySmall?.copyWith(color: VioraColors.terracotta600),
            ),
          ),
          VioraTextButton(
            label: l10n.commonRetry,
            onPressed: content.isRefreshing ? null : viewModel.refresh,
          ),
        ],
      ],
    );
  }
}
