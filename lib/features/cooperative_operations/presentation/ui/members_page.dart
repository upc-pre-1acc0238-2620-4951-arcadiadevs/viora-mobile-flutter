import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_avatar.dart';
import 'package:viora/core/designsystem/component/viora_capsule_bar.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
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
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/state/members_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/issue_codes_sheet.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/issued_codes_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/members_view_model.dart';

/// G40 · Socios, the root of the members tab: the license, the codes to redeem and the roster.
/// [header] is the greeting of the Home, which the composition root provides.
class MembersPage extends StatelessWidget {
  const MembersPage({
    super.key,
    required this.header,
    required this.onOpenMember,
    required this.onOpenCodes,
    required this.onIssued,
    this.onOpenSectors = _noop,
    this.initialFilter = MembersFilter.all,
  });

  final Widget header;
  final void Function(String memberId) onOpenMember;

  /// Opens G42; the page reloads when the manager comes back.
  final Future<void> Function() onOpenCodes;

  /// Opens G44 with the codes just issued in G43.
  final Future<void> Function(IssuedCodesArgs args) onIssued;

  /// Opens G45 · Sectores; the page reloads when the manager comes back.
  final Future<void> Function() onOpenSectors;

  /// The chip selected when the page opens.
  final MembersFilter initialFilter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MembersViewModel>()
        ..filter(initialFilter)
        ..load(),
      child: BlocBuilder<MembersViewModel, MembersUiState>(
        builder: (context, state) {
          final viewModel = context.read<MembersViewModel>();
          return MembersPageContent(
            state: state,
            header: header,
            onRetry: viewModel.load,
            onSearch: viewModel.search,
            onFilter: viewModel.filter,
            onOpenMember: onOpenMember,
            onOpenCodes: () async {
              await onOpenCodes();
              await viewModel.load();
            },
            onOpenSectors: () async {
              await onOpenSectors();
              await viewModel.load();
            },
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
}

/// Visual content of G40, without Bloc, so it can be tested with a fixed state.
class MembersPageContent extends StatelessWidget {
  const MembersPageContent({
    super.key,
    required this.state,
    required this.header,
    required this.onRetry,
    required this.onSearch,
    required this.onFilter,
    required this.onOpenMember,
    required this.onOpenCodes,
    required this.onIssueCodes,
    this.onOpenSectors = _noopSync,
  });

  final MembersUiState state;
  final Widget header;
  final VoidCallback onRetry;
  final ValueChanged<String> onSearch;
  final ValueChanged<MembersFilter> onFilter;
  final void Function(String memberId) onOpenMember;
  final VoidCallback onOpenCodes;
  final void Function(LicenseCapacity capacity) onIssueCodes;
  final VoidCallback onOpenSectors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final capacity = state.capacity;
    final failure = state.failure;
    final members = state.visibleMembers;
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
            header,
            const SizedBox(height: 28),
            VioraEditorialTitle(l10n.membersHeadline, fontSize: 44, lineHeight: 46),
            if (capacity != null) ...[
              const SizedBox(height: Spacing.sm),
              VioraVoice(
                text: capacity.seatsFree > 0
                    ? l10n.membersVoice(capacity.seatsFree, formatHectares(capacity.freeAreaHa, locale))
                    : l10n.membersVoiceFull,
              ),
              const SizedBox(height: Spacing.md),
              _LicenseCard(
                capacity: capacity,
                pendingCodes: state.availableCodes.length,
                onIssueCodes: () => onIssueCodes(capacity),
              ),
              const SizedBox(height: Spacing.sm),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _CodesCard(state: state, onOpen: onOpenCodes)),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: _HectaresCard(
                        capacity: capacity,
                        registeredHa: state.members.fold(0.0, (sum, member) => sum + member.registeredAreaHa),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.sectorCount != null) ...[
                const SizedBox(height: Spacing.sm),
                _SectorsCard(count: state.sectorCount!, pending: state.pendingSectors, onTap: onOpenSectors),
              ],
            ],
            if (failure != null)
              CooperativeFailureView(failure: failure, onRetry: onRetry)
            else if (state.loading && capacity == null)
              const Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
              )
            else ...[
              const SizedBox(height: 28),
              VioraSectionHeader(title: l10n.membersSection, count: state.members.length),
              const SizedBox(height: Spacing.sm),
              _SearchField(hint: l10n.membersSearchHint, onChanged: onSearch),
              const SizedBox(height: Spacing.sm),
              _FilterChips(state: state, onFilter: onFilter),
              const SizedBox(height: Spacing.sm),
              if (members.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
                  child: Text(
                    state.members.isEmpty ? l10n.membersEmpty : l10n.membersNoMatch,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.neutral600),
                  ),
                )
              else
                for (var i = 0; i < members.length; i++) ...[
                  _MemberRow(member: members[i], index: i, onTap: () => onOpenMember(members[i].id)),
                  const SizedBox(height: Spacing.xs),
                ],
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _noop() async {}

void _noopSync() {}

/// «Sectores»: the way into G45, with how many plots wait «Por confirmar».
class _SectorsCard extends StatelessWidget {
  const _SectorsCard({required this.count, required this.pending, required this.onTap});

  final int count;
  final int pending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final title = l10n.sectorsTitle;
    return VioraCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(10, 10, Spacing.sm, 10),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 44,
            child: DecoratedBox(
              decoration: const ShapeDecoration(color: VioraColors.neutral100, shape: CircleBorder()),
              child: Center(
                child: Text(
                  title.substring(0, 2).toUpperCase(),
                  style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 15, color: VioraColors.neutral900),
                ),
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                Text(l10n.membersSectorsCount(count), style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600)),
                if (pending > 0) ...[
                  const SizedBox(height: 6),
                  VioraStatusTag(
                    label: l10n.membersSectorsPending(pending),
                    tone: VioraTagTone.pending,
                    iconAsset: VioraIcons.schedule,
                  ),
                ],
              ],
            ),
          ),
          const VioraIcon(VioraIcons.chevronRight, color: VioraColors.neutral900),
        ],
      ),
    );
  }
}

