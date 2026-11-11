import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/navigation/top_level_destination.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/manager_alerts_page.dart';
import 'package:viora/features/iam/presentation/ui/iam_page.dart';
import 'package:viora/features/profiles/presentation/ui/account_page.dart';
import 'package:viora/navigation/app_router.dart';

void main() {
  test('the recovery link of a technical manager opens the account flow', () {
    final match = appRouter.configuration.findMatch(Uri.parse('/gestor/password-resets/token'));

    expect(match.pathParameters['token'], 'token');
    expect(match.uri.path, '/gestor/password-resets/token');
    expect(IamPage.resetPath, '/gestor/password-resets/:token');
  });

  test('the recovery link of a producer is not for this app', () {
    final match = appRouter.configuration.findMatch(Uri.parse('/password-resets/token'));

    expect(match.pathParameters, isNot(contains('token')));
  });

  test('the alerts of the manager live under the Riesgo tab, and their settings are the account', () {
    final alerts = appRouter.configuration.findMatch(Uri.parse('/risk/alerts'));
    final preferences = appRouter.configuration.findMatch(Uri.parse('/risk/alerts/preferences'));

    expect(alerts.uri.path, '/risk/alerts');
    expect(alerts.matches.last.matchedLocation, '/risk/${ManagerAlertsPage.path}');
    expect(preferences.matches, isEmpty);
    expect(appRouter.configuration.findMatch(Uri.parse(AccountPage.path)).matches, isNotEmpty);
  });

  test('every tab opens its own screen', () {
    for (final tab in TopLevelDestination.values) {
      expect(appRouter.configuration.findMatch(Uri.parse(tab.path)).matches.last.matchedLocation, tab.path);
    }
  });

  test('the bell of Home and Socios opens the alerts over its own tab, so going back returns there', () {
    for (final tab in ['/home', '/members']) {
      final alerts = appRouter.configuration.findMatch(Uri.parse('$tab/alerts'));
      final plot = appRouter.configuration.findMatch(Uri.parse('$tab/alerts/sectors/s1/plots/p1/dossier'));

      expect(alerts.uri.path, '$tab/alerts');
      expect(alerts.matches.last.matchedLocation, '$tab/alerts');
      expect(plot.pathParameters, {'scope': 's1', 'plotId': 'p1'});
      expect(plot.matches.last.matchedLocation, '$tab/alerts/sectors/s1/plots/p1/dossier');
    }
  });

  test('the sectors and plots of the map keep their own routes', () {
    final sector = appRouter.configuration.findMatch(Uri.parse('/risk/sectors/s1'));
    final dossier = appRouter.configuration.findMatch(Uri.parse('/risk/plots/p1/dossier'));

    expect(sector.matches.last.matchedLocation, '/risk/sectors/s1');
    expect(dossier.pathParameters, {'plotId': 'p1'});
    expect(dossier.matches.last.matchedLocation, '/risk/plots/p1/dossier');
  });

  test('the suggested visits and their plots open over the Home tab', () {
    final visits = appRouter.configuration.findMatch(Uri.parse('/home/sectors/visits'));
    final dossier = appRouter.configuration.findMatch(Uri.parse('/home/plots/p1/dossier'));

    expect(visits.pathParameters, {'scope': 'visits'});
    expect(visits.matches.last.matchedLocation, '/home/sectors/visits');
    expect(dossier.pathParameters, {'plotId': 'p1'});
    expect(dossier.matches.last.matchedLocation, '/home/plots/p1/dossier');
  });
}
