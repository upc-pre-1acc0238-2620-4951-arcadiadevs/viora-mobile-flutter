import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_capsule_bar.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_section_header.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/state/intake_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/manager_home_sections.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/risk_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/intake_view_model.dart';

/// G30 · Acopio, the root of the intake tab: the tons the members should deliver in a campaign,
/// green and black, how much of it was sampled and how it splits by sector.
class IntakePage extends StatelessWidget {
  const IntakePage({super.key, required this.onOpenAlerts, required this.onOpenMembers});

  final VoidCallback onOpenAlerts;

  /// «Ver socios sin muestreo» of G30 · Sin datos para proyectar.
  final VoidCallback onOpenMembers;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<IntakeViewModel>()..load(),
      child: BlocBuilder<IntakeViewModel, IntakeUiState>(
        builder: (context, state) {
          final viewModel = context.read<IntakeViewModel>();
          return IntakePageContent(
            state: state,
            onRetry: viewModel.load,
            onRefresh: viewModel.load,
            onChooseCampaign: () async {
              final year = await showCampaignSheet(context, state.campaigns, state.selectedYear);
              if (year != null) await viewModel.selectCampaign(year);
            },
            onOpenAlerts: onOpenAlerts,
            onOpenMembers: onOpenMembers,
          );
        },
      ),
    );
  }
}

/// Visual content of G30, without Bloc, so it can be tested with a fixed state.
class IntakePageContent extends StatelessWidget {
  const IntakePageContent({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onRefresh,
    required this.onChooseCampaign,
    required this.onOpenAlerts,
    required this.onOpenMembers,
    this.now,
  });

  final IntakeUiState state;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final VoidCallback onChooseCampaign;
  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenMembers;

