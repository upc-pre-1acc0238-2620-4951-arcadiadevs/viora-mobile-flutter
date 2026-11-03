// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navRisk => 'Risk';

  @override
  String get navCollection => 'Collection';

  @override
  String get navMembers => 'Members';

  @override
  String get placeholderComingSoon => 'Coming soon';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeGreetingAnonymous => 'Hello';

  @override
  String get homeAlerts => 'Alerts';

  @override
  String get homeHeadlineLead => 'Your valley,';

  @override
  String get homeHeadlineEmphasis => 'today.';
}
