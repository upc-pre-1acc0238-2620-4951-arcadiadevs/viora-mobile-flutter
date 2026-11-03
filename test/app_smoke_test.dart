import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/database/app_database.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:viora/main.dart';

void main() {
  setUp(setupDependencies);
  tearDown(() => getIt.reset());

  test('get_it provides a new ViewModel every time and registers the database', () {
    expect(getIt<HomeViewModel>(), isNot(same(getIt<HomeViewModel>())));
    // Only checks the registration: creating it would open the real database.
    expect(getIt.isRegistered<AppDatabase>(), isTrue);
  });

  group('the app opens on Home in the language of the phone', () {
    Future<void> openWith(WidgetTester tester, Locale locale) async {
      tester.platformDispatcher.localesTestValue = [locale];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await tester.pumpWidget(const VioraApp());
      await tester.pumpAndSettle();
    }

    testWidgets('Spanish from Peru uses the Spanish texts', (tester) async {
      await openWith(tester, const Locale('es', 'PE'));

      expect(find.text('Tu valle,'), findsOneWidget);
      expect(find.text('hoy.'), findsOneWidget);
      expect(find.bySemanticsLabel('Riesgo'), findsOneWidget);
    });

    testWidgets('English uses the English texts', (tester) async {
      await openWith(tester, const Locale('en', 'US'));

      expect(find.text('Your valley,'), findsOneWidget);
      expect(find.bySemanticsLabel('Risk'), findsOneWidget);
    });

    testWidgets('a language the app does not have falls back to English', (tester) async {
      await openWith(tester, const Locale('fr', 'FR'));

      expect(find.text('Your valley,'), findsOneWidget);
    });
  });
}
