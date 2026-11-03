import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';

/// Section title of the Home and of listings: a serif title, an optional count badge
/// and an optional text action with a chevron, at least 48 tall to be easy to hit.
class VioraSectionHeader extends StatelessWidget {
  const VioraSectionHeader({
    super.key,
    required this.title,
    this.count,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final int? count;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final count = this.count;
    final actionLabel = this.actionLabel;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineMedium?.copyWith(letterSpacing: -0.24),
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: Spacing.xs),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: VioraColors.terracotta100,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    child: Text(
                      '$count',
                      style: textTheme.labelMedium?.copyWith(color: VioraColors.terracotta700),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          InkWell(
            onTap: onAction,
            borderRadius: BorderRadius.circular(Spacing.xs),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: Spacing.minTouchTarget),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel,
                    style: textTheme.titleSmall?.copyWith(color: VioraColors.green800),
                  ),
                  const SizedBox(width: 2),
                  const VioraIcon(
                    VioraIcons.chevronRight,
                    size: 20,
                    color: VioraColors.green800,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
