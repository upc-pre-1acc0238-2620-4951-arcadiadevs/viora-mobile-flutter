// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navHome => 'Inicio';

  @override
  String get navRisk => 'Riesgo';

  @override
  String get navCollection => 'Acopio';

  @override
  String get navMembers => 'Socios';

  @override
  String get placeholderComingSoon => 'Próximamente';

  @override
  String homeGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get homeGreetingAnonymous => 'Hola';

  @override
  String get homeAlerts => 'Alertas';

  @override
  String get homeHeadlineLead => 'Tu valle,';

  @override
  String get homeHeadlineEmphasis => 'hoy.';
}
