import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viora/core/designsystem/component/viora_capsule_bar.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/risk_map_features.dart';
import 'package:viora/features/cooperative_operations/presentation/state/risk_plot_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/risk_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/risk_plot_view_model.dart';

/// How many trees make a valid sampling.
const _validSampleTrees = 5;

/// G23 · Parcela del socio, read-only: load, prescription, thinning and the informative bearing
/// index, with a way to reach the member. Without a valid sampling, G23 · Sin datos suficientes.
class RiskPlotPage extends StatelessWidget {
  const RiskPlotPage({super.key, required this.plotId, required this.onBack, required this.onOpenDossier});

  static const path = 'plots/:plotId';

  final String plotId;
  final VoidCallback onBack;
  final VoidCallback onOpenDossier;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RiskPlotViewModel>()..load(plotId),
      child: BlocBuilder<RiskPlotViewModel, RiskPlotUiState>(
        builder: (context, state) => RiskPlotContent(
          state: state,
          now: DateTime.now(),
          onBack: onBack,
          onRetry: () => context.read<RiskPlotViewModel>().load(plotId),
          onOpenDossier: onOpenDossier,
          onCall: (phone) => launchUrl(Uri(scheme: 'tel', path: phone)),
          onWhatsapp: (phone) => launchUrl(
            Uri.https('wa.me', '/${phone.replaceAll(RegExp(r'[^0-9]'), '')}'),
            mode: LaunchMode.externalApplication,
          ),
        ),
      ),
    );
  }
}

/// Visual content of G23, without Bloc, so it can be tested with a fixed state.
class RiskPlotContent extends StatelessWidget {
  const RiskPlotContent({
    super.key,
    required this.state,
    required this.now,
    required this.onBack,
    required this.onRetry,
    required this.onOpenDossier,
    required this.onCall,
    required this.onWhatsapp,
  });

