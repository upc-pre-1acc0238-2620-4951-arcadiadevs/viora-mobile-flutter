import 'package:flutter/material.dart';

import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/features/home/presentation/util/home_formatters.dart';

/// Avatar (iniciales o isotipo), saludo con fecha y campana de alertas.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.date,
    required this.onOpenAlerts,
    this.displayName,
    this.hasUnreadAlerts = false,
  });

  final DateTime date;
  final VoidCallback onOpenAlerts;
  final String? displayName;
  final bool hasUnreadAlerts;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final name = displayName?.trim() ?? '';

    return Row(
      children: [
        _Avatar(name: name),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? 'Hola' : 'Hola, ${name.split(' ').first}',
                style: textTheme.titleMedium?.copyWith(
                  letterSpacing: 0,
                  color: VioraColors.neutral900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${longDateEs(date)} · sincronizado',
                style: textTheme.bodySmall?.copyWith(
                  letterSpacing: 0,
                  color: VioraColors.neutral600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _AlertsBell(hasUnread: hasUnreadAlerts, onPressed: onOpenAlerts),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: VioraColors.green200,
        shape: CircleBorder(),
      ),
      child: SizedBox.square(
        dimension: Spacing.minTouchTarget,
        child: Center(
          child: name.isEmpty
              ? const VioraIcon(VioraIcons.isotype, color: VioraColors.green900)
              : Text(
                  initialsOf(name),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 18,
                        height: 22 / 18,
                        color: VioraColors.green900,
                      ),
                ),
        ),
      ),
    );
  }
}

class _AlertsBell extends StatelessWidget {
  const _AlertsBell({required this.hasUnread, required this.onPressed});

  final bool hasUnread;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Alertas',
      onTap: onPressed,
      excludeSemantics: true,
      child: Material(
        color: VioraColors.neutral0,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: Spacing.minTouchTarget,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const VioraIcon(
                  VioraIcons.notifications,
                  color: VioraColors.neutral900,
                ),
                if (hasUnread)
                  const Positioned(
                    top: 7,
                    right: 7,
                    child: SizedBox.square(
                      dimension: 8,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: VioraColors.terracotta500,
                          shape: CircleBorder(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
