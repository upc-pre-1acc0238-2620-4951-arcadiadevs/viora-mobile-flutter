import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_zone.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/sectors_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/sectors_view_model.dart';

/// G45 · Sectores: the license's list and the plots «Por confirmar». Opens G46 · Revisar sector
/// and G47 · Añadir sector, which also renames.
class SectorsPage extends StatelessWidget {
  const SectorsPage({super.key, required this.onBack});

  static const path = 'sector-list';

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SectorsViewModel>()..load(),
      child: BlocBuilder<SectorsViewModel, SectorsUiState>(
        builder: (context, state) {
          final viewModel = context.read<SectorsViewModel>();
          return SectorsPageContent(
            state: state,
            onBack: onBack,
            onRetry: viewModel.load,
            onReview: (pending) => _openSheet(context, viewModel, ReviewSectorSheet(pending: pending)),
            onRename: (sector) => _openSheet(context, viewModel, SectorNameSheet(sector: sector)),
            onAdd: () => _openSheet(context, viewModel, const SectorNameSheet()),
          );
        },
      ),
    );
  }

  static Future<void> _openSheet(BuildContext context, SectorsViewModel viewModel, Widget sheet) {
    viewModel.clearSheetFailure();
    return showModalBottomSheet<void>(
      context: context,
      // Over the floating tab bar, which would otherwise cover the button of the sheet.
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: VioraColors.neutral100,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      builder: (context) => BlocProvider.value(value: viewModel, child: sheet),
    );
  }
}

/// G45 for a fixed [state], without the Bloc, so it can be tested.
class SectorsPageContent extends StatelessWidget {
  const SectorsPageContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onRetry,
    required this.onReview,
    required this.onRename,
    required this.onAdd,
  });

  final SectorsUiState state;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final ValueChanged<PendingSector> onReview;
  final ValueChanged<SectorZone> onRename;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final failure = state.failure;
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
            CooperativeTopBar(title: l10n.sectorsTitle, subtitle: l10n.sectorsSubtitle, onBack: onBack),
            const SizedBox(height: 28),
            VioraEditorialTitle(l10n.sectorsHeadline, fontSize: 44, lineHeight: 46),
            const SizedBox(height: Spacing.lg),
            if (failure != null)
              CooperativeFailureView(failure: failure, onRetry: onRetry)
            else if (state.loading)
              const Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
              )
            else ...[
              if (state.pending.isNotEmpty) ...[
                _ListCard(
                  title: l10n.sectorsPendingTitle,
                  badge: l10n.sectorsPendingCount(state.pending.length),
                  badgeColors: (VioraColors.harvest100, VioraColors.harvest800),
                  rows: [
                    for (final pending in state.pending)
                      _Row(
                        title: pending.proposedName,
                        subtitle: l10n.sectorsPendingLine(pending.producerName, pending.plotName),
                        action: l10n.sectorsReview,
                        onTap: () => onReview(pending),
                      ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
              ],
              _ListCard(
                title: l10n.sectorsListTitle,
                badge: l10n.sectorsListCount(state.sectors.length),
                badgeColors: (VioraColors.neutral50, VioraColors.neutral700),
                rows: [
                  for (final sector in state.sectors)
                    _Row(
                      title: sector.name,
                      subtitle: l10n.sectorsPlotCount(sector.plotCount),
                      action: l10n.sectorsRename,
                      onTap: () => onRename(sector),
                    ),
                ],
                empty: l10n.sectorsEmpty,
              ),
              const SizedBox(height: Spacing.lg),
              CooperativeActionPill(label: l10n.sectorsAdd, iconAsset: VioraIcons.add, onPressed: onAdd),
              const SizedBox(height: Spacing.sm),
              Text(l10n.sectorsNote, style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600)),
            ],
          ],
        ),
      ),
    );
  }
}

