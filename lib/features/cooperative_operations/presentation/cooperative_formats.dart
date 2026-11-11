import 'package:intl/intl.dart';
import 'package:viora/core/l10n/app_localizations.dart';

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

/// "43", "2,5": one decimal at most.
String formatOneDecimal(double value, String locale) => NumberFormat('#,##0.#', locale).format(value);

/// "2,00", "0,45": always two decimals.
String formatTwoDecimals(double value, String locale) => NumberFormat('#,##0.00', locale).format(value);

/// "jueves 12" in Spanish, "Thursday 12" in English.
String formatWeekdayDay(DateTime date, String locale) => DateFormat('EEEE d', locale).format(date);

/// "29 de octubre" in Spanish, "October 29" in English.
String formatLongDayMonth(DateTime date, String locale) => DateFormat.MMMMd(locale).format(date);

/// How old a reading of the server is: "actualizado hace 5 min".
String formatUpdatedAgo(AppLocalizations l10n, DateTime? at, DateTime now) {
  if (at == null) return l10n.riskUpdatedUnknown;
  final minutes = now.difference(at).inMinutes;
  if (minutes < 1) return l10n.riskUpdatedNow;
  if (minutes < 60) return l10n.riskUpdatedMinutes(minutes);
  return l10n.riskUpdatedAt(DateFormat('d MMM, HH:mm', l10n.localeName).format(at.toLocal()).replaceAll('.', ''));
}

/// When a plot was read: "hoy, 7:40", or the day when it isn't today.
String formatReadAt(AppLocalizations l10n, DateTime at, DateTime now, String locale) {
  final local = at.toLocal();
  final time = DateFormat.Hm(locale).format(local);
  return daysUntil(local, now) == 0 ? l10n.riskToday(time) : '${formatDayMonth(local, locale)}, $time';
}

/// The pill of a screen without a connection: "Sin conexión · último estado de hoy, 7:40" or
/// "Sin conexión · proyección del 26 sep, 18:10". [what] names what was kept.
String formatOffline(AppLocalizations l10n, String what, DateTime at, DateTime now, String locale) {
  final when = formatReadAt(l10n, at, now, locale);
  return daysUntil(at.toLocal(), now) == 0 ? l10n.offlineToday(what, when) : l10n.offlineOn(what, when);
}
