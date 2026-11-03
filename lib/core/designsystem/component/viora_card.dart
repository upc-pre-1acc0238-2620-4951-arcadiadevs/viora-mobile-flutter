import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

/// Rounded block that groups content. It's white on the warm background by default;
/// use [color] for the blocks that carry meaning. With [onTap] the whole card reacts.
class VioraCard extends StatelessWidget {
  const VioraCard({
    super.key,
    required this.child,
    this.color = VioraColors.neutral0,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
