/// A person's full name: at least two letters once trimmed.
abstract final class PersonName {
  static bool isValid(String text) =>
      RegExp(r'\p{L}', unicode: true).allMatches(text.trim()).length >= 2;

  static String firstOf(String text) => text.trim().split(' ').first;
}

/// Password rules shared with the server: 8 characters or more, with letters and numbers.
abstract final class PasswordPolicy {
  static bool isLongEnough(String password) => password.length >= 8;

  static bool hasLettersAndDigits(String password) =>
      RegExp(r'\p{L}', unicode: true).hasMatch(password) && RegExp(r'\d').hasMatch(password);

  static bool isValid(String password) => isLongEnough(password) && hasLettersAndDigits(password);
}

abstract final class EmailAddress {
  static final _pattern = RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');

  static bool isValid(String email) => _pattern.hasMatch(normalize(email));

  /// The address as it's sent and shown: people often leave spaces around it.
  static String normalize(String email) => email.trim();
}

/// Countries of the operation, with the shape of their mobile numbers. The server has the
/// last word, with the complete numbering plan of each country.
enum PhoneCountry {
  pe('PE', '+51', r'^9\d{8}$'),
  es('ES', '+34', r'^[67]\d{8}$'),
  cl('CL', '+56', r'^9\d{8}$');

  const PhoneCountry(this.iso, this.dialCode, this._mobilePattern);

  static const nationalDigits = 9;

  final String iso;
  final String dialCode;
  final String _mobilePattern;

  static PhoneCountry fromIso(String iso) =>
      values.firstWhere((country) => country.iso == iso, orElse: () => pe);

  bool isValidMobile(String national) => RegExp(_mobilePattern).hasMatch(national);

  /// E.164, the only format the server accepts ("+51987654321").
  String e164(String national) => '$dialCode$national';

  /// For reading ("+51 987 654 321").
  String international(String national) {
    final groups = RegExp(r'.{1,3}').allMatches(national).map((match) => match.group(0));
    return '$dialCode ${groups.join(' ')}';
  }
}
