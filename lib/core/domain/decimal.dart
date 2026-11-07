/// An exact base-10 number: an integer [_unscaled] over 10^[scale]. Money and hectares never go
/// through a binary `double`, so the estimate shown matches the one the server computes.
///
/// Rounding is always HALF_UP (ties go away from zero), the rounding of the backend.
final class Decimal implements Comparable<Decimal> {
  const Decimal._(this._unscaled, this.scale);

  factory Decimal.fromInt(int value) => Decimal._(BigInt.from(value), 0);

  /// Reads "12", "-0.18", "1.5e-3". Throws a [FormatException] for anything else.
  factory Decimal.parse(String source) {
    final match = _pattern.firstMatch(source.trim());
    if (match == null) throw FormatException('Not a decimal number', source);
    final exponent = int.parse(match.group(4) ?? '0');
    if (exponent.abs() > _maxExponent) throw FormatException('Exponent out of range', source);
    final fraction = match.group(3) ?? '';
    var unscaled = BigInt.parse('${match.group(2)}$fraction');
    var scale = fraction.length - exponent;
    if (scale < 0) {
      unscaled *= _pow10(-scale);
      scale = 0;
    }
    if (match.group(1) == '-') unscaled = -unscaled;
    return Decimal._(unscaled, scale);
  }

  static final zero = Decimal.fromInt(0);
  static final one = Decimal.fromInt(1);

  static final _pattern = RegExp(r'^([+-])?(\d+)(?:\.(\d+))?(?:[eE]([+-]?\d+))?$');
  static const _maxExponent = 1000;

  final BigInt _unscaled;

  /// Digits after the decimal point; never negative.
  final int scale;

  static BigInt _pow10(int exponent) => BigInt.from(10).pow(exponent);

  BigInt _at(int target) => _unscaled * _pow10(target - scale);

  static int _commonScale(Decimal a, Decimal b) => a.scale > b.scale ? a.scale : b.scale;

  /// -1, 0 or 1.
  int get signum => _unscaled.sign;

  Decimal operator +(Decimal other) {
    final common = _commonScale(this, other);
    return Decimal._(_at(common) + other._at(common), common);
  }

  Decimal operator -(Decimal other) {
    final common = _commonScale(this, other);
    return Decimal._(_at(common) - other._at(common), common);
  }

  Decimal operator *(Decimal other) => Decimal._(_unscaled * other._unscaled, scale + other.scale);

  bool operator <(Decimal other) => compareTo(other) < 0;
  bool operator <=(Decimal other) => compareTo(other) <= 0;
  bool operator >(Decimal other) => compareTo(other) > 0;
  bool operator >=(Decimal other) => compareTo(other) >= 0;

  /// This divided by [other], rounded HALF_UP to [resultScale] decimals.
  Decimal divide(Decimal other, int resultScale) {
    if (other.signum == 0) throw ArgumentError('Division by zero');
    if (resultScale < 0) throw ArgumentError.value(resultScale, 'resultScale');
    final numerator = _unscaled * _pow10(resultScale + other.scale);
    final denominator = other._unscaled * _pow10(scale);
    return Decimal._(_divideRounded(numerator, denominator), resultScale);
  }

  /// The same value with exactly [newScale] decimals, rounded HALF_UP when it has to drop some.
  Decimal setScale(int newScale) {
    if (newScale < 0) throw ArgumentError.value(newScale, 'newScale');
    if (newScale >= scale) return Decimal._(_at(newScale), newScale);
    return Decimal._(_divideRounded(_unscaled, _pow10(scale - newScale)), newScale);
  }

  /// True when this is a whole number of [step]s.
  bool isMultipleOf(Decimal step) {
    if (step.signum == 0) throw ArgumentError('Step is zero');
    final common = _commonScale(this, step);
    return _at(common).remainder(step._at(common)) == BigInt.zero;
  }

  Decimal stripTrailingZeros() {
    var unscaled = _unscaled;
    var newScale = scale;
    final ten = BigInt.from(10);
    while (newScale > 0 && unscaled.remainder(ten) == BigInt.zero) {
      unscaled ~/= ten;
      newScale--;
    }
    return Decimal._(unscaled, newScale);
  }

  /// "1234.50": never in exponent notation.
  String toPlainString() {
    final digits = _unscaled.abs().toString();
    final sign = _unscaled.isNegative ? '-' : '';
    if (scale == 0) return '$sign$digits';
    final padded = digits.padLeft(scale + 1, '0');
    final point = padded.length - scale;
    return '$sign${padded.substring(0, point)}.${padded.substring(point)}';
  }

  /// For display only, once the value is rounded to what is shown.
  double toDouble() => double.parse(toPlainString());

  @override
  int compareTo(Decimal other) {
    final common = _commonScale(this, other);
    return _at(common).compareTo(other._at(common));
  }

  @override
  bool operator ==(Object other) => other is Decimal && compareTo(other) == 0;

  @override
  int get hashCode {
    final stripped = stripTrailingZeros();
    return Object.hash(stripped._unscaled, stripped.scale);
  }

  @override
  String toString() => toPlainString();

  static BigInt _divideRounded(BigInt numerator, BigInt denominator) {
    final negative = numerator.isNegative != denominator.isNegative;
    final n = numerator.abs();
    final d = denominator.abs();
    var quotient = n ~/ d;
    if ((n - quotient * d) * BigInt.two >= d) quotient += BigInt.one;
    return negative ? -quotient : quotient;
  }
}
