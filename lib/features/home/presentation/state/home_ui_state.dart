import 'package:flutter/foundation.dart';

/// Lo que muestra el Home (Figma P10 "Inicio").
///
/// Por ahora solo lo que ya tiene datos detrás (saludo y alertas). Cuando se
/// integren los lotes pasa a ser una `sealed class` como en Android
/// (`Loading`, `Error`, `NoPlots`, `Content`), igual que `HomeUiState.kt`.
@immutable
class HomeUiState {
  const HomeUiState({
    this.displayName,
    this.hasUnreadAlerts = false,
  });

  /// Nombre completo del perfil; `null` mientras no se conozca.
  final String? displayName;

  /// Muestra el punto de aviso sobre la campana.
  final bool hasUnreadAlerts;

  HomeUiState copyWith({String? displayName, bool? hasUnreadAlerts}) {
    return HomeUiState(
      displayName: displayName ?? this.displayName,
      hasUnreadAlerts: hasUnreadAlerts ?? this.hasUnreadAlerts,
    );
  }
}