  /// The clock for «hoy» in the offline pill; the phone's by default.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final forecast = state.forecast;
    final failure = state.failure;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: VioraColors.green800,
          onRefresh: onRefresh,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.xs,
              Spacing.lg,
              VioraTabBarDefaults.contentBottomPadding + MediaQuery.paddingOf(context).bottom,
            ),
            children: [
              Row(
                children: [
                  if (state.selectedYear != null)
                    _CampaignSelector(year: state.selectedYear!, onTap: onChooseCampaign),
                  const Spacer(),
                  VioraCircleButton(
                    iconAsset: VioraIcons.notifications,
                    label: l10n.homeAlerts,
                    showBadge: state.hasActiveAlerts,
                    onPressed: onOpenAlerts,
                  ),
                ],
              ),
              const SizedBox(height: Spacing.lg),
              if (forecast != null)
                ..._forecast(context, forecast)
              else if (failure != null)
                CooperativeFailureView(failure: failure, onRetry: onRetry)
              else
                const Padding(
                  padding: EdgeInsets.all(Spacing.xl),
                  child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _forecast(BuildContext context, IntakeForecast forecast) {
    final l10n = AppLocalizations.of(context);
    final settled = forecast.kind == IntakeKind.settled;
    final offline = _offline(context, forecast);
    if (!forecast.hasFigure) {
      return [
        VioraEditorialTitle(l10n.intakeHeadlineNoData, fontSize: 44, lineHeight: 46),
        if (offline != null) ...[const SizedBox(height: 20), offline],
        const SizedBox(height: 20),
        _NoDataCard(forecast: forecast),
        if (!settled) ...[
          const SizedBox(height: Spacing.md),
          CooperativeActionPill(
            label: l10n.intakeMembersWithoutSampling,
            iconAsset: VioraIcons.arrowForward,
            onPressed: onOpenMembers,
          ),
        ],
      ];
    }
    final sectors = forecast.sectors;
    return [
      VioraEditorialTitle(
        settled ? l10n.intakeHeadlineSettled : l10n.intakeHeadlineProjected,
        fontSize: 44,
        lineHeight: 46,
      ),
      // Without a connection the pill takes the place of the voice, as G30 · Sin conexión does.
      if (offline != null) ...[const SizedBox(height: 20), offline] else ...[
        const SizedBox(height: 14),
        VioraVoice(text: _voice(l10n, forecast)),
      ],
      const SizedBox(height: Spacing.md),
      _TotalCard(forecast: forecast),
      const SizedBox(height: 28),
      _CoverageCard(forecast: forecast),
      if (sectors.isNotEmpty) ...[
        const SizedBox(height: 38),
        VioraSectionHeader(title: l10n.intakeBySector, count: sectors.length),
        const SizedBox(height: Spacing.xs),
        _SectorsCard(forecast: forecast),
      ],
    ];
  }

  /// «Sin conexión · proyección del 26 sep, 18:10», only while the campaign on screen was kept.
  Widget? _offline(BuildContext context, IntakeForecast forecast) {
    final savedAt = state.savedAt;
    if (savedAt == null) return null;
    final l10n = AppLocalizations.of(context);
    final what = forecast.kind == IntakeKind.settled ? l10n.offlineWhatIntake : l10n.offlineWhatProjection;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Align(
      alignment: Alignment.centerLeft,
      child: OfflinePill(text: formatOffline(l10n, what, savedAt, now ?? DateTime.now(), locale)),
    );
  }

  String _voice(AppLocalizations l10n, IntakeForecast forecast) {
    if (forecast.kind == IntakeKind.settled) return l10n.intakeVoiceSettled;
    if (forecast.status == IntakeStatus.preliminary) {
      return l10n.intakeVoicePreliminary(forecast.coveragePercent.round());
    }
    final missing = forecast.plots - forecast.sampledPlots;
    return missing > 0 ? l10n.intakeVoiceSufficient(missing) : l10n.intakeVoiceAllSampled;
  }
}

/// «Campaña 2026 ▾»: opens «Elige la campaña».
class _CampaignSelector extends StatelessWidget {
  const _CampaignSelector({required this.year, required this.onTap});

  final int year;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: '${l10n.intakeCampaign('$year')}, ${l10n.intakeChooseCampaign}',
      excludeSemantics: true,
      child: Material(
        color: VioraColors.neutral0,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: Spacing.minTouchTarget,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.md, 0, 10, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const VioraIcon(VioraIcons.calendarMonth, size: 18, color: VioraColors.neutral900),
                  const SizedBox(width: 6),
                  Text(
                    l10n.intakeCampaign('$year'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(letterSpacing: 0, color: VioraColors.neutral900),
                  ),
                  const SizedBox(width: 6),
                  const VioraIcon(VioraIcons.arrowDropDown, size: 24, color: VioraColors.neutral900),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle? _eyebrowStyle(BuildContext context, Color color) =>
    Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11, height: 16 / 11, letterSpacing: 0.88, color: color);

int _share(double part, double total) => total <= 0 ? 0 : (part / total * 100).round();

/// The yellow card: the tons, how much can be trusted, and the share of green and black.
class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.forecast});

  final IntakeForecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final settled = forecast.kind == IntakeKind.settled;
    final preliminary = forecast.status == IntakeStatus.preliminary;
    final total = forecast.totalTons ?? 0;
    final year = '${forecast.campaignYear}';
    final note = textTheme.bodySmall?.copyWith(letterSpacing: 0, height: 15 / 12, color: VioraColors.neutral700);
    return VioraCard(
      color: VioraColors.harvest100,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    settled ? l10n.intakeEyebrowSettled(year) : l10n.intakeEyebrowProjection(year),
                    style: _eyebrowStyle(context, VioraColors.harvest800),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              _StatusPill(status: forecast.status),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatTons(total, locale),
                  style: const TextStyle(
                    fontFamily: VioraFonts.newsreader,
                    fontSize: 88,
                    height: 84 / 88,
                    letterSpacing: -1.76,
                    color: VioraColors.neutral900,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.intakeTonsUnit,
                  style: vioraNewsreaderItalic.copyWith(fontSize: 24, height: 30 / 24, color: VioraColors.neutral900),
                ),
              ],
            ),
          ),
          if (preliminary) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const VioraIcon(VioraIcons.info, size: 16, color: VioraColors.terracotta700),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.intakeUncertainty(forecast.sampledPlots, forecast.plots),
                    style: textTheme.labelMedium?.copyWith(fontSize: 12, letterSpacing: 0, color: VioraColors.terracotta700),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          // A preliminary figure greys its split, as the design does: it is not firm enough to read.
          Opacity(
            opacity: preliminary ? 0.45 : 1,
            child: VioraSegmentedBar(
              height: 22,
              segments: [
                VioraBarSegment(value: forecast.greenTons, color: VioraColors.green800),
                VioraBarSegment(value: forecast.blackTons, color: VioraColors.neutral900),
                VioraBarSegment(value: forecast.unclassifiedTons, color: VioraColors.neutral500),
              ],
            ),
          ),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ShareTile(
                    dotColor: VioraColors.green700,
                    tons: forecast.greenTons,
                    percent: _share(forecast.greenTons, total),
                    label: settled ? l10n.intakeGreenSettled : l10n.intakeGreenHistory,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: _ShareTile(
                    dotColor: VioraColors.neutral900,
                    tons: forecast.blackTons,
                    percent: _share(forecast.blackTons, total),
                    label: settled ? l10n.intakeBlackSettled : l10n.intakeBlackHistory,
                  ),
                ),
              ],
            ),
          ),
          if (forecast.unclassifiedTons > 0) ...[
            const SizedBox(height: 14),
            Text(
              l10n.intakeUnclassified(
                formatTons(forecast.unclassifiedTons, locale),
                _share(forecast.unclassifiedTons, total),
              ),
              style: note,
            ),
          ],
        ],
      ),
    );
  }
}

