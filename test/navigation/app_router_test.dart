import 'package:flutter_test/flutter_test.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/manager_alerts_page.dart';
import 'package:viora/features/iam/presentation/ui/iam_page.dart';
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

  test('the alerts of the manager and their preferences live under the Riesgo tab', () {
    final alerts = appRouter.configuration.findMatch(Uri.parse('/risk/alerts'));
    final preferences = appRouter.configuration.findMatch(Uri.parse('/risk/alerts/preferences'));

    expect(alerts.uri.path, '/risk/alerts');
    expect(alerts.matches.last.matchedLocation, '/risk/${ManagerAlertsPage.path}');
    expect(preferences.matches.last.matchedLocation, '/risk/alerts/preferences');
  });
}
