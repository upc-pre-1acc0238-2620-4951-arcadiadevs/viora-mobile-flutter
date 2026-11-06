import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/designsystem/component/viora_morphing_shape_indicator.dart';
import 'package:viora/core/designsystem/component/viora_wavy_progress_indicator.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/navigation/app_routes.dart';
import 'package:viora/features/iam/application/usecase/is_signed_in_use_case.dart';
import 'package:viora/features/iam/domain/repository/auth_repository.dart';
import 'package:viora/features/iam/presentation/ui/splash_page.dart';
import 'package:viora/features/iam/presentation/ui/welcome_page.dart';
import 'package:viora/features/iam/presentation/viewmodel/splash_view_model.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.signedIn});

  final bool signedIn;

  @override
  Future<bool> isSignedIn() async => signedIn;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  void useSession({required bool signedIn}) {
    getIt.registerFactory<SplashViewModel>(
      () => SplashViewModel(
        isSignedIn: IsSignedInUseCase(repository: _FakeAuthRepository(signedIn: signedIn)),
      ),
    );
  }

  setUp(() => useSession(signedIn: true));
  tearDown(() => getIt.reset());

  Widget app() => MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: SplashPage.path,
          routes: [
            GoRoute(
              path: SplashPage.path,
              pageBuilder: (context, state) => const NoTransitionPage(child: SplashPage()),
            ),
            GoRoute(
              path: AppRoutes.licenseGate,
              pageBuilder: (context, state) => const NoTransitionPage(child: Text('license check')),
            ),
            GoRoute(
              path: WelcomePage.path,
              pageBuilder: (context, state) => const NoTransitionPage(child: Text('welcome')),
            ),
          ],
        ),
      );

  /// Pumps 16 ms frames for [millis].
  Future<void> play(WidgetTester tester, int millis) async {
    for (var elapsed = 0; elapsed < millis; elapsed += 16) {
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  testWidgets('starts with the morphing shape and without the loading ring', (tester) async {
    await tester.pumpWidget(app());
    await play(tester, 500);

    expect(find.byType(VioraMorphingShapeIndicator), findsOneWidget);
    expect(find.byType(VioraWavyProgressIndicator), findsNothing);
    expect(find.text('license check'), findsNothing);
  });

  testWidgets('shows the loading ring before checking the license', (tester) async {
    await tester.pumpWidget(app());

    var elapsed = 0;
    while (find.byType(VioraWavyProgressIndicator).evaluate().isEmpty && elapsed < 8000) {
      await play(tester, 100);
      elapsed += 100;
    }

    expect(find.byType(VioraWavyProgressIndicator), findsOneWidget);
    expect(find.text('license check'), findsNothing);
  });

  testWidgets('checks the license of a saved session when it ends, in the time of the sequence', (tester) async {
    await tester.pumpWidget(app());

    var elapsed = 0;
    while (find.text('license check').evaluate().isEmpty && elapsed < 8000) {
      await play(tester, 100);
      elapsed += 100;
    }

    expect(find.text('license check'), findsOneWidget);
    expect(find.byType(SplashPage), findsNothing);
    // The minimum times alone add up to 3 s; the springs of the morph add a little more.
    expect(elapsed, inInclusiveRange(3000, 5000));
  });

  testWidgets('goes to the welcome without a saved session', (tester) async {
    await getIt.reset();
    useSession(signedIn: false);
    await tester.pumpWidget(app());

    var elapsed = 0;
    while (find.text('welcome').evaluate().isEmpty && elapsed < 8000) {
      await play(tester, 100);
      elapsed += 100;
    }

    expect(find.text('welcome'), findsOneWidget);
    expect(find.text('license check'), findsNothing);
  });

  testWidgets('uses white icons on the system bars', (tester) async {
    await tester.pumpWidget(app());
    await tester.pump();

    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.descendant(
        of: find.byType(SplashPage),
        matching: find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
      ),
    );
    expect(region.value, AppTheme.systemBarsOnDark);
    expect(region.value.statusBarIconBrightness, Brightness.light);
  });

  testWidgets('leaves no timer running if it is removed halfway', (tester) async {
    await tester.pumpWidget(app());
    await play(tester, 1500);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
