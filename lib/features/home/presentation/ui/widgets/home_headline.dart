import 'package:flutter/material.dart';
import 'package:viora/core/designsystem/theme/typography.dart';

/// Two-line editorial headline: lead plus italic emphasis ("Tu campo, *hoy.*").
class HomeHeadline extends StatelessWidget {
  const HomeHeadline({super.key, required this.lead, required this.emphasis});

  final String lead;
  final String emphasis;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.displayMedium?.copyWith(
          fontSize: 44,
          height: 46 / 44,
          letterSpacing: -1.1,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lead, style: style),
        Text(emphasis, style: style?.merge(vioraNewsreaderItalic)),
      ],
    );
  }
}
