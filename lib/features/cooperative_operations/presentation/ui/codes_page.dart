import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_status_tag.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/state/codes_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/issue_codes_sheet.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/issued_codes_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/share_codes.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/codes_view_model.dart';

/// G42 · Códigos de activación: codes to redeem (shared again or revoked), redeemed ones and
/// closed ones, by batch.
class CodesPage extends StatelessWidget {
  const CodesPage({super.key, required this.onBack, required this.onIssued, required this.onOpenMembers});

  final VoidCallback onBack;

  /// Opens G44 with the codes just issued in G43.
  final Future<void> Function(IssuedCodesArgs args) onIssued;

  /// "Ver socios" of G42 · Código ya canjeado.
  final VoidCallback onOpenMembers;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CodesViewModel>()..load(),
      child: BlocConsumer<CodesViewModel, CodesUiState>(
        listenWhen: (previous, current) =>
            (current.redeemed != null && previous.redeemed == null) || (current.notAvailable && !previous.notAvailable),
        listener: (context, state) => _showOutcome(context, state),
        builder: (context, state) {
          final viewModel = context.read<CodesViewModel>();
          return CodesPageContent(
            state: state,
            now: DateTime.now(),
            onBack: onBack,
            onRetry: viewModel.load,
            onTab: viewModel.selectTab,
            onShare: (code) => shareCodesOnWhatsapp(
              context,
              organizationName: state.capacity?.organizationName ?? '',
              codes: [code.shown],
              expiresAt: code.expiresAt,
            ),
            onRevoke: (code) => _confirmRevoke(context, viewModel, state.capacity, code),
            onIssueCodes: (capacity) async {
              final issued = await showIssueCodesSheet(context, capacity);
              if (issued == null) return;
              await viewModel.load();
              await onIssued(IssuedCodesArgs(issued: issued, organizationName: capacity.organizationName));
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmRevoke(
    BuildContext context,
    CodesViewModel viewModel,
    LicenseCapacity? capacity,
    InvitationCode code,
  ) async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    String ha(double value) => formatHectares(value, locale);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => CooperativeDialog(
        iconAsset: VioraIcons.warning,
        iconBackground: VioraColors.terracotta100,
        iconColor: VioraColors.terracotta700,
        title: l10n.revokeTitle(code.shown),
        body: l10n.revokeBody(ha(code.hectares)),
        summary: capacity == null
            ? const SizedBox.shrink()
            : FigureLine(
                figure: '${capacity.seatsFree} → ${capacity.seatsFree + 1}',
                text: l10n.revokeSeats(ha(capacity.freeAreaHa), ha(capacity.freeAreaHa + code.hectares)),
              ),
        primaryLabel: l10n.revokeAction,
        primaryColor: VioraColors.terracotta500,
        onPrimary: () => Navigator.of(context).pop(true),
        secondaryLabel: l10n.cooperativeCancel,
        onSecondary: () => Navigator.of(context).pop(false),
      ),
    );
    if (confirmed ?? false) await viewModel.revoke(code);
  }

  void _showOutcome(BuildContext context, CodesUiState state) {
    final viewModel = context.read<CodesViewModel>();
    final l10n = AppLocalizations.of(context);
    if (state.notAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.codesNotAvailable)));
      viewModel.dismissNotAvailable();
      return;
    }
    final redeemed = state.redeemed;
    if (redeemed == null) return;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final at = redeemed.redeemedAt;
    final when = at == null ? null : DateFormat('d MMM, HH:mm', locale).format(at.toLocal()).replaceAll('.', '');
    showDialog<void>(
      context: context,
      builder: (dialogContext) => CooperativeDialog(
        iconAsset: VioraIcons.info,
        iconBackground: VioraColors.harvest100,
        iconColor: VioraColors.harvest800,
        title: l10n.redeemedTitle,
        body: redeemed.redeemedBy != null && when != null
            ? l10n.redeemedBody(redeemed.redeemedBy!, when)
            : l10n.redeemedBodyUnknown,
        summary: Row(
          children: [
            CodeText(redeemed.code),
            if (when != null) ...[
              const SizedBox(width: Spacing.xs),
              Flexible(
                child: Text(
                  l10n.redeemedWhen(when),
                  style: Theme.of(dialogContext).textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                ),
              ),
            ],
          ],
        ),
        primaryLabel: l10n.redeemedSeeMembers,
        primaryColor: VioraColors.green900,
        onPrimary: () {
          Navigator.of(dialogContext).pop();
          onOpenMembers();
        },
        secondaryLabel: l10n.redeemedUnderstood,
        onSecondary: () => Navigator.of(dialogContext).pop(),
      ),
    ).whenComplete(viewModel.dismissRedeemed);
  }
}

/// Visual content of G42, without Bloc, so it can be tested with a fixed state.
class CodesPageContent extends StatelessWidget {
  const CodesPageContent({
    super.key,
    required this.state,
    required this.now,
    required this.onBack,
    required this.onRetry,
    required this.onTab,
    required this.onShare,
    required this.onRevoke,
    required this.onIssueCodes,
  });

