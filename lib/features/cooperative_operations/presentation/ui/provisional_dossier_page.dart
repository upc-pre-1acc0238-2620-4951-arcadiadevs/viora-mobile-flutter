import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/state/provisional_dossier_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/provisional_dossier_view_model.dart';

/// T16 · Expediente técnico: the provisional dossier of a member plot, read-only, with its PDF.
/// It never shows a verification code: only the sealed dossier of a closed season carries one.
class ProvisionalDossierPage extends StatelessWidget {
  const ProvisionalDossierPage({super.key, required this.plotId, required this.onBack});

  static const path = 'dossier';

  final String plotId;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProvisionalDossierViewModel>()..load(plotId),
      child: BlocConsumer<ProvisionalDossierViewModel, ProvisionalDossierUiState>(
        listenWhen: (previous, current) => current.notice != null && !identical(previous.notice, current.notice),
        listener: (context, state) {
          final l10n = AppLocalizations.of(context);
          final failure = state.notice!.failure;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(failure == null ? l10n.dossierSaved : cooperativeFailureMessage(l10n, failure)),
            ));
        },
        builder: (context, state) {
          final viewModel = context.read<ProvisionalDossierViewModel>();
          return ProvisionalDossierContent(
            state: state,
            onBack: onBack,
            onRetry: () => viewModel.load(plotId),
            onDownload: viewModel.download,
            onShare: () => viewModel.share(
              subject: AppLocalizations.of(context).dossierShareSubject(state.dossier?.plotName ?? ''),
            ),
          );
        },
      ),
    );
  }
}

