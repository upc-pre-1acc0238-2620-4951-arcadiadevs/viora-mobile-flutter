import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

/// Ivory pill with a label and a yellow circle with an arrow. It stands out on the
/// dark and colored blocks. The [dark] version, green with an ivory circle, sits on the
/// light cards of the alerts («Abrir sector»).
class VioraArrowButton extends StatelessWidget {
  const VioraArrowButton({super.key, required this.label, required this.onPressed, this.dark = false});

  final String label;
  final VoidCallback onPressed;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: dark ? VioraColors.green900 : VioraColors.neutral50,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.fromLTRB(dark ? 18 : 20, 6, 6, 6),
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
                        color: dark ? VioraColors.neutral50 : VioraColors.green900,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: dark ? VioraColors.neutral50 : VioraColors.harvest300,
                  shape: const CircleBorder(),
                ),
                child: SizedBox.square(
                  dimension: dark ? 32 : 36,
                  child: const Center(
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
