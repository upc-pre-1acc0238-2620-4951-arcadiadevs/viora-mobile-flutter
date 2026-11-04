import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/typography.dart';

/// Editorial title: a serif text where the parts between asterisks go in italics
/// ("Te aviso solo\nlo *importante*.").
class VioraEditorialTitle extends StatelessWidget {
  const VioraEditorialTitle(
    this.text, {
    super.key,
    this.fontSize = 36,
    this.lineHeight = 40,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final double fontSize;
  final double lineHeight;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.displaySmall?.copyWith(
          fontSize: fontSize,
          height: lineHeight / fontSize,
          letterSpacing: -fontSize * 0.02,
          color: VioraColors.neutral900,
        );
    final parts = text.split('*');
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(text: parts[i], style: i.isOdd ? vioraNewsreaderItalic : null),
        ],
      ),
      style: style,
      textAlign: textAlign,
    );
  }
}

/// Small uppercase label above a title, with a colored dot.
class VioraEyebrow extends StatelessWidget {
  const VioraEyebrow(this.text, {super.key, this.dotColor = VioraColors.green800});

  final String text;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 6,
          child: DecoratedBox(
            decoration: ShapeDecoration(color: dotColor, shape: const CircleBorder()),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.54,
                color: VioraColors.neutral700,
              ),
        ),
      ],
    );
  }
}

/// Scaffold of the forms and wizards: top bar with back arrow and step, scrolling content
/// and the actions pinned at the bottom, above the keyboard.
class VioraFormFrame extends StatelessWidget {
  const VioraFormFrame({
    super.key,
    required this.children,
    this.onBack,
    this.backLabel,
    this.stepLabel,
    this.footer = const [],
  });

  final List<Widget> children;
  final VoidCallback? onBack;
  final String? backLabel;
  final String? stepLabel;
  final List<Widget> footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VioraColors.neutral50,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 24, 8),
              child: SizedBox(
                height: 44,
                child: Row(
                  children: [
                    if (onBack != null)
                      IconButton(
                        tooltip: backLabel,
                        onPressed: onBack,
                        icon: const VioraIcon(VioraIcons.arrowBack, color: VioraColors.neutral900),
                      ),
                    const Spacer(),
                    if (stepLabel != null)
                      Text(
                        stepLabel!,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontSize: 13,
                              letterSpacing: 0.78,
                              color: VioraColors.neutral600,
                            ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                // The scrolled content stops short of the bar and the footer, instead of touching them.
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Column(mainAxisSize: MainAxisSize.min, children: footer),
            ),
          ],
        ),
      ),
    );
  }
}
