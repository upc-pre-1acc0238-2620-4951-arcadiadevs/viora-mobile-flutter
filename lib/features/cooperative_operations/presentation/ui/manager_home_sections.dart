import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:viora/core/designsystem/component/viora_arrow_button.dart';
import 'package:viora/core/designsystem/component/viora_capsule_bar.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_section_header.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/presentation/state/manager_home_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/risk_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/manager_home_view_model.dart';

/// Gives the Home of the manager (G10) its ViewModel, and reads again when the app comes back
/// to the front. [builder] gets the reload for the pull to refresh.
class ManagerHomeScope extends StatefulWidget {
  const ManagerHomeScope({super.key, required this.builder});

  final Widget Function(BuildContext context, Future<void> Function() refresh) builder;

  @override
  State<ManagerHomeScope> createState() => _ManagerHomeScopeState();
}

class _ManagerHomeScopeState extends State<ManagerHomeScope> with WidgetsBindingObserver {
  late final ManagerHomeViewModel _viewModel = getIt<ManagerHomeViewModel>()..load();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _viewModel.load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _viewModel,
        child: Builder(builder: (context) => widget.builder(context, _viewModel.load)),
      );
}

/// The line in the voice of Viora under «Tu valle, hoy.»: where the manager is needed most.
class ManagerHomeVoice extends StatelessWidget {
  const ManagerHomeVoice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerHomeViewModel, ManagerHomeUiState>(
      builder: (context, state) {
        final territory = state.territory;
        if (territory == null) return const SizedBox.shrink();
        return VioraVoice(text: managerHomeVoiceLine(AppLocalizations.of(context), territory));
      },
    );
  }
}

/// The most urgent sector and why; frost when nothing is red; calm when all is well.
String managerHomeVoiceLine(AppLocalizations l10n, RiskTerritory territory) {
  final valley = territory.valley;
  if (valley.total == 0) return l10n.homeVoiceNoPlots;
  final sectors = territory.sectorsByUrgency;
  final top = sectors.isEmpty ? null : sectors.first;
  if (top != null && top.group.level == PlotRisk.critical) {
    final overloaded = top.group.overloaded;
    return overloaded > 0
        ? l10n.homeVoiceOverload(top.name, overloaded)
        : l10n.homeVoiceCritical(top.name, top.group.critical);
  }
  if (valley.critical > 0) return l10n.homeVoiceCriticalValley(valley.critical);
  if (valley.withFrost > 0) return l10n.homeVoiceFrost(valley.withFrost);
  return l10n.homeVoiceCalm;
}

/// G10 · Inicio under the headline: the traffic light of the valley, «Tu licencia» and
/// «Visitas sugeridas».
class ManagerHomeSummary extends StatelessWidget {
  const ManagerHomeSummary({
    super.key,
    required this.onOpenRisk,
    required this.onOpenIntake,
    required this.onOpenAlerts,
    required this.onOpenMembers,
    required this.onOpenVisits,
    required this.onOpenPlot,
  });

  final VoidCallback onOpenRisk;
  final VoidCallback onOpenIntake;
  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenMembers;
  final VoidCallback onOpenVisits;
  final ValueChanged<String> onOpenPlot;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerHomeViewModel, ManagerHomeUiState>(
      builder: (context, state) => ManagerHomeSummaryContent(
        state: state,
        onRetry: context.read<ManagerHomeViewModel>().load,
        onOpenRisk: onOpenRisk,
        onOpenIntake: onOpenIntake,
        onOpenAlerts: onOpenAlerts,
        onOpenMembers: onOpenMembers,
        onOpenVisits: onOpenVisits,
        onOpenPlot: onOpenPlot,
      ),
    );
  }
}

/// The summary for a fixed [state], without the Bloc, so it can be tested.
class ManagerHomeSummaryContent extends StatelessWidget {
  const ManagerHomeSummaryContent({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onOpenRisk,
    required this.onOpenIntake,
    required this.onOpenAlerts,
    required this.onOpenMembers,
    required this.onOpenVisits,
    required this.onOpenPlot,
  });

