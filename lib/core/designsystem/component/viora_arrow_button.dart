import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

/// Ivory pill with a label and a yellow circle with an arrow. It stands out on the
/// dark and colored blocks.
class VioraArrowButton extends StatelessWidget {
  const VioraArrowButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: VioraColors.neutral50,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 6, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: 0,
                        color: VioraColors.green900,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              const DecoratedBox(
                decoration: ShapeDecoration(
                  color: VioraColors.harvest300,
                  shape: CircleBorder(),
                ),
                child: SizedBox.square(
                  dimension: 36,
                  child: Center(
                    child: VioraIcon(VioraIcons.arrowForward, color: VioraColors.neutral900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
