import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_circle_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';
import 'package:viora/features/cooperative_operations/presentation/state/risk_map_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/cooperative_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/risk_map_canvas.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/widgets/risk_widgets.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/risk_map_view_model.dart';

/// What the floating controls and the panel cover of the map.
const _mapPadding = EdgeInsets.fromLTRB(48, 190, 48, 400);

/// G20 · Riesgo territorial: the valley on a map or as a list of sectors, the first explanation
/// of the GPS and G21 when there is no GPS.
class RiskPage extends StatefulWidget {
  const RiskPage({
    super.key,
    required this.onOpenAlerts,
    required this.onOpenScope,
    required this.onOpenPlot,
  });

  final VoidCallback onOpenAlerts;

  /// A sector's id or one of [RiskScopes].
  final ValueChanged<String> onOpenScope;
  final ValueChanged<String> onOpenPlot;

  @override
  State<RiskPage> createState() => _RiskPageState();
}

class _RiskPageState extends State<RiskPage> {
  late final RiskMapViewModel _viewModel = getIt<RiskMapViewModel>()..start();

  late final AppLifecycleListener _lifecycle = AppLifecycleListener(onResume: _viewModel.resume);

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _viewModel.close();
    super.dispose();
  }

  Future<void> _explainLocation(BuildContext context) async {
    final allowed = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: VioraColors.neutral100,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => const LocationExplanationSheet(),
    );
    if (allowed ?? false) {
      await _viewModel.allowLocation();
    } else {
      await _viewModel.declineLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<RiskMapViewModel, RiskMapUiState>(
        listenWhen: (previous, current) => !previous.explainLocation && current.explainLocation,
        listener: (context, state) => _explainLocation(context),
        builder: (context, state) => RiskPageContent(
          state: state,
          now: DateTime.now(),
          onRetry: _viewModel.refresh,
          onShowList: _viewModel.showList,
          onToggleSector: _viewModel.toggleSector,
          onRetryGps: _viewModel.allowLocation,
          onOpenAlerts: widget.onOpenAlerts,
          onOpenScope: widget.onOpenScope,
          onOpenPlot: widget.onOpenPlot,
          map: (markers, focus, focusKey) => RiskMapCanvas(
            plots: state.plots,
            markers: markers,
            selectedPlotId: state.selectedPlotId,
            selectedSectorId: state.selectedSectorId,
            focus: focus,
            focusKey: focusKey,
            padding: _mapPadding,
            onTapPlot: _viewModel.tapPlot,
          ),
        ),
      ),
    );
  }
}

/// Visual content of G20, without Bloc or Mapbox, so it can be tested with a fixed state.
class RiskPageContent extends StatelessWidget {
  const RiskPageContent({
    super.key,
    required this.state,
    required this.now,
    required this.onRetry,
    required this.onShowList,
    required this.onToggleSector,
    required this.onRetryGps,
    required this.onOpenAlerts,
    required this.onOpenScope,
    required this.onOpenPlot,
    required this.map,
  });

  final RiskMapUiState state;
  final DateTime now;
  final VoidCallback onRetry;
  final ValueChanged<bool> onShowList;
  final ValueChanged<String> onToggleSector;
  final VoidCallback onRetryGps;
  final VoidCallback onOpenAlerts;
  final ValueChanged<String> onOpenScope;
  final ValueChanged<String> onOpenPlot;
  final Widget Function(List<RiskMapMarker> markers, List<GeoCoordinate> focus, String focusKey) map;