  final ManagerHomeUiState state;
  final VoidCallback onRetry;
  final VoidCallback onOpenRisk;
  final VoidCallback onOpenIntake;
  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenMembers;
  final VoidCallback onOpenVisits;
  final ValueChanged<String> onOpenPlot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final territory = state.territory;
    final failure = state.failure;
    if (territory == null) {
      if (failure != null) return CooperativeFailureView(failure: failure, onRetry: onRetry);
      return const Padding(
        padding: EdgeInsets.all(Spacing.xl),
        child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
      );
    }
    final visits = territory.visits.plots;
    final shown = visits.take(homeVisitsShown).toList();
    final intake = state.intake;
    final campaignYear = intake?.campaignYear ?? state.capacity?.startsAt.toLocal().year;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ValleyCard(valley: territory.valley, onOpenRisk: onOpenRisk),
        const SizedBox(height: 28),
        VioraSectionHeader(
          title: l10n.homeLicenseTitle,
          actionLabel: campaignYear == null ? null : l10n.homeCampaign('$campaignYear'),
          onAction: onOpenIntake,
        ),
        const SizedBox(height: 14),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _IntakeCard(intake: intake, onTap: onOpenIntake)),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _FrostCard(alerts: state.frostAlerts, onTap: onOpenAlerts)),
                    const SizedBox(height: Spacing.sm),
                    Expanded(child: _SeatsCard(capacity: state.capacity, onTap: onOpenMembers)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        VioraSectionHeader(
          title: l10n.homeVisitsTitle,
          count: visits.isEmpty ? null : visits.length,
          actionLabel: visits.isEmpty ? null : l10n.homeVisitsSeeAll,
          onAction: onOpenVisits,
        ),
        const SizedBox(height: 14),
        if (shown.isEmpty)
          Text(
            l10n.homeVisitsNone,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700),
          )
        else
          for (var i = 0; i < shown.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            RiskVisitRow(
              position: i + 1,
              plot: shown[i],
              subtitle: _visitLine(l10n, shown[i]),
              onTap: () => onOpenPlot(shown[i].id),
            ),
          ],
      ],
    );
  }

  /// «La Yarada 02 · La Yarada Baja»: the plot and its sector, the one written if unconfirmed.
  static String _visitLine(AppLocalizations l10n, RiskPlot plot) {
    final sector = switch (plot.placement) {
      SectorPlacement.assigned => plot.sectorName,
      SectorPlacement.pending => plot.proposedSectorName == null ? null : l10n.riskProposedSector(plot.proposedSectorName!),
      SectorPlacement.none => l10n.riskUnassignedTitle,
    };
    return [plot.name, if (sector != null && sector.isNotEmpty) sector].join(' · ');
  }
}

/// "1 240": whole tons grouped by a thin space, as the design writes them in both languages.
String formatTons(double tons, String locale) {
  final format = NumberFormat('#,##0', locale);
  return format.format(tons.round()).replaceAll(format.symbols.GROUP_SEP, ' ');
}

const _onDark = VioraColors.neutral50;

/// «Semáforo del valle»: how many plots are critical, the share of each color and the way
/// into the map, over a schematic valley.
class _ValleyCard extends StatelessWidget {
  const _ValleyCard({required this.valley, required this.onOpenRisk});

