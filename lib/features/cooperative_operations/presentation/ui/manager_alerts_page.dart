import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viora/core/designsystem/component/viora_arrow_button.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/state/manager_alerts_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/risk_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/manager_alerts_view_model.dart';

/// T14 · Alertas del gestor (US31): what turned critical or is about to freeze in the license's
/// sectors, and what went back to normal in the last 7 days.
class ManagerAlertsPage extends StatelessWidget {
  const ManagerAlertsPage({
    super.key,
    required this.onBack,
    required this.onOpenPreferences,
    required this.onOpenSector,
  });

  static const path = 'alerts';

  final VoidCallback onBack;
  final VoidCallback onOpenPreferences;
  final ValueChanged<String> onOpenSector;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ManagerAlertsViewModel>()..load(),
      child: BlocBuilder<ManagerAlertsViewModel, ManagerAlertsUiState>(
        builder: (context, state) {
          final viewModel = context.read<ManagerAlertsViewModel>();
          return ManagerAlertsContent(
            state: state,
            now: DateTime.now(),
            onBack: onBack,
            onRetry: viewModel.load,
            onOpenPreferences: onOpenPreferences,
            onToggleFilter: viewModel.toggleFilter,
            onOpenSector: onOpenSector,
          );
        },
      ),
    );
  }
}

/// Visual content of T14, without Bloc, so it can be tested with a fixed state.
class ManagerAlertsContent extends StatelessWidget {
  const ManagerAlertsContent({
    super.key,
    required this.state,
    required this.now,
    required this.onBack,
    required this.onRetry,
    required this.onOpenPreferences,
    required this.onToggleFilter,
    required this.onOpenSector,
  });

  final ManagerAlertsUiState state;
  final DateTime now;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final VoidCallback onOpenPreferences;
  final ValueChanged<AlertFilter> onToggleFilter;
  final ValueChanged<String> onOpenSector;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failure = state.failure;
    final active = state.visibleActive;
    final normalized = state.visibleNormalized;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.xs,
            Spacing.lg,
            VioraTabBarDefaults.fadeHeight + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            CooperativeTopBar(
              title: l10n.homeAlerts,
              onBack: onBack,
              trailing: VioraCircleButton(
                iconAsset: VioraIcons.settings,
                label: l10n.alertsPreferences,
                onPressed: onOpenPreferences,
              ),
            ),
            if (failure != null)
              CooperativeFailureView(failure: failure, onRetry: onRetry)
            else if (state.loading)
              const Padding(
                padding: EdgeInsets.all(Spacing.xxl),
                child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
              )
            else ...[
              const SizedBox(height: Spacing.sm),
              _Hero(state: state),
              const SizedBox(height: Spacing.lg),
              _Summary(state: state, onToggle: onToggleFilter),
              for (final (day, alerts) in _byDay(active)) ...[
                const SizedBox(height: Spacing.xl),
                _Eyebrow(_dayLabel(l10n, day, now, Localizations.localeOf(context).toLanguageTag())),
                for (final alert in alerts) ...[
                  const SizedBox(height: Spacing.xs),
                  _AlertCard(alert: alert, now: now, onOpenSector: () => onOpenSector(alert.sectorId)),
                ],
              ],
              if (normalized.isNotEmpty) ...[
                const SizedBox(height: Spacing.xl),
                _Eyebrow(l10n.alertsNormalizedTitle),
                for (final alert in normalized) ...[
                  const SizedBox(height: Spacing.xs),
                  _NormalizedRow(alert: alert, now: now),
                ],
              ],
              if (state.filter != null && active.isEmpty && normalized.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Text(
                    l10n.alertsFilteredEmpty,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The alerts of each calendar day, keeping the order they come in.
List<(DateTime?, List<SectorAlert>)> _byDay(List<SectorAlert> alerts) {
  final days = <(DateTime?, List<SectorAlert>)>[];
  for (final alert in alerts) {
    final at = alert.changedAt?.toLocal();
    final day = at == null ? null : DateTime(at.year, at.month, at.day);
    if (days.isEmpty || days.last.$1 != day) days.add((day, []));
    days.last.$2.add(alert);
  }
  return days;
}

/// «Hoy», «Ayer» or the day: «22 sep».
String _dayLabel(AppLocalizations l10n, DateTime? day, DateTime now, String locale) {
  if (day == null) return '';
  return switch (daysUntil(day, now)) {
    0 => l10n.alertsToday,
    -1 => l10n.alertsYesterday,
    _ => formatDayMonth(day, locale),
  };
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: Spacing.xxs),
        child: Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: VioraColors.neutral600, letterSpacing: 1.32),
        ),
      );
}

/// «2 alertas activas · En La Yarada Baja y La Yarada Alta · actualizado 7:40 a. m.».
class _Hero extends StatelessWidget {
  const _Hero({required this.state});

