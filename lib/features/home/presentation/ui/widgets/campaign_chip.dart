import 'package:flutter/material.dart';

import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';

/// Chip de la campaña vigente ("Campaña 2026").
class CampaignChip extends StatelessWidget {
  const CampaignChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: VioraColors.green900,
        shape: StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: Spacing.sm,
          right: 14,
          top: Spacing.xs,
          bottom: Spacing.xs,
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 13,
                height: 18 / 13,
                letterSpacing: 0,
                color: VioraColors.neutral50,
              ),
        ),
      ),
    );
  }
}