/// «Cobertura suficiente», «Preliminar», «Cerrada» or «Parcial».
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final IntakeStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preliminary = status == IntakeStatus.preliminary;
    final (label, icon) = switch (status) {
      IntakeStatus.preliminary => (l10n.intakeTagPreliminary, VioraIcons.warning),
      IntakeStatus.closed => (l10n.intakeTagClosed, VioraIcons.check),
      IntakeStatus.partial => (l10n.intakeTagPartial, VioraIcons.schedule),
      _ => (l10n.intakeTagSufficient, VioraIcons.check),
    };
    final foreground = preliminary ? VioraColors.neutral0 : VioraColors.green900;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: preliminary ? VioraColors.terracotta500 : VioraColors.neutral0,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VioraIcon(icon, size: 14, color: preliminary ? foreground : VioraColors.green800),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 11,
                    height: 14 / 11,
                    letterSpacing: 0,
                    color: foreground,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// «● 700 t 56 %» over «Verde · según historial».
class _ShareTile extends StatelessWidget {
  const _ShareTile({required this.dotColor, required this.tons, required this.percent, required this.label});

  final Color dotColor;
  final double tons;
  final int percent;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(color: VioraColors.neutral0, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox.square(
                  dimension: 10,
                  child: DecoratedBox(decoration: ShapeDecoration(color: dotColor, shape: const CircleBorder())),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.homeTons(formatTons(tons, locale)),
                      style: const TextStyle(
                        fontFamily: VioraFonts.newsreader,
                        fontSize: 26,
                        height: 30 / 26,
                        color: VioraColors.neutral900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.intakePercent(percent),
                  style: textTheme.labelMedium?.copyWith(fontSize: 12, letterSpacing: 0, color: VioraColors.neutral600),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(label, style: textTheme.bodySmall?.copyWith(letterSpacing: 0, height: 15 / 12, color: VioraColors.neutral700)),
          ],
        ),
      ),
    );
  }
}

/// «Cobertura de muestreo»: how many plots were sampled against the preliminary threshold, or
/// for a past campaign how many settled their harvest.
class _CoverageCard extends StatelessWidget {
  const _CoverageCard({required this.forecast});

  final IntakeForecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final settled = forecast.kind == IntakeKind.settled;
    final preliminary = forecast.status == IntakeStatus.preliminary;
    final threshold = forecast.preliminaryThresholdPercent.round();
    final accent = preliminary ? VioraColors.terracotta700 : VioraColors.green900;
    final String body;
    if (settled) {
      body = l10n.intakeCoverageSettled(forecast.sampledPlots, forecast.plots, '${forecast.campaignYear}');
    } else if (preliminary) {
      body = '${l10n.intakeCoveragePreliminary(forecast.estimablePlots, forecast.plots, threshold)} '
          '${l10n.intakeMissingPlots(forecast.plotsToThreshold)}';
    } else {
      body = l10n.intakeCoverageSufficient(forecast.estimablePlots, forecast.plots, threshold);
    }
    return VioraCard(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settled ? l10n.intakeSettledCoverageLabel : l10n.intakeCoverageLabel,
                      style: _eyebrowStyle(context, VioraColors.neutral600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.intakeCoveragePlots(forecast.sampledPlots, forecast.plots),
                      style: const TextStyle(
                        fontFamily: VioraFonts.newsreader,
                        fontSize: 26,
                        height: 30 / 26,
                        color: VioraColors.neutral900,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                l10n.intakePercent(forecast.coveragePercent.round()),
                style: TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 34, height: 38 / 34, color: accent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _CoverageBar(
            percent: forecast.coveragePercent,
            color: preliminary ? VioraColors.terracotta500 : VioraColors.green800,
            threshold: settled ? null : forecast.preliminaryThresholdPercent,
          ),
          if (!settled) ...[
            const SizedBox(height: 6),
            Align(
              // The label sits under the mark, centered on it.
              alignment: Alignment(forecast.preliminaryThresholdPercent / 50 - 1, 0),
              child: Text(
                l10n.intakeThreshold(threshold),
                style: textTheme.bodySmall?.copyWith(letterSpacing: 0, fontSize: 11, height: 14 / 11, color: VioraColors.neutral600),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(body, style: textTheme.bodySmall?.copyWith(letterSpacing: 0, fontSize: 13, height: 18 / 13, color: VioraColors.neutral700)),
        ],
      ),
    );
  }
}

/// The 12-tall track with its fill and, for a projection, the mark of the threshold.
class _CoverageBar extends StatelessWidget {
  const _CoverageBar({required this.percent, required this.color, this.threshold});

  final double percent;
  final Color color;
  final double? threshold;

  @override
  Widget build(BuildContext context) {
    final threshold = this.threshold;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: 12,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: VioraColors.neutral100,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: width * (percent.clamp(0, 100) / 100),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(6))),
                ),
              ),
              if (threshold != null)
                Positioned(
                  left: width * threshold / 100 - 1,
                  top: -4,
                  width: 2,
                  height: 20,
                  child: const ColoredBox(color: VioraColors.neutral900),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// «Por sector»: the tons of each sector, its bar against the biggest one, and the plots
/// «Por confirmar» or without a sector at the end.
class _SectorsCard extends StatelessWidget {
  const _SectorsCard({required this.forecast});

  final IntakeForecast forecast;

  @override
  Widget build(BuildContext context) {
    final sectors = forecast.sectors;
    final biggest = sectors.fold<double>(0, (max, sector) => (sector.tons ?? 0) > max ? sector.tons! : max);
    return VioraCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < sectors.length; i++)
            _SectorRow(
              sector: sectors[i],
              first: i == 0,
              last: i == sectors.length - 1,
              share: biggest <= 0 ? 0 : (sectors[i].tons ?? 0) / biggest,
              settled: forecast.kind == IntakeKind.settled,
            ),
        ],
      ),
    );
  }
}