  final RiskPlotUiState state;
  final DateTime now;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final VoidCallback onOpenDossier;
  final ValueChanged<String> onCall;
  final ValueChanged<String> onWhatsapp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final plot = state.plot;
    final failure = state.failure;
    final phone = plot?.producerPhone;
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
            CooperativeTopBar(
              title: plot?.producerName ?? '',
              subtitle: plot == null ? '' : _subtitle(l10n, plot, locale),
              onBack: onBack,
            ),
            const SizedBox(height: Spacing.sm),
            if (failure != null)
              CooperativeFailureView(failure: failure, onRetry: onRetry)
            else if (plot == null)
              const Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
              )
            else ...[
              _ReadOnlyLine(evaluatedAt: plot.evaluatedAt, now: now),
              const SizedBox(height: Spacing.sm),
              if (plot.hasLoad) ...[
                _LoadCard(plot: plot, now: now),
                if ((plot.percentageToRemove ?? 0) > 0) ...[
                  const SizedBox(height: Spacing.sm),
                  _PrescriptionCard(plot: plot, now: now),
                ],
              ] else
                _NoDataCard(plot: plot),
              if (plot.bearingIndex != null) ...[
                const SizedBox(height: Spacing.sm),
                _BearingCard(index: plot.bearingIndex!),
              ],
              if (phone != null) ...[
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: ContactButton(
                        label: l10n.memberCall,
                        iconAsset: VioraIcons.smartphone,
                        color: VioraColors.neutral0,
                        onPressed: () => onCall(phone),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: ContactButton(
                        label: l10n.memberWhatsapp,
                        iconAsset: VioraIcons.chat,
                        color: VioraColors.green200,
                        onPressed: () => onWhatsapp(phone),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: Spacing.sm),
              CooperativeActionPill(
                label: l10n.riskDossierAction,
                iconAsset: VioraIcons.arrowForward,
                onPressed: onOpenDossier,
              ),
              if (!plot.hasLoad) ...[
                const SizedBox(height: Spacing.md),
                VioraVoice(text: l10n.riskNoDataVoice(plot.producerName.split(' ').first, _validSampleTrees)),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _subtitle(AppLocalizations l10n, RiskPlotDetail plot, String locale) => [
        plot.name,
        // The same words as the map's sheet: a sector to confirm is not the same as none.
        plot.sectorName ??
            (plot.placement == SectorPlacement.pending ? l10n.memberPlotSectorPending : l10n.riskUnassignedTitle),
        if (plot.areaHa != null) l10n.riskHectares(formatHectares(plot.areaHa!, locale)),
      ].join(' · ');
}

class _ReadOnlyLine extends StatelessWidget {
  const _ReadOnlyLine({required this.evaluatedAt, required this.now});

  final DateTime? evaluatedAt;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final at = evaluatedAt;
    return Row(
      children: [
        DecoratedBox(
          decoration: const ShapeDecoration(color: VioraColors.neutral0, shape: StadiumBorder()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const VioraIcon(VioraIcons.visibility, size: 16, color: VioraColors.neutral900),
                const SizedBox(width: 6),
                Text(l10n.riskReadOnly, style: textTheme.labelMedium),
              ],
            ),
          ),
        ),
        const SizedBox(width: Spacing.xs),
        if (at != null)
          Expanded(
            child: Text(
              l10n.riskReadAt(formatReadAt(l10n, at, now, locale)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
            ),
          ),
      ],
    );
  }
}

class _LoadCard extends StatelessWidget {
  const _LoadCard({required this.plot, required this.now});

  final RiskPlotDetail plot;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final fruits = plot.fruitsPerShoot!;
    final target = plot.targetFruitsPerShoot!;
    final longest = fruits > target ? fruits : target;
    final overload = plot.overloadPercent ?? 0;
    final tons = plot.kgPerHaAfterThinning;
    final frost = plot.frost;
    final hasIncident = plot.reasons.any((reason) => reason.type == RiskReason.criticalIncident && !reason.isFrost);
    final sampledOn = plot.lastSampledOn;
    return VioraCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.riskLoadTitle,
                  style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 28, color: VioraColors.neutral900),
                ),
              ),
              RiskLevelTag(risk: plot.risk),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.riskLoadUnit.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(color: VioraColors.neutral600, letterSpacing: 1),
          ),
          const SizedBox(height: Spacing.sm),
          _LoadBar(
            label: l10n.riskLoadEstimated,
            value: formatTwoDecimals(fruits, locale),
            share: fruits / longest,
            color: riskColor(plot.risk),
          ),
          const SizedBox(height: Spacing.sm),
          _LoadBar(
            label: l10n.riskLoadTarget,
            value: formatTwoDecimals(target, locale),
            share: target / longest,
            color: VioraColors.green800,
          ),
          if (tons != null) ...[
            const SizedBox(height: Spacing.sm),
            DecoratedBox(
              decoration: BoxDecoration(color: VioraColors.neutral100, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatOneDecimal(tons / 1000, locale),
                        style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 26, height: 1.1, color: VioraColors.neutral900),
                      ),
                      Text(l10n.riskTonsAfterThinning, style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral700)),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (overload > 30) ...[
            const SizedBox(height: Spacing.sm),
            _Notice(
              text: l10n.riskOverloadNotice(formatOneDecimal(overload, locale), now.year + 1),
              color: VioraColors.terracotta100,
              foreground: VioraColors.terracotta700,
              iconAsset: VioraIcons.warning,
            ),
          ],
          if (frost != null) ...[
            const SizedBox(height: Spacing.sm),
            _Notice(
              text: frost.value != null && frost.date != null
                  ? l10n.riskFrostDetail(formatOneDecimal(frost.value!, locale), formatWeekdayDay(frost.date!, locale))
                  : l10n.riskFrost,
              color: VioraColors.harvest100,
              foreground: VioraColors.neutral900,
              iconAsset: VioraIcons.acUnit,
            ),
          ],
          if (hasIncident) ...[
            const SizedBox(height: Spacing.sm),
            _Notice(
              text: l10n.riskCriticalIncident,
              color: VioraColors.terracotta100,
              foreground: VioraColors.terracotta700,
              iconAsset: VioraIcons.warning,
            ),
          ],
          if (sampledOn != null) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              l10n.riskSampleBasis(plot.sampledTrees, formatLongDayMonth(sampledOn, locale)),
              style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral700),
            ),
          ],
        ],
      ),
    );
  }
}

