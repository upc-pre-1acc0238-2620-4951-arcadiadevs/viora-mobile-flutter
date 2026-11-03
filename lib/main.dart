import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/navigation/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      // The language follows the phone: es-PE resolves to Spanish, and any language
      // the app doesn't have falls back to the first one in the list, English.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      // MaterialApp sets its own style while building, so a style set in main() is lost.
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.systemBars,
        // What a crossfade between two screens shows through; without it the fade dips to black.
        child: ColoredBox(color: Theme.of(context).scaffoldBackgroundColor, child: child!),
      ),
    );
  }
}