class _SectorRow extends StatelessWidget {
  const _SectorRow({
    required this.sector,
    required this.first,
    required this.last,
    required this.share,
    required this.settled,
  });

  final SectorIntake sector;
  final bool first;
  final bool last;

  /// Its tons against the biggest sector, from 0 to 1.
  final double share;
  final bool settled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final tons = sector.tons;
    final name = switch (sector.placement) {
      SectorPlacement.pending => l10n.riskPendingTitle,
      SectorPlacement.none => l10n.riskUnassignedTitle,
      SectorPlacement.assigned => sector.sectorName ?? l10n.riskUnassignedTitle,
    };
    final sampled = sector.sampledPlots;
    final plots = sector.plots;
    // The design spells the counts out once, on the first row, as a legend for the rest.
    final detail = sector.placement == SectorPlacement.pending
        ? l10n.intakeSectorPending(sampled, plots)
        : tons == null
            ? l10n.intakeSectorNoData(sampled, plots)
            : first
                ? (settled ? l10n.intakeSectorSettled(sampled, plots) : l10n.intakeSectorSampled(sampled, plots))
                : l10n.intakeOf(sampled, plots);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: last ? null : const Border(bottom: BorderSide(color: VioraColors.neutral200)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 14, 0, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(letterSpacing: 0, fontSize: 15, height: 20 / 15),
                      ),
                      const SizedBox(height: 1),
                      Text(detail, style: textTheme.bodySmall?.copyWith(letterSpacing: 0, height: 16 / 12, color: VioraColors.neutral600)),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  tons == null ? '—' : l10n.homeTons(formatTons(tons, locale)),
                  style: TextStyle(
                    fontFamily: VioraFonts.newsreader,
                    fontSize: 22,
                    height: 26 / 22,
                    color: tons == null ? VioraColors.neutral500 : VioraColors.neutral900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.xs),
            if (tons == null)
              const DashedPill(height: 8)
            else
              FractionallySizedBox(
                widthFactor: share.clamp(0.04, 1),
                child: sector.hasColors
                    ? VioraSegmentedBar(
                        height: 8,
                        gap: 3,
                        segments: [
                          VioraBarSegment(value: sector.greenTons ?? 0, color: VioraColors.green800),
                          VioraBarSegment(value: sector.blackTons ?? 0, color: VioraColors.neutral900),
                          VioraBarSegment(value: sector.unclassifiedTons ?? 0, color: VioraColors.neutral500),
                        ],
                      )
                    // Without the split, the sector is drawn as one green bar.
                    : const SizedBox(
                        height: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: VioraColors.green700,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

/// G30 · Sin datos para proyectar: no figure without sampling, and never a zero.
class _NoDataCard extends StatelessWidget {
  const _NoDataCard({required this.forecast});

  final IntakeForecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final year = '${forecast.campaignYear}';
    final settled = forecast.kind == IntakeKind.settled;
    final body = settled
        ? l10n.intakeSettledNoDataBody(year)
        : forecast.sampledPlots > 0
            ? l10n.intakeNoEstimableBody(year)
            : l10n.intakeNoDataBody(year);
    return VioraCard(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashedCircle(
            size: 64,
            child: VioraIcon(VioraIcons.inventory2, size: 28, color: VioraColors.neutral700),
          ),
          const SizedBox(height: 14),
          Text(
            settled ? l10n.intakeSettledNoDataTitle : l10n.intakeNoDataTitle,
            style: const TextStyle(
              fontFamily: VioraFonts.newsreader,
              fontSize: 30,
              height: 34 / 30,
              color: VioraColors.neutral900,
            ),
          ),
          const SizedBox(height: 14),
          Text(body, style: textTheme.bodyMedium?.copyWith(letterSpacing: 0, fontSize: 14, height: 20 / 14, color: VioraColors.neutral700)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  settled ? l10n.intakeSettledCoverageLabel : l10n.intakeCoverageLabel,
                  style: _eyebrowStyle(context, VioraColors.neutral600),
                ),
              ),
              Text(
                l10n.intakeOf(forecast.sampledPlots, forecast.plots),
                style: textTheme.labelMedium?.copyWith(fontSize: 12, letterSpacing: 0, color: VioraColors.neutral900),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          _CoverageBar(percent: forecast.coveragePercent, color: VioraColors.green800),
        ],
      ),
    );
  }
}

