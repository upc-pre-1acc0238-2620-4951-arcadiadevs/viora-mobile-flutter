import 'package:flutter/material.dart';

/// Familias empaquetadas en `assets/fonts` (SIL OFL, licencias en `assets/licenses`).
abstract final class VioraFonts {
  /// Serif de marca para momentos expresivos (roles Display y Headline).
  static const newsreader = 'Newsreader';

  /// Fuente de interfaz para todo texto funcional (Title, Body y Label).
  static const roboto = 'Roboto';
}

// Las dos fuentes son variables: el peso se aplica como variación del eje `wght`.
TextStyle _style(
  String family, {
  required double size,
  required double lineHeight,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 0,
}) {
  return TextStyle(
    fontFamily: family,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    fontVariations: [FontVariation.weight(weight.value.toDouble())],
  );
}

TextStyle _serif(double size, double lineHeight, {double letterSpacing = 0}) =>
    _style(VioraFonts.newsreader, size: size, lineHeight: lineHeight, letterSpacing: letterSpacing);

TextStyle _sans(
  double size,
  double lineHeight, {
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 0,
}) =>
    _style(VioraFonts.roboto, size: size, lineHeight: lineHeight, weight: weight, letterSpacing: letterSpacing);

/// Escala Material 3 adaptada a Viora (equivale a `AppTypography` en Type.kt):
/// Newsreader para Display/Headline y Roboto para el resto. Los Display se reducen
/// (48/40/32) porque Newsreader es más ancha que Roboto en pantallas compactas.
/// Body Large (16) es el tamaño de lectura por defecto; nada baja de 11.
final TextTheme vioraTextTheme = TextTheme(
  displayLarge: _serif(48, 52, letterSpacing: -0.5),
  displayMedium: _serif(40, 44, letterSpacing: -0.25),
  displaySmall: _serif(32, 38),
  headlineLarge: _serif(28, 34),
  headlineMedium: _serif(24, 30),
  headlineSmall: _serif(20, 26),
  titleLarge: _sans(20, 26, weight: FontWeight.w500),
  titleMedium: _sans(16, 22, weight: FontWeight.w500, letterSpacing: 0.15),
  titleSmall: _sans(14, 20, weight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: _sans(16, 24, letterSpacing: 0.25),
  bodyMedium: _sans(14, 20, letterSpacing: 0.25),
  bodySmall: _sans(12, 16, letterSpacing: 0.4),
  labelLarge: _sans(14, 20, weight: FontWeight.w500, letterSpacing: 0.1),
  labelMedium: _sans(12, 16, weight: FontWeight.w500, letterSpacing: 0.5),
  labelSmall: _sans(11, 16, weight: FontWeight.w500, letterSpacing: 0.5),
);
