import 'package:flutter/material.dart';

/// Brand colors and primitives from Figma ("Viora202602_Mobile_App"). Use these
/// primitives for design surfaces that have no Material 3 role (Home phase cards,
/// floating tab bar, etc.).
abstract final class VioraColors {
  // Brand.
  static const forest = Color(0xFF2E4A3A);
  static const shadow = Color(0xFF1F2C26);
  static const harvest = Color(0xFFE8B923);
  static const tierra = Color(0xFFC15A2E);

  // Primitives.
  static const green100 = Color(0xFFE9EEEB);
  static const green200 = Color(0xFFD4DBD7);
  static const green700 = Color(0xFF485A4F);
  static const green800 = forest;
  static const green900 = shadow;
  static const harvest100 = Color(0xFFFFF0B4);
  static const harvest300 = harvest;
  static const harvest400 = Color(0xFFCDA100);
  static const harvest700 = Color(0xFF765500);
  static const harvest800 = Color(0xFF5D3F00);
  static const terracotta100 = Color(0xFFFFE5D8);
  static const terracotta500 = tierra;
  static const terracotta600 = Color(0xFFA8481D);
  static const terracotta700 = Color(0xFF8E3507);
  static const neutral0 = Color(0xFFFFFFFF);
  static const neutral50 = Color(0xFFF9F6F1);
  static const neutral100 = Color(0xFFF3F0EA);
  static const neutral200 = Color(0xFFD7D4CE);
  static const neutral300 = Color(0xFFC0BDB8);
  static const neutral500 = Color(0xFF7D7A75);
  static const neutral600 = Color(0xFF5C5A57);
  static const neutral700 = Color(0xFF413F3C);
  static const neutral900 = Color(0xFF1B1916);

  /// Warm brown for the shadows of floating elements, instead of pure black.
  static const shadowTint = Color(0xFF4B3425);
}

/// Light Material 3 scheme, the only one designed in Figma.
const ColorScheme vioraLightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: VioraColors.forest,
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFB6D3C0),
  onPrimaryContainer: Color(0xFF0B1F14),
  secondary: VioraColors.tierra,
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFF3D2BE),
  onSecondaryContainer: Color(0xFF3D1D0B),
  tertiary: VioraColors.harvest,
  onTertiary: Color(0xFF3A2C00),
  tertiaryContainer: Color(0xFFFCE7A8),
  onTertiaryContainer: Color(0xFF241A00),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF93000A),
  surface: VioraColors.neutral50,
  onSurface: VioraColors.neutral900,
  onSurfaceVariant: Color(0xFF46483C),
  outline: Color(0xFF76786A),
  outlineVariant: Color(0xFFC6C7B8),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF30312B),
  onInverseSurface: Color(0xFFF2F1E7),
  inversePrimary: Color(0xFF9BCFA9),
  surfaceDim: Color(0xFFDBD9CF),
  surfaceBright: VioraColors.neutral50,
  surfaceContainerLowest: VioraColors.neutral0,
  surfaceContainerLow: Color(0xFFF3F0EA),
  surfaceContainer: Color(0xFFEFEDE2),
  surfaceContainerHigh: Color(0xFFE9E7DC),
  surfaceContainerHighest: Color(0xFFE3E1D7),
);

/// Dark Material 3 scheme. It isn't wired into the app: only the light scheme is
/// designed in Figma, so the app doesn't follow the system dark mode.
const ColorScheme vioraDarkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF9BCFA9),
  onPrimary: VioraColors.shadow,
  primaryContainer: Color(0xFF2E4A3A),
  onPrimaryContainer: Color(0xFFB6D3C0),
  secondary: Color(0xFFE9B695),
  onSecondary: Color(0xFF5A2C11),
  secondaryContainer: Color(0xFF7E4020),
  onSecondaryContainer: Color(0xFFF3D2BE),
  tertiary: Color(0xFFECC865),
  onTertiary: Color(0xFF3D2E00),
  tertiaryContainer: Color(0xFF584200),
  onTertiaryContainer: Color(0xFFFCE7A8),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: VioraColors.shadow,
  onSurface: Color(0xFFE4E3D9),
  onSurfaceVariant: Color(0xFFC6C7B8),
  outline: Color(0xFF909183),
  outlineVariant: Color(0xFF46483C),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE4E3D9),
  onInverseSurface: Color(0xFF30312B),
  inversePrimary: VioraColors.forest,
  surfaceDim: VioraColors.shadow,
  surfaceBright: Color(0xFF434A42),
  surfaceContainerLowest: Color(0xFF141F18),
  surfaceContainerLow: Color(0xFF1F2A22),
  surfaceContainer: Color(0xFF232E26),
  surfaceContainerHigh: Color(0xFF2E3830),
  surfaceContainerHighest: Color(0xFF39433B),
);
