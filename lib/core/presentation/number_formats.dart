import 'package:intl/intl.dart';
import 'package:viora/core/domain/decimal.dart';

const _currencySymbols = {'PEN': 'S/', 'USD': r'US$', 'EUR': '€'};

/// An amount in [currency] as every price of the app writes it: soles as "S/", whole amounts
/// without decimals and at most two otherwise. In Spanish the separators are the ones of the
/// rest of the app ("S/ 7 920", "S/ 27,5").
String formatMoney(Decimal value, String currency, String locale) {
  final decimals = value.setScale(2).stripTrailingZeros().scale;
  final pattern = decimals == 0 ? '#,##0' : '#,##0.${'0' * decimals}';
  final spanish = Intl.canonicalizedLocale(locale).startsWith('es');
  // Spanish is written from English digits, so the separators don't depend on the phone's region.
  var number = NumberFormat(pattern, spanish ? 'en' : locale).format(value.setScale(2).toDouble());
  if (spanish) {
    number = number.split('').map((c) => c == ',' ? ' ' : (c == '.' ? ',' : c)).join();
  }
  return '${_currencySymbols[currency] ?? currency} $number';
}

/// Hectares as the rest of the app writes them: the decimals they have and no more ("0,5").
String formatPlanCapacity(Decimal hectares, String locale) {
  final decimals = hectares.stripTrailingZeros().scale;
  final pattern = decimals == 0 ? '#,##0' : '#,##0.${'0' * decimals}';
  return NumberFormat(pattern, locale).format(hectares.toDouble());
}
