import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_section_header.dart';
import 'package:viora/core/designsystem/component/viora_status_tag.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/state/sector_detail_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/risk_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/sector_detail_view_model.dart';

/// G22 · Detalle del sector. The same reading serves what is near the manager and the plots
/// without a confirmed sector, so "Ver visitas por cercanía" lands on a real list of visits.
class SectorDetailPage extends StatelessWidget {
  const SectorDetailPage({super.key, required this.scope, required this.onBack, required this.onOpenPlot});

  static const path = 'sectors/:scope';

  final String scope;
  final VoidCallback onBack;
  final ValueChanged<String> onOpenPlot;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SectorDetailViewModel>()..load(scope),
      child: BlocBuilder<SectorDetailViewModel, SectorDetailUiState>(
        builder: (context, state) {
          final viewModel = context.read<SectorDetailViewModel>();
          return SectorDetailContent(
            state: state,
            onBack: onBack,
            onRetry: () => viewModel.load(scope),
            onToggleOrder: viewModel.toggleOrder,
            onToggleGroup: viewModel.toggleGroup,
            onOpenPlot: onOpenPlot,
          );
        },
      ),
    );
  }
}

/// Visual content of G22, without Bloc, so it can be tested with a fixed state.
class SectorDetailContent extends StatelessWidget {
  const SectorDetailContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onRetry,
    required this.onToggleOrder,
    required this.onToggleGroup,
    required this.onOpenPlot,
  });

  final SectorDetailUiState state;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final VoidCallback onToggleOrder;
  final ValueChanged<PlotRisk> onToggleGroup;
  final ValueChanged<String> onOpenPlot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failure = state.failure;
    final group = state.group;
    final priority = state.priority;
    final (title, subtitle) = _titles(l10n);
    final together = group.criticalWithinOneOuting;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.sm,
            Spacing.lg,
            VioraTabBarDefaults.fadeHeight + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            CooperativeTopBar(title: title, subtitle: subtitle, onBack: onBack),
            const SizedBox(height: Spacing.lg),
            if (failure != null)
              CooperativeFailureView(failure: failure, onRetry: onRetry)
            else if (state.loading)
              const Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
              )
            else if (group.total == 0)
              Padding(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Text(
                  l10n.riskScopeEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700),
                ),
              )
            else ...[
              _Hero(group: group),
              if (together.length >= 2) ...[
                const SizedBox(height: Spacing.md),
                VioraVoice(text: _togetherLine(l10n, together)),
              ],
              if (priority.isNotEmpty) ...[
                const SizedBox(height: Spacing.lg),
                VioraSectionHeader(
                  title: l10n.riskPriorityTitle,
                  count: priority.length,
                  actionLabel: state.canSortByDistance
                      ? (state.nearestFirst ? l10n.riskOrderPriority : l10n.riskOrderNearest)
                      : null,
                  onAction: state.canSortByDistance ? onToggleOrder : null,
                ),
                const SizedBox(height: Spacing.xs),
                for (var i = 0; i < priority.length; i++) ...[
                  _PriorityRow(position: i + 1, plot: priority[i], onTap: () => onOpenPlot(priority[i].id)),
                  const SizedBox(height: Spacing.xs),
                ],
              ],
              if (group.total > group.critical) ...[
                const SizedBox(height: Spacing.md),
                VioraSectionHeader(title: l10n.riskRestTitle, count: group.total - group.critical),
                const SizedBox(height: Spacing.xs),
                for (final risk in const [PlotRisk.moderate, PlotRisk.optimal, PlotRisk.noData])
                  if (group.count(risk) > 0) ...[
                    _RestGroup(
                      risk: risk,
                      plots: state.of(risk),
                      expanded: state.expanded.contains(risk),
                      onToggle: () => onToggleGroup(risk),
                      onOpenPlot: onOpenPlot,
                    ),
                    const SizedBox(height: Spacing.xs),
                  ],
              ],
            ],
          ],
        ),
      ),
    );
  }

  (String, String) _titles(AppLocalizations l10n) {
    final count = l10n.riskPlotCount(state.group.total);
    return switch (state.scope) {
      RiskScopes.nearby => (l10n.riskNearTitle, l10n.riskNearSubtitle(count)),
      RiskScopes.pending => (l10n.riskPendingTitle, count),
      RiskScopes.unassigned => (l10n.riskUnassignedTitle, count),
      _ => (state.title, state.loading ? '' : l10n.riskSectorSubtitle(count)),
    };
  }

  String _togetherLine(AppLocalizations l10n, List<RiskPlot> plots) => l10n.riskTogether(
        plots.first.producerName.split(' ').first,
        plots[1].producerName.split(' ').first,
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.group});

  final RiskGroup group;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final level = group.level;
    final critical = level == PlotRisk.critical;
    final (background, foreground) = switch (level) {
      PlotRisk.critical => (VioraColors.terracotta500, VioraColors.neutral0),
      PlotRisk.moderate => (VioraColors.harvest100, VioraColors.neutral900),
      PlotRisk.optimal => (VioraColors.green200, VioraColors.neutral900),
      PlotRisk.noData => (VioraColors.neutral0, VioraColors.neutral900),
    };
    final figure = group.count(level);
    final text = switch (level) {
      PlotRisk.critical => l10n.riskHeroCritical(group.total),
      PlotRisk.moderate => l10n.riskHeroModerate(group.total),
      PlotRisk.optimal => l10n.riskHeroOptimal(group.total),
      PlotRisk.noData => l10n.riskHeroNoData(group.total),
    };
    final colors = critical
        ? const [VioraColors.neutral900, VioraColors.harvest400, VioraColors.neutral0, Color(0xFFDD9E82)]
        : null;
    final frost = group.coldestFrost;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return VioraCard(
      color: background,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.riskHeroEyebrow(riskLevelLabel(l10n, level)).toUpperCase(),
            style: textTheme.labelSmall?.copyWith(color: foreground, letterSpacing: 1),
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$figure',
                style: TextStyle(fontFamily: VioraFonts.newsreader, fontStyle: FontStyle.italic, fontSize: 80, height: 1, color: foreground),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  text,
                  style: vioraNewsreaderItalic.copyWith(fontSize: 22, height: 1.2, color: foreground),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          RiskShareBar(group: group, colors: colors, height: 14),
          const SizedBox(height: Spacing.xs),
          Wrap(
            spacing: Spacing.sm,
            runSpacing: Spacing.xxs,
            children: [
              _Legend(color: (colors ?? _barColors)[0], label: l10n.riskLegend(riskLevelLabel(l10n, PlotRisk.critical), group.critical), foreground: foreground),
              _Legend(color: (colors ?? _barColors)[1], label: l10n.riskLegend(riskLevelLabel(l10n, PlotRisk.moderate), group.moderate), foreground: foreground),
              _Legend(color: (colors ?? _barColors)[2], label: l10n.riskLegend(riskLevelLabel(l10n, PlotRisk.optimal), group.optimal), foreground: foreground),
              _Legend(color: (colors ?? _barColors)[3], label: l10n.riskLegend(riskLevelLabel(l10n, PlotRisk.noData), group.noData), foreground: foreground),
            ],
          ),
          if (frost != null) ...[
            const SizedBox(height: Spacing.md),
            DecoratedBox(
              decoration: BoxDecoration(color: VioraColors.harvest100, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
                child: Row(
                  children: [
                    const VioraIcon(VioraIcons.acUnit, size: 22, color: VioraColors.neutral900),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.riskFrost, style: textTheme.titleSmall),
                          if (frost.value != null && frost.date != null)
                            Text(
                              l10n.riskFrostDetail(
                                formatOneDecimal(frost.value!, locale),
                                formatWeekdayDay(frost.date!, locale),
                              ),
                              style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral700),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

const _barColors = [VioraColors.terracotta500, VioraColors.harvest400, VioraColors.green700, VioraColors.neutral300];

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, required this.foreground});

  final Color color;
  final String label;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 8,
          child: DecoratedBox(decoration: ShapeDecoration(color: color, shape: const CircleBorder())),
        ),
        const SizedBox(width: Spacing.xxs),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: foreground)),
      ],
    );
  }
}

