import 'package:flutter/material.dart';

import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/navigation/app_router.dart';

void main() {
  setupDependencies();
  runApp(const VioraApp());
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