/// A capsule as long as its share of the longest value, over a soft track.
class _LoadBar extends StatelessWidget {
  const _LoadBar({required this.label, required this.value, required this.share, required this.color});

  /// Below this the label wouldn't fit inside the capsule.
  static const _minShare = 0.45;

  final String label;
  final String value;
  final double share;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final valueInside = share > 0.8;
    return DecoratedBox(
      decoration: const ShapeDecoration(color: VioraColors.neutral100, shape: StadiumBorder()),
      child: SizedBox(
        height: 48,
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: share.clamp(_minShare, 1.0),
              heightFactor: 1,
              child: DecoratedBox(decoration: ShapeDecoration(color: color, shape: const StadiumBorder())),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: VioraColors.neutral0),
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: VioraFonts.newsreader,
                      fontSize: 24,
                      color: valueInside ? VioraColors.neutral0 : VioraColors.neutral900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text, required this.color, required this.foreground, required this.iconAsset});

  final String text;
  final Color color;
  final Color foreground;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VioraIcon(iconAsset, size: 20, color: foreground),
            const SizedBox(width: Spacing.sm),
            Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: foreground))),
          ],
        ),
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({required this.plot, required this.now});

  final RiskPlotDetail plot;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final percent = plot.percentageToRemove!;
    final opens = plot.windowOpensOn;
    final closes = plot.windowClosesOn;
    final thinnedOn = plot.thinnedOn;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ColoredBox(
        color: VioraColors.green900,
        child: Stack(
          children: [
            const Positioned(
              top: -70,
              right: -50,
              child: SizedBox.square(
                dimension: 200,
                child: DecoratedBox(decoration: ShapeDecoration(color: VioraColors.green800, shape: CircleBorder())),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.riskPrescriptionEyebrow.toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(color: VioraColors.neutral200, letterSpacing: 1),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        flex: 3,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.riskPercent(formatOneDecimal(percent, locale)),
                            style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 72, height: 1.1, color: VioraColors.neutral50),
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      Flexible(
                        flex: 2,
                        child: Text(
                          l10n.riskPrescriptionUnit,
                          style: vioraNewsreaderItalic.copyWith(fontSize: 22, color: VioraColors.neutral50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    l10n.riskPrescriptionBody(plot.producerName.split(' ').first, (percent / 10).round()),
                    style: textTheme.bodyMedium?.copyWith(color: VioraColors.neutral200),
                  ),
                  if (opens != null && closes != null) ...[
                    const SizedBox(height: Spacing.md),
                    VioraProgressBar(
                      value: _elapsed(opens, closes),
                      color: VioraColors.harvest300,
                      trackColor: VioraColors.green700,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.riskWindowFrom(formatDayMonth(opens, locale)),
                            style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral200),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            l10n.riskWindowUntil(formatDayMonth(closes, locale)),
                            textAlign: TextAlign.end,
                            style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral200),
                          ),
                        ),
                      ],
                    ),
                    if (thinnedOn == null) ...[
                      const SizedBox(height: Spacing.sm),
                      Text(
                        _windowLine(l10n, opens, closes, locale),
                        style: textTheme.labelLarge?.copyWith(color: VioraColors.harvest300),
                      ),
                    ],
                  ],
                  const SizedBox(height: Spacing.md),
                  _ThinningTag(thinnedOn: thinnedOn),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _elapsed(DateTime opens, DateTime closes) {
    final total = closes.difference(opens).inMinutes;
    if (total <= 0) return 1;
    return (now.difference(opens).inMinutes / total).clamp(0.0, 1.0);
  }

  String _windowLine(AppLocalizations l10n, DateTime opens, DateTime closes, String locale) {
    final left = daysUntil(closes, now);
    if (left < 0) return l10n.riskWindowClosed;
    if (daysUntil(opens, now) > 0) return l10n.riskWindowOpens(formatDayMonth(opens, locale));
    return l10n.riskWindowDaysLeft(left);
  }
}