  @override
  Widget build(BuildContext context) {
    final failure = state.failure;
    final top = _TopControls(state: state, onShowList: onShowList, onOpenAlerts: onOpenAlerts);
    if (failure != null) {
      return Scaffold(
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.sm, Spacing.lg, 0),
            child: Column(children: [top, CooperativeFailureView(failure: failure, onRetry: onRetry)]),
          ),
        ),
      );
    }
    if (state.showList) {
      return _SectorListView(state: state, top: top, onRefresh: onRetry, onOpenScope: onOpenScope);
    }
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            Positioned.fill(child: map(_markers(context), _focus(), _focusKey())),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.sm, Spacing.lg, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    top,
                    const SizedBox(height: Spacing.sm),
                    if (state.gpsOff && state.location == null)
                      const _GpsOffPill()
                    else
                      RiskCountsStrip(group: state.territory.valley),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _Panel(
                state: state,
                now: now,
                onRetryGps: onRetryGps,
                onOpenScope: onOpenScope,
                onOpenPlot: onOpenPlot,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<GeoCoordinate> _centers(List<RiskPlot> plots) => [
        for (final plot in plots) ...(plot.outline.isNotEmpty ? plot.outline : [if (plot.center != null) plot.center!]),
      ];

  /// The chosen sector; or what is near the manager and the manager; or the whole valley.
  List<GeoCoordinate> _focus() {
    final sector = state.selectedSector;
    if (sector != null) return _centers(sector.group.plots);
    final location = state.location;
    final nearby = state.territory.nearby.plots;
    if (location != null && nearby.isNotEmpty) return [..._centers(nearby), location.coordinate];
    return _centers(state.plots);
  }

  String _focusKey() =>
      '${state.selectedSectorId}|${state.location != null}|${state.plots.isEmpty}';

  List<RiskMapMarker> _markers(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final territory = state.territory;
    final urgent = territory.sectorsByUrgency;
    final mostCritical = urgent.isNotEmpty && urgent.first.group.level == PlotRisk.critical ? urgent.first.id : null;
    final location = state.location;
    return [
      for (final sector in territory.sectorsByName)
        if (sector.labelPosition case final GeoCoordinate position)
          RiskMapMarker(
            key: 'sector-${sector.id}',
            position: position,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SectorChip(
                  name: sector.name,
                  detail: _chipDetail(l10n, sector, sector.id == mostCritical),
                  risk: sector.group.level,
                  dark: state.selectedSectorId == sector.id || (state.selectedSectorId == null && sector.id == mostCritical),
                  faded: state.selectedSectorId != null && state.selectedSectorId != sector.id,
                  onTap: () => onToggleSector(sector.id),
                ),
                if (sector.group.withFrost > 0) ...[const SizedBox(width: Spacing.xxs), const FrostMark()],
              ],
            ),
          ),
      if (location != null) RiskMapMarker(key: 'you', position: location.coordinate, child: const YouMarker()),
    ];
  }

  String _chipDetail(AppLocalizations l10n, RiskSector sector, bool mostCritical) {
    final group = sector.group;
    if (mostCritical) return l10n.riskChipCritical(group.critical);
    if (group.level == PlotRisk.noData) return '—';
    return '${group.critical}';
  }
}

class _TopControls extends StatelessWidget {
  const _TopControls({required this.state, required this.onShowList, required this.onOpenAlerts});