/// A white card with its title and count badge over its rows: «Por confirmar» and «Tu lista».
class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.title,
    required this.badge,
    required this.badgeColors,
    required this.rows,
    this.empty,
  });

  final String title;
  final String badge;
  final (Color, Color) badgeColors;
  final List<Widget> rows;
  final String? empty;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final empty = this.empty;
    return VioraCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: textTheme.titleSmall)),
              DecoratedBox(
                decoration: ShapeDecoration(color: badgeColors.$1, shape: const StadiumBorder()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text(badge, style: textTheme.labelSmall?.copyWith(color: badgeColors.$2)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (rows.isEmpty && empty != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.md),
              child: Text(empty, style: textTheme.bodyMedium?.copyWith(color: VioraColors.neutral600)),
            )
          else
            for (final row in rows) row,
        ],
      ),
    );
  }
}

/// A sector or a plot «Por confirmar», with its action in terracotta on the right.
class _Row extends StatelessWidget {
  const _Row({required this.title, required this.subtitle, required this.action, required this.onTap});

  final String title;
  final String subtitle;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: '$title, $subtitle',
      onTapHint: action,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: VioraColors.neutral200))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: textTheme.titleSmall?.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Text(action, style: textTheme.labelLarge?.copyWith(color: VioraColors.terracotta700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The top of the sector sheets: handle, the two-line title, a line under it and the close
/// button.
class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, required this.subtitle});

  /// Editorial, its second line between asterisks: «Añadir\n*sector*».
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 36,
            height: 4,
            decoration: const ShapeDecoration(color: VioraColors.neutral300, shape: StadiumBorder()),
          ),
        ),
        const SizedBox(height: Spacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: VioraEditorialTitle(title, fontSize: 34, lineHeight: 38)),
            VioraCircleButton(
              iconAsset: VioraIcons.close,
              label: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xxs),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13, color: VioraColors.neutral600)),
        const SizedBox(height: Spacing.md),
      ],
    );
  }
}

/// The scaffold of the sector sheets: padded, above the keyboard and scrollable.
class _SheetBody extends StatelessWidget {
  const _SheetBody({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(Spacing.lg, Spacing.sm, Spacing.lg, Spacing.lg + MediaQuery.paddingOf(context).bottom),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

/// The yellow note of the sheets.
class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: VioraColors.harvest100, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral700)),
      ),
    );
  }
}

/// What the sheets say when they could not save.
String sectorSheetError(AppLocalizations l10n, CooperativeFailure failure) => switch (failure) {
      SectorNameTaken() => l10n.sectorNameTaken,
      SectorNameInvalid() => l10n.sectorNameInvalid,
      CooperativeOffline() => l10n.sectorSaveOffline,
      _ => l10n.sectorSaveFailed,
    };

/// G47 · Añadir sector; with [sector], the same sheet renames it.
class SectorNameSheet extends StatefulWidget {
  const SectorNameSheet({super.key, this.sector});

  final SectorZone? sector;

  @override
  State<SectorNameSheet> createState() => _SectorNameSheetState();
}

