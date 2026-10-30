import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

/// Radios de Viora: chip 8, tarjeta 12, sheet 28; botones y chips usan la píldora.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double xl = 28;
}

/// Tema de Viora (tokens portados desde el proyecto Android).
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: vioraLightScheme,
        // Las pantallas de Figma usan neutral100 de fondo; surface (neutral50) es para tarjetas.
        scaffoldBackgroundColor: VioraColors.neutral100,
        textTheme: vioraTextTheme.apply(
          bodyColor: vioraLightScheme.onSurface,
          displayColor: vioraLightScheme.onSurface,
        ),
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
