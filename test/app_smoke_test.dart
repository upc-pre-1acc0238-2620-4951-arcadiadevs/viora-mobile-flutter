import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/database/app_database.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
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

  testWidgets('the app keeps its own style for the system bars', (tester) async {
    await tester.pumpWidget(const VioraApp());
    await tester.pumpAndSettle();

    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.byType(AnnotatedRegion<SystemUiOverlayStyle>).first,
    );
    expect(region.value, AppTheme.systemBars);
    expect(region.value.systemNavigationBarColor, Colors.transparent);
  });

  testWidgets('the tab bar keeps its margin above the navigation bar', (tester) async {
    const navigationBar = FakeViewPadding(bottom: 135);
    tester.view.padding = navigationBar;
    tester.view.viewPadding = navigationBar;
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);

    await tester.pumpWidget(const VioraApp());
    await tester.pumpAndSettle();

    final screenHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final inset = 135 / tester.view.devicePixelRatio;
    expect(
      tester.getBottomLeft(find.byType(VioraTabBar)).dy,
      screenHeight - inset - VioraTabBarDefaults.bottomMargin,
    );
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
