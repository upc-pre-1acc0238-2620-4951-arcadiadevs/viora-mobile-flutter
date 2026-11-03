import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/typography.dart';

/// Viora corner radii: chip 8, card 12, sheet 28. Buttons and the search field use
/// the pill shape.
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double xl = 28;
}

/// Viora theme, built from the brand color and typography tokens.
abstract final class AppTheme {
  /// Transparent system bars with dark icons: the app is light-only, so the icons stay
  /// dark even if the phone is in dark mode.
  static const SystemUiOverlayStyle systemBars = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );

  // Figma screens use neutral100 as background; surface (neutral50) is for cards.
  static ThemeData get light => _build(vioraLightScheme, VioraColors.neutral100);

  static ThemeData get dark => _build(vioraDarkScheme, vioraDarkScheme.surface);

  static ThemeData _build(ColorScheme scheme, Color background) => ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: background,
        textTheme: vioraTextTheme.apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        ),
        appBarTheme: const AppBarTheme(systemOverlayStyle: systemBars),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: const Size(64, 48),
          ),
        ),
      );
}
