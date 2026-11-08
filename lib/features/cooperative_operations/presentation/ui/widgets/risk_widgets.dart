import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:viora/core/designsystem/component/viora_capsule_bar.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/theme/typography.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_territory.dart';
import 'package:viora/features/cooperative_operations/presentation/risk_map_features.dart';

String riskLevelLabel(AppLocalizations l10n, PlotRisk risk) => switch (risk) {
      PlotRisk.critical => l10n.riskLevelCritical,
      PlotRisk.moderate => l10n.riskLevelModerate,
      PlotRisk.optimal => l10n.riskOptimal,
      PlotRisk.noData => l10n.riskLevelNoData,
    };

/// The pill of a level: «Crítico» solid, «Moderado» and «Óptimo» soft, «Sin datos» dashed.
class RiskLevelTag extends StatelessWidget {
  const RiskLevelTag({super.key, required this.risk, this.label});

  final PlotRisk risk;

  /// Replaces the level's name: «Revisar».
  final String? label;

  @override
  Widget build(BuildContext context) {
    final text = label ?? riskLevelLabel(AppLocalizations.of(context), risk);
    final (background, foreground) = switch (risk) {
      PlotRisk.critical => (VioraColors.terracotta500, VioraColors.neutral0),
      PlotRisk.moderate => (VioraColors.harvest100, VioraColors.neutral900),
      PlotRisk.optimal => (VioraColors.green200, VioraColors.neutral900),
      PlotRisk.noData => (Colors.transparent, VioraColors.neutral900),
    };
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: foreground)),
    );
    if (risk == PlotRisk.noData) return CustomPaint(painter: const _DashedPillPainter(), child: content);
    return DecoratedBox(
      decoration: ShapeDecoration(color: background, shape: const StadiumBorder()),
      child: content,
    );
  }
}

class _DashedPillPainter extends CustomPainter {
  const _DashedPillPainter({this.shape = _DashedShape.pill});

  final _DashedShape shape;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = Path();
    if (shape == _DashedShape.circle) {
      path.addOval(rect.deflate(0.75));
    } else {
      path.addRRect(RRect.fromRectAndRadius(rect.deflate(0.75), Radius.circular(size.height / 2)));
    }
    canvas.drawPath(
      dashPath(path, dashArray: CircularIntervalList<double>(const [4, 3])),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = VioraColors.neutral600,
    );
  }

  @override
  bool shouldRepaint(_DashedPillPainter oldDelegate) => oldDelegate.shape != shape;
}

enum _DashedShape { pill, circle }

/// The dashed circle around an icon of the plots without data.
class DashedCircle extends StatelessWidget {
  const DashedCircle({super.key, required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: const _DashedPillPainter(shape: _DashedShape.circle),
        child: SizedBox.square(dimension: size, child: Center(child: child)),
      );
}

/// «9 críticas · 14 moderadas · 31 óptimas · 6 sin datos».
class RiskCountsStrip extends StatelessWidget {
  const RiskCountsStrip({super.key, required this.group, this.background = VioraColors.neutral0});

  final RiskGroup group;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: ShapeDecoration(color: background, shape: const StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 14,
            children: [
              _Count(risk: PlotRisk.critical, value: group.critical, label: l10n.riskCountCritical),
              _Count(risk: PlotRisk.moderate, value: group.moderate, label: l10n.riskCountModerate),
              _Count(risk: PlotRisk.optimal, value: group.optimal, label: l10n.riskCountOptimal),
              _Count(risk: PlotRisk.noData, value: group.noData, label: l10n.riskCountNoData),
            ],
          ),
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.risk, required this.value, required this.label});

  final PlotRisk risk;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(color: VioraColors.neutral900);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RiskDot(risk: risk),
        const SizedBox(width: 6),
        Text('$value', style: style?.copyWith(fontWeight: FontWeight.w600, fontVariations: const [FontVariation.weight(600)])),
        const SizedBox(width: 4),
        Text(label, style: style),
      ],
    );
  }
}

class RiskDot extends StatelessWidget {
  const RiskDot({super.key, required this.risk, this.size = 8});

