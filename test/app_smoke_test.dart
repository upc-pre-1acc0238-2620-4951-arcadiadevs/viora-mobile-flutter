import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/database/app_database.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/repository/license_repository.dart';
import 'package:viora/features/subscription/presentation/viewmodel/producer_plan_view_model.dart';
import 'package:viora/main.dart';

/// A manager whose kept license is in force, so the license check opens the Home.
class _LicensedManager implements LicenseRepository {
  static final _license = ManagerLicense(
    id: 'license-1',
    organizationName: 'Cooperativa Olivar del Sur',
    seats: 60,
    contractedAreaHa: 200,
    startsAt: DateTime(2026),
    endsAt: DateTime(2100),
  );

  @override
  Future<ManagerLicense?> kept() async => _license;

  @override
  Future<ManagerLicense?> refresh() async => _license;

  @override
  Stream<ManagerLicense?> watchCurrent() => Stream.value(_license);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    // A saved session, so the app goes from the splash to the Home.
    FlutterSecureStorage.setMockInitialValues({'session.refresh_token': 'token'});
    setupDependencies();
    getIt.unregister<LicenseRepository>();
    getIt.registerLazySingleton<LicenseRepository>(_LicensedManager.new);
  });
  tearDown(() => getIt.reset());

  test('get_it provides a new ViewModel every time and registers the database', () {
    expect(getIt<HomeViewModel>(), isNot(same(getIt<HomeViewModel>())));
    // Only checks the registration: creating it would open the real database.
    expect(getIt.isRegistered<AppDatabase>(), isTrue);
  });

  test('get_it provides the ViewModel of the producer plan screen', () {
    expect(getIt<ProducerPlanViewModel>(), isNot(same(getIt<ProducerPlanViewModel>())));
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