/// G30 · Elige la campaña: the campaign in progress with its projection, and the past ones with
/// the intake their members settled. Answers the chosen year, or null if the sheet is closed.
Future<int?> showCampaignSheet(BuildContext context, List<IntakeForecast> campaigns, int? selectedYear) {
  return showModalBottomSheet<int>(
    context: context,
    // Over the floating tab bar, as in the design.
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: VioraColors.neutral100,
    barrierColor: VioraColors.neutral900.withValues(alpha: 0.32),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
    builder: (context) => CampaignSheet(campaigns: campaigns, selectedYear: selectedYear),
  );
}

/// The content of «Elige la campaña»; touching a campaign chooses it and closes the sheet.
class CampaignSheet extends StatelessWidget {
  const CampaignSheet({super.key, required this.campaigns, required this.selectedYear});

  final List<IntakeForecast> campaigns;
  final int? selectedYear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VioraEditorialTitle(l10n.intakeSheetTitle, fontSize: 34, lineHeight: 38),
            const SizedBox(height: Spacing.md),
            Material(
              color: VioraColors.neutral0,
              borderRadius: BorderRadius.circular(24),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < campaigns.length; i++) ...[
                    if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16, color: VioraColors.neutral200),
                    _CampaignOption(
                      campaign: campaigns[i],
                      selected: campaigns[i].campaignYear == selectedYear,
                      onTap: () => Navigator.of(context).pop(campaigns[i].campaignYear),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              l10n.intakeSheetNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 0, 
                    fontSize: 13,
                    height: 18 / 13,
                    color: VioraColors.neutral600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignOption extends StatelessWidget {
  const _CampaignOption({required this.campaign, required this.selected, required this.onTap});

  final IntakeForecast campaign;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final total = campaign.totalTons;
    final tons = total == null ? '' : formatTons(total, locale);
    final detail = campaign.kind == IntakeKind.projection
        ? (total == null ? l10n.intakeSheetInProgressNoData : l10n.intakeSheetInProgress(tons))
        : total == null
            ? l10n.intakeSheetSettledNoData
            : campaign.status == IntakeStatus.partial
                ? l10n.intakeSheetPartial(tons)
                : l10n.intakeSheetClosed(tons);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Spacing.md, 14, Spacing.md, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.intakeCampaign('${campaign.campaignYear}'),
                      style: textTheme.titleMedium?.copyWith(letterSpacing: 0, fontSize: 15, height: 20 / 15),
                    ),
                    const SizedBox(height: 1),
                    Text(detail, style: textTheme.bodySmall?.copyWith(letterSpacing: 0, height: 16 / 12, color: VioraColors.neutral600)),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              if (selected)
                const SizedBox.square(
                  dimension: 28,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(color: VioraColors.green800, shape: CircleBorder()),
                    child: Center(child: VioraIcon(VioraIcons.check, size: 18, color: VioraColors.neutral0)),
                  ),
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: VioraColors.neutral300, width: 2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
