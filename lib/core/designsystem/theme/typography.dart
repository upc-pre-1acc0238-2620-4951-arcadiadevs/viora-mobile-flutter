import 'package:flutter/material.dart';

/// Families bundled in `assets/fonts` (SIL OFL, licenses in `assets/licenses`).
abstract final class VioraFonts {
  /// Brand serif for expressive moments (Display and Headline roles).
  static const newsreader = 'Newsreader';

  /// Interface font for all functional text (Title, Body and Label).
  static const roboto = 'Roboto';
}

// Both fonts are variable: the weight is applied as a variation of the `wght` axis.
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

/// Material 3 scale adapted to Viora: Newsreader for Display/Headline and Roboto for
/// the rest. Display sizes are reduced (48/40/32) because Newsreader is wider than
/// Roboto on compact screens. Body Large (16) is the default reading size; nothing
/// goes below 11.
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

/// Italic style for the emphasized part of expressive text (e.g. "Hoy toca *aclarar.*").
/// Merge it with a Display or Headline style.
const TextStyle vioraNewsreaderItalic = TextStyle(
  fontFamily: VioraFonts.newsreader,
  fontStyle: FontStyle.italic,
);
