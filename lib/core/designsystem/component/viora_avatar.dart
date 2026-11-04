import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

/// Circle with the initials of [name], or the isotype while the name isn't known.
class VioraAvatar extends StatelessWidget {
  const VioraAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.background = VioraColors.terracotta100,
  });

  final String name;
  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsOf(name);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: const CircleBorder(),
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: initials.isEmpty
              ? const VioraIcon(VioraIcons.isotype, color: VioraColors.terracotta700)
              : Text(
                  initials,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 18,
                        height: 22 / 18,
                        fontWeight: FontWeight.w500,
                        fontVariations: const [FontVariation.weight(500)],
                        color: VioraColors.terracotta700,
                      ),
                ),
        ),
      ),
    );
  }

  /// "Diana Li" -> "DL".
  static String _initialsOf(String name) => name
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();
}