/// Visual content of T16, without Bloc, so it can be tested with a fixed state.
class ProvisionalDossierContent extends StatelessWidget {
  const ProvisionalDossierContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onRetry,
    required this.onDownload,
    required this.onShare,
  });

  final ProvisionalDossierUiState state;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dossier = state.dossier;
    final failure = state.failure;
    final exporting = state.exporting;
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
              title: l10n.dossierTitle,
              subtitle: dossier == null ? '' : l10n.dossierSubtitle(dossier.plotName, dossier.campaignYear),
              onBack: onBack,
            ),
            const SizedBox(height: Spacing.sm),
            if (failure != null)
              CooperativeFailureView(failure: failure, onRetry: onRetry)
            else if (dossier == null)
              const Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
              )
            else ...[
              _SummaryCard(dossier: dossier),
              const SizedBox(height: Spacing.md),
              _ProvisionalCard(cutOffAt: dossier.cutOffAt),
              const SizedBox(height: Spacing.md),
              CooperativeActionPill(
                label: l10n.dossierDownload,
                iconAsset: VioraIcons.download,
                loading: exporting == DossierExport.download,
                onPressed: exporting == null ? onDownload : null,
              ),
              const SizedBox(height: Spacing.sm),
              _ShareButton(
                label: l10n.dossierShare,
                loading: exporting == DossierExport.share,
                onPressed: exporting == null ? onShare : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The dark head with the plot, and the rows of the dossier under it.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.dossier});

  final ProvisionalDossier dossier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final rows = _rows(l10n, Localizations.localeOf(context).toLanguageTag());
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ColoredBox(
        color: VioraColors.neutral0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: VioraColors.green900,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dossierEyebrow.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(color: VioraColors.harvest300, letterSpacing: 1),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      dossier.plotName,
                      style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 34, height: 1.15, color: VioraColors.neutral50),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      [dossier.producerName, dossier.organizationName].where((part) => part.isNotEmpty).join(' · '),
                      style: vioraNewsreaderItalic.copyWith(fontSize: 17, color: VioraColors.neutral200),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: Spacing.sm),
              child: Column(
                children: [
                  for (final (index, row) in rows.indexed) ...[
                    if (index > 0) const Divider(height: 1, color: VioraColors.neutral200),
                    row,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_Row> _rows(AppLocalizations l10n, String locale) {
    final missing = l10n.dossierNotAvailable;
    final variety = formatVariety(dossier.variety);
    final area = dossier.areaHa;
    final fruits = dossier.fruitsPerShoot;
    final over = dossier.overTargetPercent;
    final removal = dossier.removalPercent;
    final opens = dossier.windowOpensOn;
    final closes = dossier.windowClosesOn;
    final thinnedOn = dossier.thinnedOn;
    String percent(double value) => l10n.riskPercent(formatOneDecimal(value, locale));
    return [
      _Row(label: l10n.dossierCampaign, value: l10n.dossierCampaignValue(dossier.campaignYear)),
      _Row(
        label: l10n.dossierVarietyArea,
        value: _joined([
          if (variety.isNotEmpty) variety,
          if (area != null) l10n.riskHectares(formatHectares(area, locale)),
        ], missing),
      ),
      _Row(
        label: l10n.dossierLoad,
        value: _joined([
          if (fruits != null) l10n.dossierLoadValue(formatTwoDecimals(fruits, locale)),
          if (fruits != null && over != null) '${over > 0 ? '+' : ''}${percent(over)}',
        ], missing),
      ),
      _Row(
        label: l10n.dossierPrescription,
        value: _joined([
          if (removal != null) l10n.dossierPrescriptionValue(percent(removal)),
          if (removal != null && opens != null && closes != null) _window(opens, closes, locale),
        ], missing),
      ),
      _Row(
        label: l10n.dossierThinning,
        value: thinnedOn == null ? l10n.dossierThinningMissing : formatDayMonth(thinnedOn, locale),
        color: thinnedOn == null ? VioraColors.terracotta700 : null,
      ),
      _Row(
        label: l10n.dossierClimate,
        value: '${l10n.dossierNodes(dossier.linkedNodes)} · ${l10n.dossierDays(dossier.daysWithReadings)}',
      ),
    ];
  }

  static String _joined(List<String> parts, String missing) => parts.isEmpty ? missing : parts.join(' · ');

  /// "3–30 nov" within a month, "28 oct–15 nov" across two.
  static String _window(DateTime opens, DateTime closes, String locale) {
    final sameMonth = opens.year == closes.year && opens.month == closes.month;
    return sameMonth
        ? '${opens.day}–${formatDayMonth(closes, locale)}'
        : '${formatDayMonth(opens, locale)}–${formatDayMonth(closes, locale)}';
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The label takes what it needs, up to 45 %, and the value the rest, so it keeps to one line.
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.45),
              child: Text(label, style: textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700)),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: textTheme.titleSmall?.copyWith(color: color ?? VioraColors.neutral900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// In place of a verification code: when the data was cut off, and that it may still change.
class _ProvisionalCard extends StatelessWidget {
  const _ProvisionalCard({required this.cutOffAt});

  final DateTime? cutOffAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final at = cutOffAt;
    return DecoratedBox(
      decoration: BoxDecoration(color: VioraColors.neutral200, borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const VioraIcon(VioraIcons.info, size: 18, color: VioraColors.neutral900),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: Text(
                    l10n.dossierProvisionalEyebrow.toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(color: VioraColors.neutral900, letterSpacing: 1),
                  ),
                ),
              ],
            ),
            if (at != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                l10n.dossierCutOff(
                  DateFormat('d MMM y, HH:mm', l10n.localeName).format(at.toLocal()).replaceAll('.', ''),
                ),
                style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 24, height: 1.2, color: VioraColors.neutral900),
              ),
            ],
            const SizedBox(height: Spacing.sm),
            Text(l10n.dossierProvisionalBody, style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral700)),
          ],
        ),
      ),
    );
  }
}

/// The white pill under «Descargar PDF».
class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.label, required this.loading, required this.onPressed});

  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      excludeSemantics: true,
      onTap: onPressed,
      child: Material(
        color: VioraColors.neutral0,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: VioraColors.green900),
                  )
                else
                  VioraIcon(
                    VioraIcons.share,
                    size: 20,
                    color: onPressed == null ? VioraColors.neutral500 : VioraColors.neutral900,
                  ),
                const SizedBox(width: Spacing.xs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: onPressed == null ? VioraColors.neutral500 : VioraColors.neutral900,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