class _LicenseCard extends StatelessWidget {
  const _LicenseCard({required this.capacity, required this.pendingCodes, required this.onIssueCodes});

  final LicenseCapacity capacity;
  final int pendingCodes;
  final VoidCallback onIssueCodes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final members = (capacity.seatsUsed - pendingCodes).clamp(0, capacity.seats);
    const onDark = VioraColors.neutral50;
    return VioraCard(
      color: VioraColors.green900,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VioraEyebrowOnDark(l10n.membersLicenseEyebrow(capacity.startsAt.toLocal().year)),
          const SizedBox(height: Spacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${capacity.seatsUsed}',
                style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 64, height: 1, color: onDark),
              ),
              const SizedBox(width: Spacing.sm),
              Flexible(
                child: Text(
                  l10n.membersSeatsOf(capacity.seats),
                  style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 24, color: onDark)
                      .merge(vioraNewsreaderItalic),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          VioraSegmentedBar(
            height: 8,
            segments: [
              VioraBarSegment(value: members, color: VioraColors.neutral200),
              VioraBarSegment(value: pendingCodes, color: VioraColors.harvest300),
              VioraBarSegment(value: capacity.seatsFree, color: VioraColors.green700),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Wrap(
            spacing: Spacing.md,
            runSpacing: Spacing.xxs,
            children: [
              _Legend(color: VioraColors.neutral200, text: l10n.membersLegendMembers(members)),
              _Legend(color: VioraColors.harvest300, text: l10n.membersLegendPending(pendingCodes)),
              _Legend(color: VioraColors.green700, text: l10n.membersLegendFree(capacity.seatsFree)),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 220,
              child: CooperativeActionPill(
                light: true,
                label: l10n.membersIssueCodes,
                iconAsset: VioraIcons.add,
                onPressed: capacity.seatsFree > 0 ? onIssueCodes : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The eyebrow of the license card: a yellow dot and the uppercase label, on dark.
class VioraEyebrowOnDark extends StatelessWidget {
  const VioraEyebrowOnDark(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox.square(
          dimension: 6,
          child: DecoratedBox(decoration: ShapeDecoration(color: VioraColors.harvest300, shape: CircleBorder())),
        ),
        const SizedBox(width: Spacing.xs),
        Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.4,
                color: VioraColors.neutral50.withValues(alpha: 0.78),
              ),
        ),
      ],
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
          dimension: 6,
          child: DecoratedBox(decoration: ShapeDecoration(color: color, shape: const CircleBorder())),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral50.withValues(alpha: 0.85)),
        ),
      ],
    );
  }
}

class _CodesCard extends StatelessWidget {
  const _CodesCard({required this.state, required this.onOpen});