String _plotLine(AppLocalizations l10n, RiskPlot plot, String locale) {
  final distance = plot.distanceKm;
  final proposed = plot.proposedSectorName;
  return [
    plot.name,
    if (distance != null) l10n.riskDistance(formatOneDecimal(distance, locale)),
    if (proposed != null) l10n.riskProposedSector(proposed),
  ].join(' · ');
}

class _PriorityRow extends StatelessWidget {
  const _PriorityRow({required this.position, required this.plot, required this.onTap});

  final int position;
  final RiskPlot plot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final reason = plot.mainReason;
    final frostOnly = reason?.type == RiskReason.frostForecast;
    return VioraCard(
      padding: const EdgeInsets.fromLTRB(10, 10, Spacing.md, 10),
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: 44,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: frostOnly ? VioraColors.green900 : VioraColors.terracotta500,
                shape: const CircleBorder(),
              ),
              child: Center(
                child: Text(
                  '$position',
                  style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 22, color: VioraColors.neutral0),
                ),
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plot.producerName, style: textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  _plotLine(l10n, plot, locale),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                ),
                if (reason != null) ...[const SizedBox(height: Spacing.xxs), _ReasonTag(reason: reason)],
              ],
            ),
          ),
          const VioraIcon(VioraIcons.chevronRight, size: 22, color: VioraColors.neutral700),
        ],
      ),
    );
  }
}

