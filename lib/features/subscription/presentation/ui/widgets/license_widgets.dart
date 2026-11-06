import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/features/subscription/domain/valueobject/manager_code.dart';

/// Horizontal margin of the license screens.
const licenseGutter = 24.0;

/// The guide of Viora at rest over its soft shape.
class LicenseArt extends StatelessWidget {
  const LicenseArt({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset('assets/images/ill_license_shape.svg', width: 220, height: 200),
          SvgPicture.asset(VioraIcons.brote, width: 120, height: 120),
        ],
      ),
    );
  }
}

/// The art, eyebrow, title and body that open every license screen, centered.
class LicenseHeadline extends StatelessWidget {
  const LicenseHeadline({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.body,
    this.bodyIsError = false,
  });

  final String eyebrow;
  final String title;
  final String body;

  /// The body explains what went wrong, so it is announced when it changes.
  final bool bodyIsError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LicenseArt(),
        const SizedBox(height: 28),
        VioraEyebrow(eyebrow),
        const SizedBox(height: 9),
        VioraEditorialTitle(title, fontSize: 40, lineHeight: 44, textAlign: TextAlign.center),
        const SizedBox(height: Spacing.xs),
        SizedBox(
          width: 320,
          child: Semantics(
            liveRegion: bodyIsError,
            child: Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    height: 22 / 15,
                    letterSpacing: 0,
                    color: VioraColors.neutral700,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Label and value rows between thin lines, such as what a license covers.
class LicenseFacts extends StatelessWidget {
  const LicenseFacts({super.key, required this.facts});

  final List<(String, String)> facts;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const line = Divider(height: 1, thickness: 1, color: VioraColors.neutral200);
    return Column(
      children: [
        line,
        for (final (label, value) in facts) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 16 / 14,
                    letterSpacing: 0,
                    color: VioraColors.neutral600,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 16 / 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      fontVariations: const [FontVariation.weight(500)],
                      color: VioraColors.neutral900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          line,
        ],
      ],
    );
  }
}

/// White pill where the manager types the code; its border turns terracotta when the code
/// can't be used.
class LicenseCodeField extends StatefulWidget {
  const LicenseCodeField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.hint,
    this.isError = false,
    this.onSubmitted,
  });

  final String value;
  final ValueChanged<String> onChanged;

  /// What screen readers announce; the field itself shows only [hint].
  final String label;
  final String hint;
  final bool isError;
  final VoidCallback? onSubmitted;

  @override
  State<LicenseCodeField> createState() => _LicenseCodeFieldState();
}

class _LicenseCodeFieldState extends State<LicenseCodeField> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(LicenseCodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The state normalizes what is typed: upper case, without spaces.
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          letterSpacing: 0,
          color: VioraColors.neutral900,
        );
    return Semantics(
      label: widget.label,
      textField: true,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        alignment: Alignment.centerLeft,
        decoration: ShapeDecoration(
          color: VioraColors.neutral0,
          shape: StadiumBorder(
            side: widget.isError
                ? const BorderSide(color: VioraColors.terracotta500, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          onSubmitted: (_) => widget.onSubmitted?.call(),
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\- ]')),
            // Room for a space or two pasted along with the code; the state trims it.
            LengthLimitingTextInputFormatter(ManagerCode.length + 2),
          ],
          cursorColor: VioraColors.green900,
          style: style,
          // Keeps the actions under the field in sight over the keyboard.
          scrollPadding: const EdgeInsets.fromLTRB(20, 20, 20, 160),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            hintText: widget.hint,
            hintStyle: style?.copyWith(color: VioraColors.neutral500),
          ),
        ),
      ),
    );
  }
}

/// The white capsule of an active license, with its check.
class LicenseActiveTag extends StatelessWidget {
  const LicenseActiveTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(color: VioraColors.neutral0, shape: StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VioraIcon(VioraIcons.taskAlt, size: 16, color: VioraColors.green900),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w500,
                fontVariations: [FontVariation.weight(500)],
                color: VioraColors.green900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