  final RiskMapUiState state;
  final ValueChanged<bool> onShowList;
  final VoidCallback onOpenAlerts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        DecoratedBox(
          decoration: const ShapeDecoration(color: VioraColors.neutral0, shape: StadiumBorder()),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ToggleOption(
                  label: l10n.riskMap,
                  iconAsset: VioraIcons.map,
                  selected: !state.showList,
                  onTap: () => onShowList(false),
                ),
                _ToggleOption(
                  label: l10n.riskList,
                  iconAsset: VioraIcons.list,
                  selected: state.showList,
                  onTap: () => onShowList(true),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        VioraCircleButton(
          iconAsset: VioraIcons.notifications,
          label: l10n.homeAlerts,
          showBadge: state.hasActiveAlerts,
          onPressed: onOpenAlerts,
        ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({required this.label, required this.iconAsset, required this.selected, required this.onTap});

  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? VioraColors.neutral50 : VioraColors.neutral900;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? VioraColors.green900 : Colors.transparent,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: Spacing.minTouchTarget - 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VioraIcon(iconAsset, size: 20, color: foreground),
                  const SizedBox(width: Spacing.xs),
                  Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: foreground)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GpsOffPill extends StatelessWidget {
  const _GpsOffPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(color: VioraColors.terracotta100, shape: StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VioraIcon(VioraIcons.warning, size: 18, color: VioraColors.terracotta700),
            const SizedBox(width: Spacing.xs),
            Flexible(
              child: Text(
                AppLocalizations.of(context).riskGpsOff,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: VioraColors.terracotta700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The panel over the tab bar. The chosen plot goes first, then the chosen sector, then what is
/// near the manager; without any of them, the sectors to choose from (G21).
class _Panel extends StatefulWidget {
  const _Panel({
    required this.state,
    required this.now,
    required this.onRetryGps,
    required this.onOpenScope,
    required this.onOpenPlot,
  });

  final RiskMapUiState state;
  final DateTime now;
  final VoidCallback onRetryGps;
  final ValueChanged<String> onOpenScope;
  final ValueChanged<String> onOpenPlot;

  @override
  State<_Panel> createState() => _PanelState();
}

class _PanelState extends State<_Panel> {
  bool _collapsed = false;

  @override
  void didUpdateWidget(_Panel old) {
    super.didUpdateWidget(old);
    final chose = old.state.selectedPlotId != widget.state.selectedPlotId ||
        old.state.selectedSectorId != widget.state.selectedSectorId;
    if (chose && _collapsed) _collapsed = false;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final plot = state.selectedPlot;
    final sector = state.selectedSector;
    final nearby = state.territory.nearby;
    final Widget content;
    if (state.loading) {
      content = const Padding(
        padding: EdgeInsets.all(Spacing.xl),
        child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
      );
    } else if (state.plots.isEmpty) {
      content = const _EmptyPanel();
    } else if (plot != null) {
      content = _PlotPanel(plot: plot, detail: state.selectedDetail, now: widget.now, onOpen: widget.onOpenPlot);
    } else if (sector != null) {
      content = _SectorPanel(sector: sector, now: widget.now, onOpen: widget.onOpenScope);
    } else if (state.location != null && nearby.total > 0) {
      content = _NearbyPanel(state: state, now: widget.now, onOpen: () => widget.onOpenScope(RiskScopes.nearby));
    } else {
      content = _SectorPicker(state: state, onRetryGps: widget.onRetryGps, onOpen: widget.onOpenScope);
    }
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: VioraColors.neutral100,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Padding(
        // The panel's action must clear the shell's fade, or it would look washed out.
        padding: const EdgeInsets.only(bottom: VioraTabBarDefaults.fadeHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _collapsed = !_collapsed),
              onVerticalDragEnd: (details) {
                final velocity = details.primaryVelocity ?? 0;
                if (velocity != 0) setState(() => _collapsed = velocity > 0);
              },
              child: const SizedBox(
                width: double.infinity,
                height: 24,
                child: Center(
                  child: SizedBox(
                    width: 36,
                    height: 4,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(color: VioraColors.neutral300, shape: StadiumBorder()),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _collapsed
                  ? const SizedBox(width: double.infinity)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                      child: AnimatedSwitcher(duration: const Duration(milliseconds: 180), child: content),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.eyebrow, required this.title, required this.subtitle, this.risk});

  final String eyebrow;
  final String title;
  final String subtitle;
  final PlotRisk? risk;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final risk = this.risk;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const VioraIcon(VioraIcons.locationOn, size: 16, color: VioraColors.neutral600),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                eyebrow.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(color: VioraColors.neutral600, letterSpacing: 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xs),
        Row(
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 32, height: 1.1, color: VioraColors.neutral900),
                ),
              ),
            ),
            if (risk != null) ...[const SizedBox(width: Spacing.sm), RiskLevelTag(risk: risk)],
          ],
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600),
        ),
        const SizedBox(height: Spacing.sm),
      ],
    );
  }
}

/// The three tiles of a group of plots and its action.
class _GroupBody extends StatelessWidget {
  const _GroupBody({required this.group, required this.actionLabel, required this.onAction});

  final RiskGroup group;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _TilesAndAction(
      tiles: [
        RiskPanelTile(
          figure: '${group.critical}',
          label: l10n.riskTileCritical,
          color: VioraColors.terracotta100,
          foreground: VioraColors.terracotta700,
          mark: const _Exclamation(),
        ),
        RiskPanelTile(
          figure: '${group.overloaded}',
          label: l10n.riskTileOverload,
          mark: const VioraIcon(VioraIcons.scale, size: 18, color: VioraColors.neutral900),
        ),
        RiskPanelTile(
          figure: '${group.withFrost}',
          label: l10n.riskTileFrost,
          color: VioraColors.harvest100,
          mark: const VioraIcon(VioraIcons.acUnit, size: 18, color: VioraColors.neutral900),
        ),
      ],
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

class _Exclamation extends StatelessWidget {
  const _Exclamation();

  @override
  Widget build(BuildContext context) => const Text(
        '!',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: VioraColors.terracotta700),
      );
}

class _TilesAndAction extends StatelessWidget {
  const _TilesAndAction({required this.tiles, required this.actionLabel, required this.onAction});

  final List<Widget> tiles;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Spacing.xs,
            children: [for (final tile in tiles) Expanded(child: tile)],
          ),
        ),
        const SizedBox(height: Spacing.sm),
        CooperativeActionPill(label: actionLabel, iconAsset: VioraIcons.arrowForward, onPressed: onAction),
      ],
    );
  }
}