class _ReasonTag extends StatelessWidget {
  const _ReasonTag({required this.reason});

  final PlotRiskReason reason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final value = reason.value;
    return switch (reason.type) {
      RiskReason.overload => VioraStatusTag(
          label: l10n.riskReasonOverload(formatOneDecimal(value ?? 0, locale)),
          tone: VioraTagTone.alert,
          iconAsset: VioraIcons.scale,
        ),
      RiskReason.frostForecast => VioraStatusTag(
          label: reason.date == null
              ? l10n.riskFrost
              : l10n.riskReasonFrost(formatOneDecimal(value ?? 0, locale), formatDayMonth(reason.date!, locale)),
          tone: VioraTagTone.info,
          iconAsset: VioraIcons.acUnit,
        ),
      RiskReason.criticalIncident => VioraStatusTag(
          label: l10n.riskCriticalIncident,
          tone: VioraTagTone.alert,
          iconAsset: VioraIcons.warning,
        ),
      _ => VioraStatusTag(label: l10n.riskModerate, tone: VioraTagTone.pending, iconAsset: VioraIcons.warning),
    };
  }
}

/// One color of "Resto del sector": its count, and its plots when opened.
class _RestGroup extends StatelessWidget {
  const _RestGroup({
    required this.risk,
    required this.plots,
    required this.expanded,
    required this.onToggle,
    required this.onOpenPlot,
  });

  final PlotRisk risk;
  final List<RiskPlot> plots;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onOpenPlot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final (title, subtitle) = switch (risk) {
      PlotRisk.moderate => (l10n.riskLevelModerate, l10n.riskRestModerate),
      PlotRisk.optimal => (l10n.riskOptimal, l10n.riskRestOptimal),
      _ => (l10n.riskNoData, l10n.riskRestNoData),
    };
    final icon = switch (risk) {
      PlotRisk.moderate => const _RestIcon(color: VioraColors.harvest100, asset: VioraIcons.scale),
      PlotRisk.optimal => const _RestIcon(color: VioraColors.green200, asset: VioraIcons.taskAlt),
      _ => const DashedCircle(size: 44, child: VioraIcon(VioraIcons.info, size: 22, color: VioraColors.neutral700)),
    };
    return VioraCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, Spacing.md, 10),
              child: Row(
                children: [
                  icon,
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: textTheme.titleSmall),
                        Text(subtitle, style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600)),
                      ],
                    ),
                  ),
                  Text(
                    '${plots.length}',
                    style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 24, color: VioraColors.neutral900),
                  ),
                  const SizedBox(width: Spacing.xs),
                  AnimatedRotation(
                    turns: expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const VioraIcon(VioraIcons.chevronRight, size: 22, color: VioraColors.neutral700),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            for (final plot in plots)
              InkWell(
                onTap: () => onOpenPlot(plot.id),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Spacing.md, 10, Spacing.md, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plot.producerName, style: textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(
                              _plotLine(l10n, plot, locale),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                            ),
                          ],
                        ),
                      ),
                      const VioraIcon(VioraIcons.chevronRight, size: 20, color: VioraColors.neutral600),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _RestIcon extends StatelessWidget {
  const _RestIcon({required this.color, required this.asset});

  final Color color;
  final String asset;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 44,
        child: DecoratedBox(
          decoration: ShapeDecoration(color: color, shape: const CircleBorder()),
          child: Center(child: VioraIcon(asset, size: 22, color: VioraColors.neutral900)),
        ),
      );
}
