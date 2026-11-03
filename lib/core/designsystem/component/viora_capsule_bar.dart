import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/theme/colors.dart';

/// One part of a [VioraSegmentedBar].
class VioraBarSegment {
  const VioraBarSegment({required this.value, required this.color});

  final num value;
  final Color color;
}

/// Row of capsules whose widths follow the share of each segment. Segments without a
/// value take no space.
class VioraSegmentedBar extends StatelessWidget {
  const VioraSegmentedBar({
    super.key,
    required this.segments,
    this.height = 14,
    this.gap = 4,
  });

  final List<VioraBarSegment> segments;
  final double height;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final visible = segments.where((segment) => segment.value > 0).toList();
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: gap,
        children: [
          for (final segment in visible)
            Expanded(
              flex: (segment.value * 1000).round(),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: segment.color,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Capsule progress bar. [value] goes from 0 to 1.
class VioraProgressBar extends StatelessWidget {
  const VioraProgressBar({
    super.key,
    required this.value,
    this.height = 10,
    this.color = VioraColors.green800,
    this.trackColor = VioraColors.neutral0,
  });

  final double value;
  final double height;
  final Color color;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(color: trackColor, shape: const StadiumBorder()),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            heightFactor: 1,
            child: DecoratedBox(
              decoration: ShapeDecoration(color: color, shape: const StadiumBorder()),
            ),
          ),
        ),
      ),
    );
  }
}
