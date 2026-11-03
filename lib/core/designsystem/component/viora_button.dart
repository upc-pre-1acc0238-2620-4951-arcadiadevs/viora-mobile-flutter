import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

/// Full-width pill button. Use one primary action per screen; [VioraTextButton] is for
/// skipping and links.
class VioraButton extends StatelessWidget {
  const VioraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final bool loading;

  static const height = 56.0;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      onTap: enabled ? onPressed : null,
      child: Material(
        color: onPressed == null ? VioraColors.neutral200 : VioraColors.green900,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Center(
              child: loading
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: VioraColors.neutral100,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        letterSpacing: 0.16,
                        fontWeight: FontWeight.w500,
                        fontVariations: const [FontVariation.weight(500)],
                        color: onPressed == null
                            ? VioraColors.neutral500
                            : VioraColors.neutral100,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class VioraTextButton extends StatelessWidget {
  const VioraTextButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: VioraButton.height,
      width: double.infinity,
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              letterSpacing: 0.16,
              fontWeight: FontWeight.w500,
              fontVariations: const [FontVariation.weight(500)],
              color: onPressed == null ? VioraColors.neutral500 : VioraColors.neutral900,
            ),
          ),
        ),
      ),
    );
  }
}
