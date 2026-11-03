import 'package:flutter/material.dart';

import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';

/// Cuerpo temporal de un tab cuyo feature aún no se construye.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: VioraTabBarDefaults.contentBottomPadding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: theme.textTheme.displaySmall),
                const SizedBox(height: Spacing.xs),
                Text(
                  'Próximamente',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