  final RiskGroup valley;
  final VoidCallback onOpenRisk;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: ColoredBox(
        color: VioraColors.green900,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: ExcludeSemantics(
                child: SvgPicture.asset(
                  'assets/images/ill_valley_map.svg',
                  width: 174,
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeValleyEyebrow(valley.total).toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 11,
                      letterSpacing: 1.54,
                      color: _onDark.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${valley.critical}',
                        style: const TextStyle(
                          fontFamily: VioraFonts.newsreader,
                          fontSize: 96,
                          height: 0.75,
                          letterSpacing: -2.9,
                          color: _onDark,
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        l10n.homeValleyCritical(valley.critical),
                        style: vioraNewsreaderItalic.copyWith(fontSize: 26, height: 28 / 26, color: _onDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  VioraSegmentedBar(
                    height: 18,
                    segments: [
                      VioraBarSegment(value: valley.critical, color: VioraColors.terracotta500),
                      VioraBarSegment(value: valley.moderate, color: VioraColors.harvest300),
                      VioraBarSegment(value: valley.optimal, color: VioraColors.green200),
                      VioraBarSegment(value: valley.noData, color: _onDark.withValues(alpha: 0.22)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.xs,
                    children: [
                      _Legend(color: VioraColors.terracotta500, text: '${riskLevelLabel(l10n, PlotRisk.critical)} ${valley.critical}'),
                      _Legend(color: VioraColors.harvest300, text: '${riskLevelLabel(l10n, PlotRisk.moderate)} ${valley.moderate}'),
                      _Legend(color: VioraColors.green200, text: '${riskLevelLabel(l10n, PlotRisk.optimal)} ${valley.optimal}'),
                      _Legend(
                        color: _onDark.withValues(alpha: 0.5),
                        text: '${riskLevelLabel(l10n, PlotRisk.noData)} ${valley.noData}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  VioraArrowButton(label: l10n.homeOpenRisk, onPressed: onOpenRisk),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 8,
          child: DecoratedBox(decoration: ShapeDecoration(color: color, shape: const CircleBorder())),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                letterSpacing: 0,
                color: _onDark.withValues(alpha: 0.85),
              ),
        ),
      ],
    );
  }
}

/// «Acopio»: the tons of the newest campaign, green and black, and how much was sampled.
class _IntakeCard extends StatelessWidget {
  const _IntakeCard({required this.intake, required this.onTap});

  final IntakeForecast? intake;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final small = textTheme.bodySmall?.copyWith(color: VioraColors.neutral700, height: 17 / 12);
    final intake = this.intake;
    final total = intake?.totalTons;
    return VioraCard(
      color: VioraColors.harvest100,
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.homeIntakeLabel, style: textTheme.labelMedium?.copyWith(color: VioraColors.harvest800)),
          const SizedBox(height: 26),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              total == null ? '—' : l10n.homeTons(formatTons(total, locale)),
              style: const TextStyle(
                fontFamily: VioraFonts.newsreader,
                fontSize: 40,
                height: 44 / 40,
                letterSpacing: -0.8,
                color: VioraColors.neutral900,
              ),
            ),
          ),
          Text(
            intake == null || total == null
                ? l10n.homeIntakeNoData
                : intake.kind == IntakeKind.settled
                    ? l10n.homeIntakeSettled
                    : l10n.homeIntakeProjected,
            style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral700),
          ),
          if (intake != null && total != null) ...[
            const SizedBox(height: 14),
            VioraSegmentedBar(
              height: 14,
              segments: [
                VioraBarSegment(value: intake.greenTons, color: VioraColors.green800),
                VioraBarSegment(value: intake.blackTons, color: VioraColors.neutral900),
                VioraBarSegment(value: intake.unclassifiedTons, color: VioraColors.neutral0),
              ],
            ),
            const SizedBox(height: Spacing.xs),
            Text(l10n.homeIntakeGreen(formatTons(intake.greenTons, locale)), style: small),
            Text(l10n.homeIntakeBlack(formatTons(intake.blackTons, locale)), style: small),
            if (intake.unclassifiedTons > 0)
              Text(l10n.homeIntakeUnclassified(formatTons(intake.unclassifiedTons, locale)), style: small),
          ],
          const Spacer(),
          if (intake != null) ...[
            const SizedBox(height: 14),
            DecoratedBox(
              decoration: const ShapeDecoration(color: VioraColors.neutral0, shape: StadiumBorder()),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox.square(
                      dimension: 7,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(color: VioraColors.green700, shape: CircleBorder()),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l10n.homeIntakeCoverage(intake.coveragePercent.round()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelMedium?.copyWith(letterSpacing: 0, color: VioraColors.neutral900),
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

/// The frost alerts of the license's sectors: «2 alertas de helada ≤ 1,5 °C en 48 h».
class _FrostCard extends StatelessWidget {
  const _FrostCard({required this.alerts, required this.onTap});

  final int? alerts;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alerts = this.alerts;
    return VioraCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  alerts == null ? '—' : '$alerts',
                  style: const TextStyle(
                    fontFamily: VioraFonts.newsreader,
                    fontSize: 48,
                    height: 50 / 48,
                    letterSpacing: -0.96,
                    color: VioraColors.neutral900,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: DecoratedBox(
                  decoration: ShapeDecoration(color: VioraColors.green200, shape: CircleBorder()),
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: VioraIcon(VioraIcons.acUnit, size: 24, color: VioraColors.green900),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.homeFrostAlerts(alerts ?? 0),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral700),
          ),
        ],
      ),
    );
  }
}

/// «48 / 60 plazas de la licencia»: the seats held by members and codes to redeem.
class _SeatsCard extends StatelessWidget {
  const _SeatsCard({required this.capacity, required this.onTap});

  final LicenseCapacity? capacity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final capacity = this.capacity;
    return VioraCard(
      color: VioraColors.green200,
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            capacity == null ? '—' : '${capacity.seatsUsed} / ${capacity.seats}',
            style: const TextStyle(
              fontFamily: VioraFonts.newsreader,
              fontSize: 34,
              height: 38 / 34,
              letterSpacing: -0.5,
              color: VioraColors.green900,
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            l10n.homeSeatsLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.green800),
          ),
          const Spacer(),
          const SizedBox(height: Spacing.sm),
          VioraProgressBar(
            value: capacity == null || capacity.seats == 0 ? 0 : capacity.seatsUsed / capacity.seats,
            color: VioraColors.green800,
          ),
        ],
      ),
    );
  }
}
