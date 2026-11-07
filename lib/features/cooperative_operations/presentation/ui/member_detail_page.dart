import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viora/core/designsystem/component/viora_avatar.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_section_header.dart';
import 'package:viora/core/designsystem/component/viora_status_tag.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/state/member_detail_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/member_detail_view_model.dart';

/// G41 · Socio: contact, hectares, link code and plots of one member; only the link code
/// while they don't share (G41 · Retiró el acceso).
class MemberDetailPage extends StatelessWidget {
  const MemberDetailPage({super.key, required this.memberId, required this.onBack});

  static const path = ':memberId';

  final String memberId;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MemberDetailViewModel>()..load(memberId),
      child: BlocBuilder<MemberDetailViewModel, MemberDetailUiState>(
        builder: (context, state) => MemberDetailContent(
          state: state,
          onBack: onBack,
          onRetry: () => context.read<MemberDetailViewModel>().load(memberId),
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

/// Visual content of G41, without Bloc, so it can be tested with a fixed state.
class MemberDetailContent extends StatelessWidget {
  const MemberDetailContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onRetry,
    required this.onCall,
    required this.onWhatsapp,
  });

  final MemberDetailUiState state;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final ValueChanged<String> onCall;
  final ValueChanged<String> onWhatsapp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final member = state.member;
    final failure = state.failure;
    final phone = member?.phone;
    final sharing = member?.sharing == MemberSharing.sharing;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.sm,
            Spacing.lg,
            VioraTabBarDefaults.contentBottomPadding + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            CooperativeTopBar(title: l10n.memberTitle, subtitle: state.organizationName ?? '', onBack: onBack),
            const SizedBox(height: Spacing.lg),
            if (failure != null)
              CooperativeFailureView(failure: failure, onRetry: onRetry)
            else if (member == null)
              const Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
              )
            else ...[
              _Hero(member: member),
              const SizedBox(height: Spacing.sm),
              VioraCard(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  children: [
                    if (sharing) ...[
                      if (phone != null) _InfoRow(label: l10n.memberPhone, value: phone),
                      if (member.email != null) _InfoRow(label: l10n.memberEmail, value: member.email!),
                      if (member.registeredAreaHa != null && member.quotaHa != null)
                        _InfoRow(
                          label: l10n.memberRegistered,
                          value: l10n.memberRegisteredValue(
                            formatHectares(member.registeredAreaHa!, locale),
                            formatHectares(member.quotaHa!, locale),
                          ),
                        ),
                    ],
                    if (member.maskedCode != null)
                      _InfoRow(
                        label: l10n.memberCode,
                        value: l10n.memberCodeValue(member.maskedCode!),
                        last: true,
                      ),
                  ],
                ),
              ),
              if (sharing && phone != null) ...[
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _ContactButton(
                        label: l10n.memberCall,
                        iconAsset: VioraIcons.smartphone,
                        color: VioraColors.neutral0,
                        onPressed: () => onCall(phone),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: _ContactButton(
                        label: l10n.memberWhatsapp,
                        iconAsset: VioraIcons.chat,
                        color: VioraColors.green200,
                        onPressed: () => onWhatsapp(phone),
                      ),
                    ),
                  ],
                ),
              ],
              if (!sharing) ...[
                const SizedBox(height: Spacing.md),
                Text(
                  member.sharing == MemberSharing.withdrawn ? l10n.memberWithdrawnNote : l10n.memberNotSharingNote,
                  style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                ),
              ],
              if (sharing && member.plots.isNotEmpty) ...[
                const SizedBox(height: 28),
                VioraSectionHeader(title: l10n.memberPlots, count: member.plots.length),
                const SizedBox(height: Spacing.sm),
                for (final plot in member.plots) ...[
                  _PlotRow(plot: plot),
                  const SizedBox(height: Spacing.xs),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.member});

  final MemberDetail member;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final parts = member.fullName.trim().split(RegExp(r'\s+'));
    final first = parts.first;
    final rest = parts.skip(1).join(' ');
    const nameStyle = TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 34, height: 1.1, color: VioraColors.neutral900);
    final since = member.sharing == MemberSharing.withdrawn ? member.withdrawnAt : member.memberSince;
    final tag = switch (member.sharing) {
      MemberSharing.sharing => VioraStatusTag(
          label: l10n.membersLinked,
          tone: VioraTagTone.info,
          iconAsset: VioraIcons.taskAlt,
        ),
      MemberSharing.withdrawn => VioraStatusTag(
          label: l10n.memberWithdrawnTag,
          tone: VioraTagTone.pending,
          iconAsset: VioraIcons.schedule,
        ),
      MemberSharing.notSharing => VioraStatusTag(label: l10n.membersNotSharing, tone: VioraTagTone.neutral),
    };
    return VioraCard(
      color: VioraColors.green200,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VioraAvatar(name: member.fullName, size: 64, background: VioraColors.neutral0),
              const Spacer(),
              DecoratedBox(
                decoration: const ShapeDecoration(color: VioraColors.neutral0, shape: StadiumBorder()),
                child: tag,
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Text(first, style: nameStyle),
          if (rest.isNotEmpty) Text(rest, style: nameStyle.merge(vioraNewsreaderItalic)),
          if (since != null) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              member.sharing == MemberSharing.withdrawn
                  ? l10n.memberWithdrawnSince(formatLongDate(since, locale))
                  : l10n.memberSince(formatLongDate(since, locale)),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral700),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.last = false});

  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: last ? null : const Border(bottom: BorderSide(color: VioraColors.neutral200)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Text(label, style: textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700)),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.label, required this.iconAsset, required this.color, required this.onPressed});

  final String label;
  final String iconAsset;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VioraIcon(iconAsset, size: 20, color: VioraColors.neutral900),
              const SizedBox(width: Spacing.xs),
              Text(label, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlotRow extends StatelessWidget {
  const _PlotRow({required this.plot});

  final MemberPlot plot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final (label, tone, icon) = _risk(l10n, plot);
    return VioraCard(
      padding: const EdgeInsets.fromLTRB(Spacing.md, 14, Spacing.md, 14),
      child: Row(
        children: [
          DecoratedBox(
            decoration: const ShapeDecoration(color: VioraColors.green200, shape: CircleBorder()),
            child: SizedBox.square(
              dimension: 44,
              child: Center(
                child: Text(
                  _badge(plot.name),
                  style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 18, color: VioraColors.green900),
                ),
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plot.name, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  l10n.memberPlotSummary(
                    formatVariety(plot.variety),
                    formatHectares(plot.areaHa, locale),
                    plot.sectorName ?? l10n.memberPlotSectorPending,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                ),
                const SizedBox(height: 6),
                VioraStatusTag(label: label, tone: tone, iconAsset: icon),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// "02" for "La Yarada 02", "LN" for "Lote Norte": the trailing number, or the initials.
  static String _badge(String name) {
    final number = RegExp(r'(\d+)\s*$').firstMatch(name);
    if (number != null) return number.group(1)!.padLeft(2, '0').substring(0, 2);
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    return words.take(2).map((w) => w[0].toUpperCase()).join();
  }

  static (String, VioraTagTone, String?) _risk(AppLocalizations l10n, MemberPlot plot) => switch (plot.risk) {
        PlotRisk.critical => (
            switch (plot.reason) {
              RiskReason.overload => l10n.riskOverload,
              RiskReason.criticalIncident => l10n.riskCriticalIncident,
              RiskReason.frostForecast => l10n.riskFrost,
              _ => l10n.riskCritical,
            },
            VioraTagTone.alert,
            VioraIcons.scale,
          ),
        PlotRisk.moderate => (
            plot.reason == RiskReason.frostForecast ? l10n.riskFrost : l10n.riskModerate,
            VioraTagTone.pending,
            VioraIcons.warning,
          ),
        PlotRisk.optimal => (l10n.riskOptimal, VioraTagTone.info, VioraIcons.taskAlt),
        PlotRisk.noData => (l10n.riskNoData, VioraTagTone.neutral, VioraIcons.info),
      };
}