  final ManagerAlertsUiState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final count = state.active.length;
    final readAt = state.readAt;
    final time = readAt == null ? '' : DateFormat.jm(l10n.localeName).format(readAt.toLocal());
    final sectors = state.activeSectors;
    final line = sectors.isEmpty
        ? l10n.alertsCalm(time)
        : l10n.alertsWhere(
            sectors.length == 1
                ? sectors.single
                : l10n.alertsSectorsJoin(sectors.sublist(0, sectors.length - 1).join(', '), sectors.last),
            time,
          );
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontFamily: VioraFonts.newsreader,
            fontSize: 112,
            height: 104 / 112,
            letterSpacing: -4.48,
            color: VioraColors.neutral900,
          ),
        ),
        Text(
          l10n.alertsActive(count),
          style: vioraNewsreaderItalic.copyWith(
            fontSize: 26,
            height: 30 / 26,
            letterSpacing: -0.26,
            color: VioraColors.neutral900,
          ),
        ),
        const SizedBox(height: Spacing.xxs + 2),
        Text(
          line,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(fontSize: 13, height: 18 / 13, letterSpacing: 0, color: VioraColors.neutral600),
        ),
      ],
    );
  }
}

/// The three capsules that count and filter: «Críticas», «Atención», «Normalizadas».
class _Summary extends StatelessWidget {
  const _Summary({required this.state, required this.onToggle});

  final ManagerAlertsUiState state;
  final ValueChanged<AlertFilter> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final counts = {
      AlertFilter.critical: state.critical,
      AlertFilter.attention: state.attention,
      AlertFilter.normalized: state.normalized.length,
    };
    final most = counts.values.fold(0, (a, b) => a > b ? a : b);
    return VioraCard(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      child: Row(
        children: [
          _Capsule(
            label: l10n.alertsFilterCritical,
            count: counts[AlertFilter.critical]!,
            most: most,
            fill: VioraColors.terracotta500,
            figure: VioraColors.neutral50,
            selected: state.filter == AlertFilter.critical,
            onTap: () => onToggle(AlertFilter.critical),
          ),
          _Capsule(
            label: l10n.alertsFilterAttention,
            count: counts[AlertFilter.attention]!,
            most: most,
            fill: VioraColors.harvest300,
            figure: VioraColors.neutral900,
            selected: state.filter == AlertFilter.attention,
            onTap: () => onToggle(AlertFilter.attention),
          ),
          _Capsule(
            label: l10n.alertsFilterNormalized,
            count: counts[AlertFilter.normalized]!,
            most: most,
            fill: VioraColors.green800,
            figure: VioraColors.neutral50,
            selected: state.filter == AlertFilter.normalized,
            onTap: () => onToggle(AlertFilter.normalized),
          ),
        ],
      ),
    );
  }
}

class _Capsule extends StatelessWidget {
  const _Capsule({
    required this.label,
    required this.count,
    required this.most,
    required this.fill,
    required this.figure,
    required this.selected,
    required this.onTap,
  });

  static const _width = 84.0;
  static const _track = 150.0;
  static const _least = 70.0;
  static const _full = 138.0;

  final String label;
  final int count;

  /// The largest of the three counts: its capsule fills up to [_full].
  final int most;
  final Color fill;
  final Color figure;
  final bool selected;
  final VoidCallback onTap;

  double get _height {
    if (count == 0) return 0;
    if (most <= 1) return _least;
    return _least + (_full - _least) * (count - 1) / (most - 1);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Each capsule takes a third; with large text the label shrinks instead of pushing the others.
    return Expanded(
      child: Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            SizedBox(
              width: _width,
              height: _track,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(_width / 2),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      height: _height,
                      decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(_width / 2)),
                    ),
                    Positioned(
                      bottom: 12,
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontFamily: VioraFonts.newsreader,
                          fontSize: 28,
                          height: 32 / 28,
                          color: count == 0 ? VioraColors.neutral900 : figure,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  height: 18 / 13,
                  letterSpacing: 0,
                  color: VioraColors.neutral900,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  fontVariations: [FontVariation.weight(selected ? 500 : 400)],
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

/// An active alert: «La Yarada Baja pasó a Crítico» or «Helada radiativa en La Yarada Alta».
class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert, required this.now, required this.onOpenSector});

