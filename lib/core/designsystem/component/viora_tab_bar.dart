import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import 'viora_icon.dart';

/// Un destino de [VioraTabBar]. [label] se usa solo para accesibilidad.
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

  /// Padding inferior que toda pantalla de tab debe reservar para que la barra
  /// flotante nunca tape el contenido (equivale a `ContentBottomPadding`).
  static const double contentBottomPadding = barHeight + bottomMargin + Spacing.md;
}

/// Píldora de navegación flotante: una burbuja marfil se desliza al destino
/// seleccionado, más el botón amarillo "+" aparte (Figma: Editorial/Tapbar flotante).
///
/// Versión base: solo el estado de reposo. Los estados `Compact` y `Actions`
/// (menú "¿Qué vas a registrar?") del Android quedan pendientes.
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
            // El icono se oscurece al llegar la burbuja marfil.
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
