import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/designsystem/theme/app_theme.dart';
import 'navigation/app_router.dart';

void main() {
  runApp(const ProviderScope(child: VioraApp()));
}

class VioraApp extends StatelessWidget {
  const VioraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Viora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
