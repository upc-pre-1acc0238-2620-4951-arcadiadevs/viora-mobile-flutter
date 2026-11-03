import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';

/// White circular icon button with the minimum touch target. [showBadge] draws the
/// notice dot on the icon.
class VioraCircleButton extends StatelessWidget {
  const VioraCircleButton({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.onPressed,
    this.showBadge = false,
  });

  final String iconAsset;
  final String label;
  final VoidCallback onPressed;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: Material(
        color: VioraColors.neutral0,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: Spacing.minTouchTarget,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VioraIcon(iconAsset, color: VioraColors.neutral900),
                if (showBadge)
                  const Positioned(
                    top: 7,
                    right: 7,
                    child: SizedBox.square(
                      dimension: 8,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: VioraColors.terracotta500,
                          shape: CircleBorder(),
                        ),
                      ),
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
