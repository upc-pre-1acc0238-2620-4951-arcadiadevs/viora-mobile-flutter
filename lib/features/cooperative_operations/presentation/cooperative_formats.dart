import 'package:intl/intl.dart';

/// "4", "2,5" in Spanish, "2.5" in English: hectares with one decimal at most.
String formatHectares(double hectares, String locale) => NumberFormat('#,##0.#', locale).format(hectares);

/// "15 nov": a day of the month, without the dot some languages add.
String formatDayMonth(DateTime date, String locale) =>
    DateFormat('d MMM', locale).format(date.toLocal()).replaceAll('.', '');

/// "12 de marzo de 2026" in Spanish, "March 12, 2026" in English.
String formatLongDate(DateTime date, String locale) => DateFormat.yMMMMd(locale).format(date.toLocal());

/// "Sevillana" from the server's "SEVILLANA" or "sevillana".
String formatVariety(String? variety) {
  if (variety == null || variety.isEmpty) return '';
  final words = variety.replaceAll('_', ' ').toLowerCase();
  return words[0].toUpperCase() + words.substring(1);
}

/// Whole days from [now] to [date], counting calendar days in the phone's zone.
int daysUntil(DateTime date, DateTime now) {
  final end = date.toLocal();
  final today = now.toLocal();
  return DateTime(end.year, end.month, end.day).difference(DateTime(today.year, today.month, today.day)).inDays;
}
