import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';

/// One destination of [VioraTabBar]. [label] is only used for accessibility.
class TabBarItem {
  const TabBarItem({required this.iconAsset, required this.label});

  final String iconAsset;
  final String label;
}

abstract final class VioraTabBarDefaults {
  static const double barHeight = 72;
  static const double bottomMargin = Spacing.sm;
  static const double maxWidth = 354;
  static const double bubbleSize = 60;
  static const double barInnerPadding = 8;

  /// Height of the fade the shell paints behind the bar, from the bottom of the screen.
  static const double fadeHeight = 150;

  /// Bottom padding every tab screen must reserve so the floating bar never hides
  /// content.
  static const double contentBottomPadding = barHeight + bottomMargin + Spacing.md;
}

/// Floating navigation pill with an ivory bubble that slides to the selected
/// destination. The manager only consults and prioritizes, so the bar has no action
/// button. Max width 354, centered on wider screens.
class VioraTabBar extends StatelessWidget {
  const VioraTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final List<TabBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      // Takes only the height of the bar, so the shell can anchor it to the bottom.
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: VioraTabBarDefaults.maxWidth),
          child: SizedBox(
            height: VioraTabBarDefaults.barHeight,
            child: _NavigationPill(
              items: items,
              selectedIndex: selectedIndex,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationPill extends StatelessWidget {
  const _NavigationPill({
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final List<TabBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    const barHeight = VioraTabBarDefaults.barHeight;
    const inner = VioraTabBarDefaults.barInnerPadding;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: VioraColors.green900,
        shape: const StadiumBorder(),
        shadows: [
          BoxShadow(
            color: VioraColors.shadowTint.withValues(alpha: 0.12),
            blurRadius: 32,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final available = constraints.maxWidth - inner * 2;
          final bubbleSize = math.min(available / items.length, VioraTabBarDefaults.bubbleSize);
          // Distance between destinations: the first and last bubble touch the padding.
          final step = (available - bubbleSize) / (items.length - 1);
          double bubbleLeft(double position) => inner + step * position;

          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutBack,
            tween: Tween(end: selectedIndex.toDouble()),
            builder: (context, position, _) {
              // The curve overshoots; at the ends that would push the bubble off the bar.
              final bubblePosition = position.clamp(0.0, items.length - 1.0);
              return Stack(
                children: [
                  Positioned(
                    left: bubbleLeft(bubblePosition),
                    top: (barHeight - bubbleSize) / 2,
                    width: bubbleSize,
                    height: bubbleSize,
                    child: const DecoratedBox(
                      decoration: ShapeDecoration(
                        color: VioraColors.neutral50,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                  for (var i = 0; i < items.length; i++)
                    Positioned(
                      // Each touch area reaches halfway to its neighbors.
                      left: bubbleLeft(i.toDouble()) + (bubbleSize - step) / 2,
                      top: 0,
                      width: step,
                      height: barHeight,
                      child: _TabCell(
                        item: items[i],
                        selected: i == selectedIndex,
                        // How much of the bubble sits over this cell: the icon darkens
                        // exactly as the bubble arrives.
                        coverage: (1 - (i - bubblePosition).abs()).clamp(0.0, 1.0),
                        onTap: () => onItemSelected(i),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _TabCell extends StatelessWidget {
  const _TabCell({
    required this.item,
    required this.selected,
    required this.coverage,
    required this.onTap,
  });

  final TabBarItem item;
  final bool selected;
  final double coverage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: VioraIcon(
            item.iconAsset,
            color: Color.lerp(VioraColors.neutral50, VioraColors.neutral900, coverage),
          ),
        ),
      ),
    );
  }
}
