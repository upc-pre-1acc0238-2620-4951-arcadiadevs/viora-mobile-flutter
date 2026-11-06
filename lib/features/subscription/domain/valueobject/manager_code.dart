/// The code that activates a license, as `GEST-` and four letters or digits. The manager may
/// type it in lower case or with spaces, so the text is normalized before it is judged.
class ManagerCode {
  const ManagerCode._(this.value);

  static final _format = RegExp(r'^GEST-[A-Z0-9]{4}$');

  /// Characters of a complete code, prefix included.
  static const length = 9;

  /// The normalized code, as the server expects it.
  final String value;

  /// [text] without whitespace and in upper case.
  static String normalize(String text) => text.replaceAll(RegExp(r'\s'), '').toUpperCase();

  /// The code, or null while [text] is not a complete code.
  static ManagerCode? tryParse(String text) {
    final normalized = normalize(text);
    return _format.hasMatch(normalized) ? ManagerCode._(normalized) : null;
  }
}