class _ThinningTag extends StatelessWidget {
  const _ThinningTag({required this.thinnedOn});

  final DateTime? thinnedOn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final at = thinnedOn;
    final (background, foreground, icon, label) = at == null
        ? (VioraColors.terracotta100, VioraColors.terracotta700, VioraIcons.warning, l10n.riskThinningMissing)
        : (VioraColors.green200, VioraColors.green900, VioraIcons.taskAlt, l10n.riskThinningDone(formatDayMonth(at, locale)));
    return DecoratedBox(
      decoration: ShapeDecoration(color: background, shape: const StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VioraIcon(icon, size: 18, color: foreground),
            const SizedBox(width: Spacing.xs),
            Flexible(child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: foreground))),
          ],
        ),
      ),
    );
  }
}

class _BearingCard extends StatelessWidget {
  const _BearingCard({required this.index});

  final double index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final band = index > 0.40
        ? l10n.riskBearingHigh
        : index >= 0.20
            ? l10n.riskBearingModerate
            : l10n.riskBearingLow;
    return VioraCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.riskBearingEyebrow.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(color: VioraColors.neutral600, letterSpacing: 1),
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatTwoDecimals(index, locale),
                style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 28, color: VioraColors.neutral900),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(l10n.riskBearingBand(band), style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral700)),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(l10n.riskBearingNote, style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral700)),
        ],
      ),
    );
  }
}

/// G23 · Sin datos suficientes: no load nor prescription. It stays grey, never green.
class _NoDataCard extends StatelessWidget {
  const _NoDataCard({required this.plot});

  final RiskPlotDetail plot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return VioraCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashedCircle(size: 64, child: VioraIcon(VioraIcons.info, size: 28, color: VioraColors.neutral700)),
          const SizedBox(height: Spacing.md),
          VioraEditorialTitle(l10n.riskNoDataTitle, fontSize: 34, lineHeight: 40),
          const SizedBox(height: Spacing.sm),
          Text(l10n.riskNoDataBody, style: textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700)),
          const SizedBox(height: Spacing.md),
          DecoratedBox(
            decoration: BoxDecoration(color: VioraColors.neutral100, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Column(
                children: [
                  _PendingRow(
                    iconAsset: VioraIcons.tag,
                    label: l10n.riskNoDataSampling,
                    value: l10n.riskNoDataSamplingValue(plot.sampledTrees, _validSampleTrees),
                  ),
                  const Divider(height: 1, color: VioraColors.neutral200),
                  _PendingRow(iconAsset: VioraIcons.scale, label: l10n.riskLoadTitle, value: l10n.riskNoDataLoadValue),
                  const Divider(height: 1, color: VioraColors.neutral200),
                  _PendingRow(
                    iconAsset: VioraIcons.contentCut,
                    label: l10n.riskNoDataPrescription,
                    value: l10n.riskNoDataPrescriptionValue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingRow extends StatelessWidget {
  const _PendingRow({required this.iconAsset, required this.label, required this.value});

  final String iconAsset;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Row(
        children: [
          VioraIcon(iconAsset, size: 20, color: VioraColors.neutral700),
          const SizedBox(width: Spacing.sm),
          Expanded(child: Text(label, style: textTheme.titleSmall)),
          const SizedBox(width: Spacing.xs),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral700),
            ),
          ),
        ],
      ),
    );
  }
}
