/// Closed spacing scale (multiples of 4). A value that isn't here isn't used.
/// Related elements: [xs]-[sm]; separate groups: [md]-[lg]; sections: [lg]-[xl].
abstract final class Spacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  /// Minimum touch target: the app is used in the field, with gloves or under the sun.
  static const double minTouchTarget = 48;
}
