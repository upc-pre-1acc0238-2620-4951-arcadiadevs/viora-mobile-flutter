import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show MapboxOptions;

import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/locale/app_language.dart';
import 'package:viora/navigation/app_router.dart';

/// Public Mapbox token (pk.…), kept out of git like in the Kotlin app. It comes from
/// dart_defines.json: flutter run --dart-define-from-file=dart_defines.json
const _mapboxPublicToken = String.fromEnvironment('VIORA_MAPBOX_PUBLIC_TOKEN');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  MapboxOptions.setAccessToken(_mapboxPublicToken);
  setupDependencies();
  openSignInWhenSessionExpires();
  forgetAccountDataWhenSessionEnds();
  // The saved language has to be known before the first frame.
  await getIt<AppLanguageCubit>().load();
  runApp(const VioraApp());
}

class VioraApp extends StatelessWidget {
  const VioraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AppLanguageCubit>(),
      child: BlocBuilder<AppLanguageCubit, AppLanguage?>(
        builder: (context, language) => _app(language),
      ),
    );
  }

  Widget _app(AppLanguage? language) {
    return MaterialApp.router(
      title: 'Viora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Without a choice in the app, the language follows the phone: es-PE resolves to Spanish,
      // and any language the app doesn't have falls back to the first one in the list, English.
      locale: language?.locale,
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