class _NearbyPanel extends StatelessWidget {
  const _NearbyPanel({required this.state, required this.now, required this.onOpen});

  final RiskMapUiState state;
  final DateTime now;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final group = state.territory.nearby;
    final accuracy = state.location?.accuracyMeters.round() ?? 0;
    return Column(
      key: const ValueKey('nearby'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PanelHeader(
          eyebrow: l10n.riskNearEyebrow(accuracy),
          title: l10n.riskNearTitle,
          subtitle: _freshness(l10n, group, now),
          risk: group.level,
        ),
        _GroupBody(group: group, actionLabel: l10n.riskNearAction, onAction: onOpen),
      ],
    );
  }
}

String _freshness(AppLocalizations l10n, RiskGroup group, DateTime now) =>
    l10n.riskGroupFreshness(l10n.riskPlotCount(group.total), formatUpdatedAgo(l10n, group.evaluatedAt, now));

class _SectorPanel extends StatelessWidget {
  const _SectorPanel({required this.sector, required this.now, required this.onOpen});

  final RiskSector sector;
  final DateTime now;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      key: ValueKey('sector-${sector.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PanelHeader(
          eyebrow: l10n.riskSectorEyebrow,
          title: sector.name,
          subtitle: _freshness(l10n, sector.group, now),
          risk: sector.group.level,
        ),
        _GroupBody(group: sector.group, actionLabel: l10n.riskSectorAction, onAction: () => onOpen(sector.id)),
      ],
    );
  }
}

class _PlotPanel extends StatelessWidget {
  const _PlotPanel({required this.plot, required this.detail, required this.now, required this.onOpen});

  final RiskPlot plot;
  final RiskPlotDetail? detail;
  final DateTime now;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final overload = plot.overloadPercent;
    final prescribed = detail?.percentageToRemove;
    final closes = detail?.windowClosesOn;
    final daysLeft = closes == null ? null : daysUntil(closes, now);
    final parts = [
      plot.producerName,
      plot.sectorName ?? plot.proposedSectorName,
      if (plot.areaHa != null) l10n.riskHectares(formatHectares(plot.areaHa!, locale)),
    ].whereType<String>().where((part) => part.isNotEmpty);
    return Column(
      key: ValueKey('plot-${plot.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PanelHeader(
          eyebrow: l10n.riskPlotEyebrow,
          title: plot.name,
          subtitle: parts.join(' · '),
          risk: plot.risk,
        ),
        _TilesAndAction(
          tiles: [
            RiskPanelTile(
              figure: overload == null ? '—' : l10n.riskPercent(formatOneDecimal(overload, locale)),
              label: l10n.riskTileOverloadPlot,
              color: plot.isOverloaded ? VioraColors.terracotta100 : VioraColors.neutral0,
              foreground: plot.isOverloaded ? VioraColors.terracotta700 : VioraColors.neutral900,
              mark: plot.isOverloaded ? const _Exclamation() : null,
            ),
            RiskPanelTile(
              figure: prescribed == null ? '—' : l10n.riskPercent(formatOneDecimal(prescribed, locale)),
              label: l10n.riskTilePrescribed,
              mark: const VioraIcon(VioraIcons.scale, size: 18, color: VioraColors.neutral900),
            ),
            RiskPanelTile(
              figure: daysLeft == null || daysLeft < 0 ? '—' : '$daysLeft',
              label: l10n.riskTileDaysLeft,
              color: VioraColors.harvest100,
            ),
          ],
          actionLabel: l10n.riskPlotAction,
          onAction: () => onOpen(plot.id),
        ),
      ],
    );
  }
}

/// G21 · Elegir sector: the sectors in alphabetical order, when there is nothing near to summarize.
class _SectorPicker extends StatelessWidget {
  const _SectorPicker({required this.state, required this.onRetryGps, required this.onOpen});