class _SectorNameSheetState extends State<SectorNameSheet> {
  late final TextEditingController _name = TextEditingController(text: widget.sector?.name ?? '');

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final saved = await context.read<SectorsViewModel>().save(_name.text, sectorId: widget.sector?.id);
    if (saved && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final renaming = widget.sector != null;
    return BlocBuilder<SectorsViewModel, SectorsUiState>(
      builder: (context, state) {
        final failure = state.sheetFailure;
        return _SheetBody(
          children: [
            _SheetHeader(
              title: renaming ? l10n.sectorRenameHeadline : l10n.sectorAddHeadline,
              subtitle: renaming ? widget.sector!.name : l10n.sectorsSubtitle,
            ),
            VioraCard(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.sectorNameLabel.toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(letterSpacing: 0.88, color: VioraColors.neutral600),
                  ),
                  const SizedBox(height: Spacing.sm),
                  TextField(
                    controller: _name,
                    autofocus: true,
                    maxLength: SectorNames.maxLength,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => SectorNames.isValid(_name.text) ? _save() : null,
                    style: textTheme.bodyMedium?.copyWith(color: VioraColors.neutral900),
                    decoration: InputDecoration(
                      hintText: l10n.sectorNamePlaceholder,
                      hintStyle: textTheme.bodyMedium?.copyWith(color: VioraColors.neutral500),
                      counterText: '',
                      filled: true,
                      fillColor: VioraColors.neutral100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100)), borderSide: BorderSide.none),
                    ),
                  ),
                  if (failure != null) ...[
                    const SizedBox(height: Spacing.xs),
                    Text(sectorSheetError(l10n, failure), style: textTheme.bodySmall?.copyWith(color: VioraColors.terracotta700)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Spacing.sm),
            _Note(l10n.sectorNameHint),
            const SizedBox(height: Spacing.sm),
            CooperativeActionPill(
              label: renaming ? l10n.sectorRenameSave : l10n.sectorSave,
              iconAsset: VioraIcons.check,
              loading: state.saving,
              onPressed: SectorNames.isValid(_name.text) ? _save : null,
            ),
          ],
        );
      },
    );
  }
}

/// G46 · Revisar sector: the name a member wrote, joined to a sector of the list («Es el mismo
/// que…») or added as a new one.
class ReviewSectorSheet extends StatefulWidget {
  const ReviewSectorSheet({super.key, required this.pending});

  final PendingSector pending;

  @override
  State<ReviewSectorSheet> createState() => _ReviewSectorSheetState();
}

class _ReviewSectorSheetState extends State<ReviewSectorSheet> {
  SectorZone? _sameAs;

  Future<void> _confirm() async {
    final done = await context.read<SectorsViewModel>().resolve(widget.pending.plotId, sectorId: _sameAs?.id);
    if (done && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final pending = widget.pending;
    final sameAs = _sameAs;
    return BlocBuilder<SectorsViewModel, SectorsUiState>(
      builder: (context, state) {
        final failure = state.sheetFailure;
        return _SheetBody(
          children: [
            _SheetHeader(
              title: _twoLines(pending.proposedName),
              subtitle: l10n.sectorsPendingLine(pending.producerName, pending.plotName),
            ),
            if (state.sectors.isNotEmpty) ...[
              VioraCard(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sectorReviewSameAs.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(letterSpacing: 0.88, color: VioraColors.neutral600),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Wrap(
                      spacing: Spacing.xs,
                      runSpacing: Spacing.xs,
                      children: [
                        for (final sector in state.sectors)
                          _Chip(
                            label: sector.name,
                            selected: sector.id == sameAs?.id,
                            onTap: () => setState(() => _sameAs = sector.id == sameAs?.id ? null : sector),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.sm),
            ],
            _Note(l10n.sectorReviewHint),
            if (failure != null) ...[
              const SizedBox(height: Spacing.xs),
              Text(sectorSheetError(l10n, failure), style: textTheme.bodySmall?.copyWith(color: VioraColors.terracotta700)),
            ],
            const SizedBox(height: Spacing.sm),
            CooperativeActionPill(
              label: sameAs == null ? l10n.sectorReviewAdd : l10n.sectorReviewJoin(sameAs.name),
              iconAsset: VioraIcons.check,
              loading: state.saving,
              onPressed: _confirm,
            ),
          ],
        );
      },
    );
  }

  /// «Cerro\n*Blanco*»: the written name as the two-line title of the sheet.
  static String _twoLines(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length < 2) return name.trim();
    return '${words.first}\n*${words.skip(1).join(' ')}*';
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
      button: true,
      selected: selected,
      child: Material(
        color: selected ? VioraColors.green900 : VioraColors.neutral50,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 13,
                    color: selected ? VioraColors.neutral50 : VioraColors.neutral900,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