  final MembersUiState state;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final expiry = state.soonestExpiry;
    return VioraCard(
      color: VioraColors.harvest100,
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${state.availableCodes.length}',
                  style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 40, height: 1),
                ),
              ),
              const DecoratedBox(
                decoration: ShapeDecoration(color: VioraColors.neutral0, shape: CircleBorder()),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: VioraIcon(VioraIcons.arrowForward, size: 20, color: VioraColors.neutral900),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            l10n.membersCodesToRedeem,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral700),
          ),
          Text(
            expiry == null
                ? l10n.membersCodesNone
                : l10n.membersCodesExpire(expiry.count, formatDayMonth(expiry.date, locale)),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral700),
          ),
        ],
      ),
    );
  }
}

class _HectaresCard extends StatelessWidget {
  const _HectaresCard({required this.capacity, required this.registeredHa});

  final LicenseCapacity capacity;
  final double registeredHa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral700);
    return VioraCard(
      color: VioraColors.green200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${formatHectares(capacity.reservedAreaHa, locale)} ha',
            style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 32, height: 1.2),
          ),
          const SizedBox(height: Spacing.xs),
          Text(l10n.membersReservedOf(formatHectares(capacity.contractedAreaHa, locale)), style: style),
          Text(l10n.membersRegistered(formatHectares(registeredHa, locale)), style: style),
          const SizedBox(height: Spacing.xs),
          VioraProgressBar(
            value: capacity.contractedAreaHa <= 0 ? 0 : (capacity.reservedAreaHa / capacity.contractedAreaHa).clamp(0, 1),
            height: 8,
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.hint, required this.onChanged});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(color: VioraColors.neutral0, shape: StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        child: Row(
          children: [
            const VioraIcon(VioraIcons.search, size: 20, color: VioraColors.neutral600),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.state, required this.onFilter});

  final MembersUiState state;
  final ValueChanged<MembersFilter> onFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = {
      MembersFilter.all: l10n.membersFilterAll(state.members.length),
      MembersFilter.sharing: l10n.membersFilterSharing(state.sharingCount),
      MembersFilter.withdrawn: l10n.membersFilterWithdrawn(state.withdrawnCount),
      // Only while someone is missing a sampling, or the intake asked for it.
      if (state.unsampledCount > 0 || state.filter == MembersFilter.unsampled)
        MembersFilter.unsampled: l10n.membersFilterUnsampled(state.unsampledCount),
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in labels.entries) ...[
            _Chip(label: entry.value, selected: state.filter == entry.key, onTap: () => onFilter(entry.key)),
            const SizedBox(width: Spacing.xs),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? VioraColors.green900 : VioraColors.neutral0,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: 10),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? VioraColors.neutral50 : VioraColors.neutral900,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatars take turns over the palette of the design.
const _avatarColors = [
  VioraColors.green200,
  VioraColors.terracotta100,
  VioraColors.harvest100,
  VioraColors.neutral100,
];

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member, required this.index, required this.onTap});

  final CooperativeMember member;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final textTheme = Theme.of(context).textTheme;
    final sharing = member.sharing == MemberSharing.sharing;
    final summary = sharing
        ? [
            '${formatHectares(member.registeredAreaHa, locale)} ha',
            l10n.membersPlots(member.plotCount),
            if (member.sectorNames.isNotEmpty) member.sectorNames.join(', '),
          ].join(' · ')
        : l10n.membersNoSharedData;
    final withdrawnAt = member.withdrawnAt;
    final tag = switch (member.sharing) {
      MemberSharing.sharing => VioraStatusTag(
          label: l10n.membersLinked,
          tone: VioraTagTone.info,
          iconAsset: VioraIcons.taskAlt,
        ),
      MemberSharing.withdrawn => VioraStatusTag(
          label: withdrawnAt == null
              ? l10n.memberWithdrawnTag
              : l10n.membersWithdrawnOn(formatDayMonth(withdrawnAt, locale)),
          tone: VioraTagTone.pending,
          iconAsset: VioraIcons.schedule,
        ),
      MemberSharing.notSharing => VioraStatusTag(label: l10n.membersNotSharing, tone: VioraTagTone.neutral),
    };
    return VioraCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(Spacing.md, 14, Spacing.sm, 14),
      child: Row(
        children: [
          VioraAvatar(name: member.fullName, size: 44, background: _avatarColors[index % _avatarColors.length]),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.fullName, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  summary,
                  style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                tag,
              ],
            ),
          ),
          const VioraIcon(VioraIcons.chevronRight, color: VioraColors.neutral900),
        ],
      ),
    );
  }
}