  final PlotRisk risk;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size,
        child: DecoratedBox(decoration: ShapeDecoration(color: riskColor(risk), shape: const CircleBorder())),
      );
}

/// The bar of a sector: how many plots of each color, grey included.
class RiskShareBar extends StatelessWidget {
  const RiskShareBar({super.key, required this.group, this.colors, this.height = 8});

  final RiskGroup group;

  /// In order critical, moderate, optimal and without data; by default each risk's color.
  final List<Color>? colors;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = this.colors ??
        const [VioraColors.terracotta500, VioraColors.harvest400, VioraColors.green700, VioraColors.neutral300];
    return VioraSegmentedBar(
      height: height,
      segments: [
        VioraBarSegment(value: group.critical, color: colors[0]),
        VioraBarSegment(value: group.moderate, color: colors[1]),
        VioraBarSegment(value: group.optimal, color: colors[2]),
        VioraBarSegment(value: group.noData, color: colors[3]),
      ],
    );
  }
}

/// The round yellow mark with a snowflake.
class FrostMark extends StatelessWidget {
  const FrostMark({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: const ShapeDecoration(color: VioraColors.harvest100, shape: CircleBorder()),
          child: Center(child: VioraIcon(VioraIcons.acUnit, size: size * 0.56, color: VioraColors.neutral900)),
        ),
      );
}

/// A big figure and its short label in one of the three tiles of the G20 panel.
class RiskPanelTile extends StatelessWidget {
  const RiskPanelTile({
    super.key,
    required this.figure,
    required this.label,
    this.color = VioraColors.neutral0,
    this.foreground = VioraColors.neutral900,
    this.mark,
  });

  final String figure;
  final String label;
  final Color color;
  final Color foreground;

  /// What goes next to the figure: an icon or an exclamation.
  final Widget? mark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      figure,
                      style: TextStyle(fontFamily: VioraFonts.newsreader, fontSize: 28, height: 1.1, color: foreground),
                    ),
                  ),
                ),
                if (mark != null) ...[const SizedBox(width: Spacing.xs), mark!],
              ],
            ),
            const SizedBox(height: Spacing.xxs),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: foreground, height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}

/// The pill of a sector on the map: dark when it's the chosen or most critical one, white otherwise.
class SectorChip extends StatelessWidget {
  const SectorChip({
    super.key,
    required this.name,
    required this.detail,
    required this.risk,
    required this.dark,
    required this.faded,
    required this.onTap,
  });

  final String name;
  final String detail;
  final PlotRisk risk;
  final bool dark;
  final bool faded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final foreground = dark ? VioraColors.neutral50 : VioraColors.neutral900;
    return Opacity(
      opacity: faded ? 0.5 : 1,
      child: Semantics(
        button: true,
        label: '$name, $detail',
        excludeSemantics: true,
        child: Material(
          color: dark ? VioraColors.green900 : VioraColors.neutral0,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RiskDot(risk: risk),
                  const SizedBox(width: 6),
                  Text(name, style: textTheme.labelMedium?.copyWith(color: foreground)),
                  const SizedBox(width: 6),
                  Text(detail, style: textTheme.bodySmall?.copyWith(color: foreground.withValues(alpha: 0.75))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// «Tú»: the yellow dot with its halo and a dark label beside it.
class YouMarker extends StatelessWidget {
  const YouMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: 56,
        height: 56,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox.square(
              dimension: 56,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: VioraColors.harvest300.withValues(alpha: 0.35),
                  shape: const CircleBorder(),
                ),
              ),
            ),
            const SizedBox.square(
              dimension: 18,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: VioraColors.harvest400,
                  shape: CircleBorder(side: BorderSide(color: VioraColors.neutral0, width: 2.5)),
                ),
              ),
            ),
            Positioned(
              left: 44,
              child: DecoratedBox(
                decoration: const ShapeDecoration(color: VioraColors.green900, shape: StadiumBorder()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text(
                    AppLocalizations.of(context).riskYou,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: VioraColors.neutral50),
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
