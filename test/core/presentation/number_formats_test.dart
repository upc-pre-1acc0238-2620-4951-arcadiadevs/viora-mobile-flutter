import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/domain/decimal.dart';
import 'package:viora/core/presentation/number_formats.dart';

void main() {
  Decimal d(String text) => Decimal.parse(text);

  group('formatMoney', () {
    test('writes soles with S/ and no decimals when the amount is whole', () {
      expect(formatMoney(d('7920'), 'PEN', 'es'), 'S/ 7 920');
      expect(formatMoney(d('7920.00'), 'PEN', 'en'), 'S/ 7,920');
    });

    test('keeps at most two decimals', () {
      expect(formatMoney(d('27.5'), 'PEN', 'es'), 'S/ 27,5');
      expect(formatMoney(d('283.20'), 'PEN', 'en'), 'S/ 283.2');
      expect(formatMoney(d('203.389'), 'PEN', 'en'), 'S/ 203.39');
    });

    test('Spanish keeps its separators whatever the region', () {
      expect(formatMoney(d('1234.5'), 'PEN', 'es-PE'), 'S/ 1 234,5');
    });

    test('an unknown currency shows its code', () {
      expect(formatMoney(d('10'), 'CLP', 'en'), 'CLP 10');
    });
  });

  test('formatPlanCapacity keeps the decimals the hectares have', () {
    expect(formatPlanCapacity(d('0.5'), 'en'), '0.5');
    expect(formatPlanCapacity(d('0.5'), 'es'), '0,5');
    expect(formatPlanCapacity(d('12.0'), 'en'), '12');
  });
}
