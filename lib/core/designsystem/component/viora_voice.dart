import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/typography.dart';

/// The voice of Viora: the guide mark plus one italic line. Use it at most once per
/// screen, with two lines at most, and never in critical alerts.
class VioraVoice extends StatelessWidget {
  const VioraVoice({super.key, required this.text, this.markSize = 22});

  final String text;
  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The mark keeps its own color, so it doesn't go through VioraIcon's tint.
        SvgPicture.asset(VioraIcons.brote, width: markSize, height: markSize),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: vioraNewsreaderItalic.copyWith(
              fontSize: 18,
              height: 24 / 18,
              color: VioraColors.neutral700,
            ),
          ),
        ),
      ],
    );
  }
}