  final RiskMapUiState state;
  final VoidCallback onRetryGps;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final territory = state.territory;
    final rows = <Widget>[
      for (final sector in territory.sectorsByName)
        _PickerRow(
          risk: sector.group.level,
          title: sector.name,
          subtitle: _sectorSummary(l10n, sector.group),
          onTap: () => onOpen(sector.id),
        ),
      if (territory.pending.total > 0)
        _PickerRow(
          risk: PlotRisk.noData,
          title: l10n.riskPendingTitle,
          subtitle: l10n.riskPlotCountShort(territory.pending.total),
          onTap: () => onOpen(RiskScopes.pending),
        ),
      if (territory.unassigned.total > 0)
        _PickerRow(
          risk: PlotRisk.noData,
          title: l10n.riskUnassignedTitle,
          subtitle: l10n.riskPlotCountShort(territory.unassigned.total),
          onTap: () => onOpen(RiskScopes.unassigned),
        ),
    ];
    return Column(
      key: const ValueKey('picker'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: VioraEditorialTitle(l10n.riskPickerTitle, fontSize: 30, lineHeight: 36)),
            if (state.gpsOff)
              TextButton.icon(
                onPressed: onRetryGps,
                icon: const VioraIcon(VioraIcons.locationOn, size: 16, color: VioraColors.neutral900),
                label: Text(l10n.commonRetry, style: Theme.of(context).textTheme.labelLarge),
              ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 250),
          child: VioraCard(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: rows.length,
              itemBuilder: (context, index) => rows[index],
              separatorBuilder: (context, index) => const Divider(height: 1, color: VioraColors.neutral200),
            ),
          ),
        ),
      ],
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({required this.risk, required this.title, required this.subtitle, required this.onTap});

  final PlotRisk risk;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        child: Row(
          children: [
            RiskDot(risk: risk, size: 10),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(subtitle, style: textTheme.bodySmall?.copyWith(color: VioraColors.neutral600)),
                ],
              ),
            ),
            const VioraIcon(VioraIcons.chevronRight, size: 22, color: VioraColors.neutral700),
          ],
        ),
      ),
    );
  }
}

String _sectorSummary(AppLocalizations l10n, RiskGroup group) {
  final count = l10n.riskPlotCountShort(group.total);
  if (group.critical > 0) return l10n.riskSummaryCritical(count, group.critical);
  if (group.moderate > 0) return l10n.riskSummaryModerate(count, group.moderate);
  if (group.noData > 0) return l10n.riskSummaryNoData(count);
  return l10n.riskSummaryOptimal(count);
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      key: const ValueKey('empty'),
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VioraEditorialTitle(l10n.riskEmptyTitle, fontSize: 30, lineHeight: 36),
          const SizedBox(height: Spacing.sm),
          Text(
            l10n.riskEmptyBody,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VioraColors.neutral700),
          ),
        ],
      ),
    );
  }
}

/// G20 · Lista de sectores, the most urgent first.
class _SectorListView extends StatelessWidget {
  const _SectorListView({required this.state, required this.top, required this.onRefresh, required this.onOpenScope});

  final RiskMapUiState state;
  final Widget top;
  final VoidCallback onRefresh;
  final ValueChanged<String> onOpenScope;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final territory = state.territory;
    final sectors = territory.sectorsByUrgency;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: VioraColors.green800,
          onRefresh: () async => onRefresh(),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.sm,
              Spacing.lg,
              VioraTabBarDefaults.contentBottomPadding + MediaQuery.paddingOf(context).bottom,
            ),
            children: [
              top,
              const SizedBox(height: Spacing.lg),
              VioraEditorialTitle(l10n.riskListTitle, fontSize: 44, lineHeight: 50),
              const SizedBox(height: Spacing.md),
              Align(alignment: Alignment.centerLeft, child: RiskCountsStrip(group: territory.valley)),
              const SizedBox(height: Spacing.md),
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.all(Spacing.xl),
                  child: Center(child: CircularProgressIndicator(color: VioraColors.green800)),
                )
              else if (state.plots.isEmpty)
                const _EmptyPanel(),
              for (var i = 0; i < sectors.length; i++) ...[
                _SectorCard(
                  sector: sectors[i],
                  mostCritical: i == 0 && sectors[i].group.level == PlotRisk.critical,
                  onTap: () => onOpenScope(sectors[i].id),
                ),
                const SizedBox(height: Spacing.sm),
              ],
              if (territory.pending.total > 0) ...[
                _UnplacedCard(
                  title: l10n.riskPendingTitle,
                  subtitle: l10n.riskPendingSummary(l10n.riskPlotCountShort(territory.pending.total)),
                  tag: l10n.riskReview,
                  onTap: () => onOpenScope(RiskScopes.pending),
                ),
                const SizedBox(height: Spacing.sm),
              ],
              if (territory.unassigned.total > 0)
                _UnplacedCard(
                  title: l10n.riskUnassignedTitle,
                  subtitle: l10n.riskPlotCountShort(territory.unassigned.total),
                  onTap: () => onOpenScope(RiskScopes.unassigned),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectorCard extends StatelessWidget {
  const _SectorCard({required this.sector, required this.mostCritical, required this.onTap});

  final RiskSector sector;
  final bool mostCritical;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final group = sector.group;
    final foreground = mostCritical ? VioraColors.neutral50 : VioraColors.neutral900;
    return VioraCard(
      color: mostCritical ? VioraColors.green900 : VioraColors.neutral0,
      padding: const EdgeInsets.fromLTRB(20, 16, Spacing.md, 16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mostCritical) ...[
            Row(
              children: [
                const VioraIcon(VioraIcons.locationOn, size: 14, color: VioraColors.harvest300),
                const SizedBox(width: Spacing.xxs),
                Text(
                  l10n.riskMostCritical.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(color: VioraColors.harvest300, letterSpacing: 1),
                ),
              ],
            ),
            const SizedBox(height: 2),
          ],
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sector.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 26, height: 1.15, color: foreground),
                    ),
                    Text(
                      _sectorSummary(l10n, group),
                      style: textTheme.bodySmall?.copyWith(color: foreground.withValues(alpha: 0.75)),
                    ),
                  ],
                ),
              ),
              if (group.withFrost > 0) ...[
                const SizedBox(width: Spacing.xs),
                const FrostMark(),
                const SizedBox(width: Spacing.xs),
              ],
              RiskLevelTag(risk: group.level),
              const SizedBox(width: Spacing.xs),
              VioraIcon(VioraIcons.chevronRight, size: 22, color: foreground),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          RiskShareBar(group: group),
        ],
      ),
    );
  }
}

