import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';

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
  static const double gap = Spacing.sm;

  /// Bottom padding every tab screen must reserve so the floating bar never hides
  /// content.
  static const double contentBottomPadding = barHeight + bottomMargin + Spacing.md;
}

/// Floating navigation pill with an ivory bubble that slides to the selected
/// destination, plus the separate yellow "+" action (Figma: Editorial/Tapbar flotante).
///
/// Only the resting state exists so far. The compact state and the
/// "¿Qué vas a registrar?" menu are still pending.
class VioraTabBar extends StatelessWidget {
  const VioraTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.actionLabel,
    this.onActionPressed,
  });

  final List<TabBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final String actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: VioraTabBarDefaults.maxWidth),
          child: SizedBox(
            height: VioraTabBarDefaults.barHeight,
            child: Row(
              children: [
                Expanded(
                  child: _NavigationPill(
                    items: items,
                    selectedIndex: selectedIndex,
                    onItemSelected: onItemSelected,
                  ),
                ),
                const SizedBox(width: VioraTabBarDefaults.gap),
                _ActionButton(label: actionLabel, onPressed: onActionPressed),
              ],
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
        shape: StadiumBorder(),
        shadows: [
          BoxShadow(
            color: VioraColors.shadowTint.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = (constraints.maxWidth - inner * 2) / items.length;
          final bubbleSize = math.min(cellWidth, VioraTabBarDefaults.bubbleSize);

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeOutBack,
                left: inner + cellWidth * selectedIndex + (cellWidth - bubbleSize) / 2,
                top: (barHeight - bubbleSize) / 2,
                width: bubbleSize,
                height: bubbleSize,
                child: const DecoratedBox(
                  decoration: ShapeDecoration(color: VioraColors.neutral50, shape: StadiumBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: inner),
                child: Row(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Expanded(
                        child: _TabCell(
                          item: items[i],
                          selected: i == selectedIndex,
                          onTap: () => onItemSelected(i),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabCell extends StatelessWidget {
  const _TabCell({required this.item, required this.selected, required this.onTap});

  final TabBarItem item;
  final bool selected;
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
        child: SizedBox(
          height: VioraTabBarDefaults.barHeight,
          child: Center(
            // The icon darkens as the ivory bubble arrives.
            child: TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 260),
              tween: ColorTween(
                end: selected ? VioraColors.neutral900 : VioraColors.neutral50,
              ),
              builder: (context, color, _) => VioraIcon(item.iconAsset, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    const size = VioraTabBarDefaults.barHeight;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onPressed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: VioraColors.harvest300,
            shape: StadiumBorder(),
            shadows: [
              BoxShadow(
                color: VioraColors.shadowTint.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const SizedBox(
            width: size,
            height: size,
            child: Center(
              child: VioraIcon(VioraIcons.add, color: VioraColors.neutral900),
            ),
          ),
        ),
      ),
    );
  }
}
