import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

/// Color of a [VioraStatusTag]: [alert] asks for attention, [info] only informs.
enum VioraTagTone {
  alert(VioraColors.terracotta100, VioraColors.terracotta700),
  info(VioraColors.green200, VioraColors.green800),

  /// Something to keep an eye on soon, such as a code about to expire.
  pending(VioraColors.harvest100, VioraColors.harvest800),

  /// Plain information without a judgement, such as missing data.
  neutral(VioraColors.neutral100, VioraColors.neutral700);

  const VioraTagTone(this.background, this.foreground);

  final Color background;
  final Color foreground;
}

/// Small capsule with a status or a reason, with an optional icon.
class VioraStatusTag extends StatelessWidget {
  const VioraStatusTag({
    super.key,
    required this.label,
    this.tone = VioraTagTone.info,
    this.iconAsset,
  });

  final String label;
  final VioraTagTone tone;
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    final iconAsset = this.iconAsset;
    return DecoratedBox(
      decoration: ShapeDecoration(color: tone.background, shape: const StadiumBorder()),
      child: Padding(
        padding: EdgeInsets.fromLTRB(iconAsset == null ? 10 : 8, 4, 10, 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconAsset != null) ...[
              VioraIcon(iconAsset, size: 14, color: tone.foreground),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      height: 14 / 11,
                      letterSpacing: 0,
                      color: tone.foreground,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
