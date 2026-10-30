/// Escala cerrada de espaciado (múltiplos de 4). Si un valor no está aquí, no se usa.
/// Elementos relacionados: [xs]-[sm]; grupos separados: [md]-[lg]; secciones: [lg]-[xl].
abstract final class Spacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  /// Área interactiva mínima: uso en campo con guantes o bajo el sol.
  static const double minTouchTarget = 48;
}