  final CodesUiState state;
  final DateTime now;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final ValueChanged<InvitationCodeFilter> onTab;
  final ValueChanged<InvitationCode> onShare;
  final ValueChanged<InvitationCode> onRevoke;
  final void Function(LicenseCapacity capacity) onIssueCodes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final capacity = state.capacity;
    final failure = state.failure;
    String ha(double value) => formatHectares(value, locale);
    final footer = switch (state.tab) {
      InvitationCodeFilter.available => capacity == null
          ? null
          : l10n.codesFooterAvailable(capacity.seatsFree, ha(capacity.freeAreaHa)),
      InvitationCodeFilter.redeemed => l10n.codesFooterRedeemed,
      InvitationCodeFilter.closed => l10n.codesFooterClosed,
    };
    final empty = switch (state.tab) {
      InvitationCodeFilter.available => l10n.codesEmptyAvailable,
      InvitationCodeFilter.redeemed => l10n.codesEmptyRedeemed,
      InvitationCodeFilter.closed => l10n.codesEmptyClosed,
    };
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
            CooperativeTopBar(
              title: l10n.codesTitle,
              subtitle: capacity == null
                  ? ''
                  : l10n.codesSubtitle(capacity.organizationName, capacity.seats, ha(capacity.contractedAreaHa)),
              onBack: onBack,
              notice: state.revokedNotice ? l10n.codesRevokedNotice : null,
            ),
            const SizedBox(height: Spacing.lg),
            VioraEditorialTitle(l10n.codesHeadline, fontSize: 44, lineHeight: 46),
            const SizedBox(height: Spacing.lg),
            _Tabs(state: state, onTab: onTab),
            const SizedBox(height: Spacing.md),
            if (failure != null)
              CooperativeFailureView(failure: failure, onRetry: onRetry)
            else if (state.loading && state.codes.isEmpty)
              const Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
              )
            else if (state.batches.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
                child: Text(
                  empty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.neutral600),
                ),
              )
            else
              for (final batch in state.batches) ...[
                _BatchCard(
                  codes: batch,
                  tab: state.tab,
                  now: now,
                  revoking: state.revoking,
                  onShare: onShare,
                  onRevoke: onRevoke,
                ),
                const SizedBox(height: Spacing.sm),
              ],
            if (capacity != null) ...[
              const SizedBox(height: Spacing.xs),
              CooperativeActionPill(
                label: l10n.membersIssueCodes,
                iconAsset: VioraIcons.add,
                onPressed: capacity.seatsFree > 0 ? () => onIssueCodes(capacity) : null,
              ),
            ],
            if (footer != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(footer, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral600)),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.state, required this.onTab});

  final CodesUiState state;
  final ValueChanged<InvitationCodeFilter> onTab;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = {
      InvitationCodeFilter.available: l10n.codesTabAvailable(state.of(InvitationCodeFilter.available).length),
      InvitationCodeFilter.redeemed: l10n.codesTabRedeemed(state.of(InvitationCodeFilter.redeemed).length),
      InvitationCodeFilter.closed: l10n.codesTabClosed(state.of(InvitationCodeFilter.closed).length),
    };
    return DecoratedBox(
      decoration: const ShapeDecoration(color: VioraColors.neutral0, shape: StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (final entry in labels.entries)
              Expanded(
                child: Semantics(
                  selected: state.tab == entry.key,
                  button: true,
                  child: Material(
                    color: state.tab == entry.key ? VioraColors.green900 : Colors.transparent,
                    shape: const StadiumBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onTab(entry.key),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                        child: Text(
                          entry.value,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: state.tab == entry.key ? VioraColors.neutral50 : VioraColors.neutral900,
                              ),
                        ),
                      ),
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

class _BatchCard extends StatelessWidget {
  const _BatchCard({
    required this.codes,
    required this.tab,
    required this.now,
    required this.revoking,
    required this.onShare,
    required this.onRevoke,
  });

  final List<InvitationCode> codes;
  final InvitationCodeFilter tab;
  final DateTime now;
  final bool revoking;
  final ValueChanged<InvitationCode> onShare;
  final ValueChanged<InvitationCode> onRevoke;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final first = codes.first;
    final days = daysUntil(first.expiresAt, now);
    final expiryTag = tab == InvitationCodeFilter.available
        ? VioraStatusTag(
            label: days <= 7 ? l10n.codesExpiresIn(days) : l10n.codesExpiresOn(formatDayMonth(first.expiresAt, locale)),
            tone: days <= 7 ? VioraTagTone.pending : VioraTagTone.neutral,
          )
        : null;
    return VioraCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.codesIssuedOn(formatDayMonth(first.issuedAt, locale)), style: textTheme.titleSmall),
              ),
              ?expiryTag,
            ],
          ),
          for (final code in codes) ...[
            const Divider(height: Spacing.lg, color: VioraColors.neutral200),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CodeText(code.shown),
                      Text(
                        _detail(l10n, locale, code),
                        style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                      ),
                    ],
                  ),
                ),
                if (tab == InvitationCodeFilter.available && code.code != null) ...[
                  ShareCodeButton(label: l10n.codesShare, onPressed: () => onShare(code)),
                  TextButton(
                    onPressed: revoking ? null : () => onRevoke(code),
                    child: Text(
                      l10n.codesRevoke,
                      style: textTheme.labelLarge?.copyWith(color: VioraColors.terracotta600),
                    ),
                  ),
                ],
                if (code.status == InvitationCodeStatus.revoked)
                  VioraStatusTag(label: l10n.codesRevokedTag, tone: VioraTagTone.neutral),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _detail(AppLocalizations l10n, String locale, InvitationCode code) {
    final hectares = l10n.codesPerCode(formatHectares(code.hectares, locale));
    final redeemedAt = code.redeemedAt;
    return switch (code.status) {
      InvitationCodeStatus.redeemed => l10n.codesRedeemedBy(
          code.redeemedBy ?? '',
          redeemedAt == null ? '' : formatDayMonth(redeemedAt, locale),
        ),
      InvitationCodeStatus.expired => '$hectares · ${l10n.codesExpiredOn(formatDayMonth(code.expiresAt, locale))}',
      _ => hectares,
    };
  }
}