  final SectorAlert alert;
  final DateTime now;
  final VoidCallback onOpenSector;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final frost = alert.type == SectorAlertType.frost;
    final critical = alert.severity == AlertSeverity.critical;
    final accent = frost ? VioraColors.harvest800 : VioraColors.terracotta700;
    final value = alert.leadValue;
    final date = alert.leadDate;
    final figure = frost ? (value == null ? null : '${formatOneDecimal(value, locale)}°') : '${alert.affectedPlots}';
    final when = frost && date != null ? _capitalized(formatWeekdayDay(date, locale)) : _ago(l10n, alert.changedAt, now);
    return VioraCard(
      color: frost ? VioraColors.harvest100 : VioraColors.terracotta100,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: 44,
                child: DecoratedBox(
                  decoration: const ShapeDecoration(color: VioraColors.neutral0, shape: CircleBorder()),
                  child: Center(child: VioraIcon(frost ? VioraIcons.acUnit : VioraIcons.locationOn, color: accent)),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              // With large text the chips go down a line instead of pushing the figure out.
              Expanded(
                child: Wrap(
                  spacing: Spacing.xs,
                  runSpacing: Spacing.xs,
                  children: [
                    _Chip(
                      label: critical ? l10n.alertsChipCritical : l10n.alertsChipAttention,
                      background: critical ? VioraColors.terracotta500 : VioraColors.harvest300,
                      foreground: critical ? VioraColors.neutral50 : VioraColors.neutral900,
                    ),
                    if (when.isNotEmpty)
                      _Chip(label: when, background: VioraColors.neutral0, foreground: VioraColors.neutral900),
                  ],
                ),
              ),
              if (figure != null)
                Text(
                  figure,
                  style: TextStyle(
                    fontFamily: VioraFonts.newsreader,
                    fontSize: 34,
                    height: 36 / 34,
                    letterSpacing: -0.68,
                    color: accent,
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            frost ? l10n.alertsFrostTitle(alert.sectorName) : l10n.alertsSectorCriticalTitle(alert.sectorName),
            style: const TextStyle(
              fontFamily: VioraFonts.newsreader,
              fontSize: 22,
              height: 28 / 22,
              letterSpacing: -0.22,
              color: VioraColors.neutral900,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            alertBody(l10n, alert, locale),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 0, color: VioraColors.neutral700),
          ),
          const SizedBox(height: Spacing.sm),
          VioraArrowButton(label: l10n.alertsOpenSector, onPressed: onOpenSector, dark: true),
        ],
      ),
    );
  }
}

/// What happened and what to do, from the plot that leads the alert. Without it (its owner
/// stopped sharing) only the sector's figures remain.
String alertBody(AppLocalizations l10n, SectorAlert alert, String locale) {
  final producer = alert.leadProducerName;
  final value = alert.leadValue;
  final date = alert.leadDate;
  if (alert.type == SectorAlertType.frost) {
    if (alert.leadReason == RiskReason.frostForecast && value != null && date != null) {
      return l10n.alertsFrostForecastBody(formatOneDecimal(value, locale), formatWeekdayDay(date, locale));
    }
    if (producer != null && alert.leadPlotName != null) return l10n.alertsFrostIncidentBody(producer, alert.leadPlotName!);
    return l10n.alertsFrostPlots(alert.affectedPlots);
  }
  final plots = l10n.alertsRedPlots(alert.affectedPlots);
  if (producer == null) return plots;
  if (alert.leadReason == RiskReason.overload && value != null) {
    return l10n.alertsOverloadBody(producer, formatOneDecimal(value, locale), plots);
  }
  return l10n.alertsIncidentBody(producer, plots);
}

/// «Hace 5 min», «Hace 3 h», or the day once it's older.
String _ago(AppLocalizations l10n, DateTime? at, DateTime now) {
  if (at == null) return '';
  final elapsed = now.difference(at);
  if (elapsed.inMinutes < 1) return l10n.alertsAgoNow;
  if (elapsed.inMinutes < 60) return l10n.alertsAgoMinutes(elapsed.inMinutes);
  if (elapsed.inHours < 24) return l10n.alertsAgoHours(elapsed.inHours);
  return formatDayMonth(at, l10n.localeName);
}

String _capitalized(String text) => text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.background, required this.foreground});

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: ShapeDecoration(color: background, shape: const StadiumBorder()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(letterSpacing: 0, color: foreground),
          ),
        ),
      );
}

/// «Magollo volvió a Moderado · Ayer», «Pasó la helada en Los Palos · 22 sep».
class _NormalizedRow extends StatelessWidget {
  const _NormalizedRow({required this.alert, required this.now});

  final SectorAlert alert;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final at = alert.changedAt;
    final level = alert.sectorLevelAfter;
    final text = alert.type == SectorAlertType.frost
        ? l10n.alertsFrostPassed(alert.sectorName)
        : level == null
            ? l10n.alertsNormalizedPlain(alert.sectorName)
            : l10n.alertsBackTo(alert.sectorName, riskLevelLabel(l10n, level));
    return Material(
      color: VioraColors.neutral0,
      shape: const StadiumBorder(),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Spacing.sm, 0, 18, 0),
          child: Row(
            children: [
              const SizedBox.square(
                dimension: 40,
                child: DecoratedBox(
                  decoration: ShapeDecoration(color: VioraColors.green100, shape: CircleBorder()),
                  child: Center(child: VioraIcon(VioraIcons.taskAlt, color: VioraColors.green800)),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(letterSpacing: 0),
                ),
              ),
              if (at != null) ...[
                const SizedBox(width: Spacing.sm),
                Text(
                  _capitalized(_dayLabel(l10n, at.toLocal(), now, l10n.localeName)),
                  style: textTheme.bodySmall?.copyWith(letterSpacing: 0, color: VioraColors.neutral600),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