/// «Por confirmar» and the plots without a sector: no color of their own, a plain grey bar.
class _UnplacedCard extends StatelessWidget {
  const _UnplacedCard({required this.title, required this.subtitle, this.tag, required this.onTap});

  final String title;
  final String subtitle;
  final String? tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tag = this.tag;
    return VioraCard(
      padding: const EdgeInsets.fromLTRB(20, 16, Spacing.md, 16),
      onTap: onTap,
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
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 26, height: 1.15, color: VioraColors.neutral900),
                    ),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral700)),
                  ],
                ),
              ),
              if (tag != null) RiskLevelTag(risk: PlotRisk.noData, label: tag),
              const SizedBox(width: Spacing.xs),
              const VioraIcon(VioraIcons.chevronRight, size: 22, color: VioraColors.neutral900),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          const SizedBox(
            height: 8,
            width: double.infinity,
            child: DecoratedBox(decoration: ShapeDecoration(color: VioraColors.neutral300, shape: StadiumBorder())),
          ),
        ],
      ),
    );
  }
}

/// G20 · Permiso de ubicación: what the GPS is for, before the system asks. It closes with true
/// to ask for the permission.
class LocationExplanationSheet extends StatelessWidget {
  const LocationExplanationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.lg, Spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: SizedBox(
                width: 36,
                height: 4,
                child: DecoratedBox(decoration: ShapeDecoration(color: VioraColors.neutral300, shape: StadiumBorder())),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            const _LocationRings(),
            const SizedBox(height: Spacing.md),
            VioraEditorialTitle(l10n.riskPermissionTitle, fontSize: 40, lineHeight: 46),
            const SizedBox(height: Spacing.md),
            Text(l10n.riskPermissionBody, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: VioraColors.neutral700)),
            const SizedBox(height: Spacing.lg),
            CooperativeActionPill(
              label: l10n.riskPermissionAllow,
              iconAsset: VioraIcons.arrowForward,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: Spacing.xs),
            Center(child: VioraTextButton(label: l10n.riskPermissionLater, onPressed: () => Navigator.of(context).pop(false))),
          ],
        ),
      ),
    );
  }
}

class _LocationRings extends StatelessWidget {
  const _LocationRings();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 96,
      child: DecoratedBox(
        decoration: ShapeDecoration(color: VioraColors.harvest100, shape: CircleBorder()),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: DecoratedBox(
            decoration: ShapeDecoration(color: Color(0xFFEFD274), shape: CircleBorder()),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: DecoratedBox(
                decoration: ShapeDecoration(color: VioraColors.green900, shape: CircleBorder()),
                child: Center(child: VioraIcon(VioraIcons.locationOn, size: 22, color: VioraColors.neutral50)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
