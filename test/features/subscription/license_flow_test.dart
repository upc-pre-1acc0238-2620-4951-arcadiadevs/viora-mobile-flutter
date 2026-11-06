import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/designsystem/theme/app_theme.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/navigation/app_routes.dart';
import 'package:viora/core/navigation/top_level_destination.dart';
import 'package:viora/features/iam/application/usecase/sign_out_use_case.dart';
import 'package:viora/features/iam/domain/repository/auth_repository.dart';
import 'package:viora/features/subscription/application/usecase/activate_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/get_account_email_use_case.dart';
import 'package:viora/features/subscription/application/usecase/get_kept_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/refresh_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/watch_current_license_use_case.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';
import 'package:viora/features/subscription/domain/repository/license_repository.dart';
import 'package:viora/features/subscription/domain/valueobject/manager_code.dart';
import 'package:viora/features/subscription/presentation/state/license_gate_ui_state.dart';
import 'package:viora/features/subscription/presentation/ui/license_activation_page.dart';
import 'package:viora/features/subscription/presentation/ui/license_gate_page.dart';
import 'package:viora/features/subscription/presentation/ui/widgets/license_status_widgets.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_activation_view_model.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_gate_view_model.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_status_view_model.dart';

final _now = DateTime.utc(2026, 11, 6, 15);

ManagerLicense _license({DateTime? endsAt}) => ManagerLicense(
      id: 'license-1',
      organizationName: 'Cooperativa Olivar del Sur',
      seats: 60,
      contractedAreaHa: 200,
      startsAt: DateTime.utc(2026, 11, 5),
      endsAt: endsAt ?? DateTime.utc(2028),
    );

class _FakeLicenses implements LicenseRepository {
  _FakeLicenses({this.keptLicense, this.server, this.refreshFailure, this.activateFailure});

  ManagerLicense? keptLicense;
  ManagerLicense? server;
  LicenseFailure? refreshFailure;
  LicenseFailure? activateFailure;
  final _changes = StreamController<ManagerLicense?>.broadcast();
  int refreshes = 0;
  String? activatedWith;

  /// Holds the refresh until completed, to see what happens while it is on its way.
  Completer<void>? refreshGate;

  @override
  Future<ManagerLicense?> kept() async => keptLicense;

  @override
  Stream<ManagerLicense?> watchCurrent() async* {
    yield keptLicense;
    yield* _changes.stream;
  }

  @override
  Future<ManagerLicense?> refresh() async {
    refreshes++;
    await refreshGate?.future;
    final failure = refreshFailure;
    if (failure != null) throw failure;
    keptLicense = server;
    _changes.add(server);
    return server;
  }

  @override
  Future<ManagerLicense> activate(ManagerCode code) async {
    final failure = activateFailure;
    if (failure != null) throw failure;
    activatedWith = code.value;
    keptLicense = _license();
    return keptLicense!;
  }

  @override
  Future<String?> accountEmail() async => 'ruben@example.com';

  @override
  Future<void> clear() async => keptLicense = null;
}

class _FakeAuth implements AuthRepository {
  int signOuts = 0;

  @override
  Future<void> signOut() async => signOuts++;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

LicenseGateViewModel _gate(_FakeLicenses licenses, [_FakeAuth? auth]) => LicenseGateViewModel(
      getKeptLicense: GetKeptLicenseUseCase(repository: licenses),
      refreshLicense: RefreshLicenseUseCase(repository: licenses),
      signOutUseCase: SignOutUseCase(repository: auth ?? _FakeAuth()),
      now: () => _now,
    );

LicenseActivationViewModel _activation(_FakeLicenses licenses, [_FakeAuth? auth]) =>
    LicenseActivationViewModel(
      activateLicense: ActivateLicenseUseCase(repository: licenses),
      getKeptLicense: GetKeptLicenseUseCase(repository: licenses),
      getAccountEmail: GetAccountEmailUseCase(repository: licenses),
      signOutUseCase: SignOutUseCase(repository: auth ?? _FakeAuth()),
      now: () => _now,
    );

void main() {
  group('the license check', () {
    test('a kept license in force opens the Home without waiting for the server', () async {
      final licenses = _FakeLicenses(keptLicense: _license())..refreshGate = Completer();
      final gate = _gate(licenses);

      await gate.check();

      expect(gate.state.destination, LicenseGateDestination.home);
      expect(licenses.refreshes, 1);
    });

    test('without a kept license, the server decides: Home or activation', () async {
      final licensed = _gate(_FakeLicenses(server: _license()));
      await licensed.check();
      expect(licensed.state.destination, LicenseGateDestination.home);

      final unlicensed = _gate(_FakeLicenses());
      await unlicensed.check();
      expect(unlicensed.state.destination, LicenseGateDestination.activation);
    });

    test('a license that ran out goes to the activation, even when the phone kept it', () async {
      final ended = _license(endsAt: _now.subtract(const Duration(days: 1)));
      final gate = _gate(_FakeLicenses(keptLicense: ended, server: ended));

      await gate.check();

      expect(gate.state.destination, LicenseGateDestination.activation);
    });

    test('a failed check is never read as no license, and can be retried', () async {
      final licenses = _FakeLicenses(server: _license(), refreshFailure: const LicenseOffline());
      final gate = _gate(licenses);

      await gate.check();
      expect(gate.state.destination, isNull);
      expect(gate.state.failure, isA<LicenseOffline>());

      licenses.refreshFailure = null;
      await gate.check();
      expect(gate.state.failure, isNull);
      expect(gate.state.destination, LicenseGateDestination.home);
    });

    test('signing out from the check leaves the session', () async {
      final auth = _FakeAuth();
      final gate = _gate(_FakeLicenses(refreshFailure: const LicenseOffline()), auth);

      await gate.signOut();

      expect(auth.signOuts, 1);
      expect(gate.state.signedOut, isTrue);
    });
  });

  group('the activation', () {
    test('reads the email of the account and whether the license ran out', () async {
      final ended = _license(endsAt: _now.subtract(const Duration(days: 1)));
      final activation = _activation(_FakeLicenses(keptLicense: ended));

      await activation.start();

      expect(activation.state.email, 'ruben@example.com');
      expect(activation.state.expired, isTrue);
    });

    test('normalizes the code and only lets a complete one through', () {
      final activation = _activation(_FakeLicenses());

      activation.onCode('gest-11');
      expect(activation.state.code, 'GEST-11');
      expect(activation.state.canActivate, isFalse);

      activation.onCode('gest 1111 ');
      expect(activation.state.code, 'GEST1111');
      expect(activation.state.canActivate, isFalse);

      activation.onCode('gest-1111xx');
      expect(activation.state.code, 'GEST-1111');
      expect(activation.state.canActivate, isTrue);
    });

    test('a valid code shows the license it activated', () async {
      final licenses = _FakeLicenses();
      final activation = _activation(licenses)..onCode('GEST-1111');

      await activation.activate();

      expect(licenses.activatedWith, 'GEST-1111');
      expect(activation.state.activated?.organizationName, 'Cooperativa Olivar del Sur');
      expect(activation.state.loading, isFalse);
    });

    test('a code that cannot be used stays on the screen, and typing clears the error', () async {
      final activation = _activation(
        _FakeLicenses(activateFailure: const LicenseCodeNotRedeemable()),
      )..onCode('GEST-1111');

      await activation.activate();
      expect(activation.state.codeRejected, isTrue);
      expect(activation.state.activated, isNull);

      activation.onCode('GEST-111');
      expect(activation.state.codeRejected, isFalse);
    });

    test('a manager who already holds a license goes back to the check', () async {
      final activation = _activation(_FakeLicenses(activateFailure: const LicenseAlreadyHeld()))
        ..onCode('GEST-1111');

      await activation.activate();

      expect(activation.state.alreadyLicensed, isTrue);
    });
  });

  group('the screens', () {
    late _FakeLicenses licenses;

    setUp(() => licenses = _FakeLicenses());
    tearDown(() => getIt.reset());

    /// The phone of the design, 402 x 874.
    void phone(WidgetTester tester) {
      tester.view.physicalSize = const Size(1206, 2622);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
    }

    void register() {
      getIt.registerFactory<LicenseGateViewModel>(() => _gate(licenses));
      getIt.registerFactory<LicenseActivationViewModel>(() => _activation(licenses));
      getIt.registerFactory<LicenseStatusViewModel>(
        () => LicenseStatusViewModel(
          watchLicense: WatchCurrentLicenseUseCase(repository: licenses),
          refreshLicense: RefreshLicenseUseCase(repository: licenses),
          now: () => _now,
        ),
      );
    }

    Widget app(String initialLocation, {Locale locale = const Locale('es')}) =>
        MaterialApp.router(
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            initialLocation: initialLocation,
            routes: [
              GoRoute(path: LicenseGatePage.path, builder: (context, state) => const LicenseGatePage()),
              GoRoute(
                path: LicenseActivationPage.path,
                builder: (context, state) => const LicenseActivationPage(),
              ),
              GoRoute(
                path: TopLevelDestination.home.path,
                builder: (context, state) => const Text('home'),
              ),
              GoRoute(path: AppRoutes.signIn, builder: (context, state) => const Text('sign in')),
              GoRoute(
                path: '/badge',
                builder: (context, state) => const Scaffold(
                  body: Column(children: [LicenseStatusBadge(), LicenseOrganizationSuffix()]),
                ),
              ),
            ],
          ),
        );

    testWidgets('a manager without a license lands on the activation', (tester) async {
      register();
      phone(tester);
      await tester.pumpWidget(app(LicenseGatePage.path));
      await tester.pumpAndSettle();

      expect(find.text('Activar licencia'), findsOneWidget);
      expect(find.text('Sin licencia asignada'), findsOneWidget);
      expect(find.text('ruben@example.com'), findsOneWidget);
      expect(find.text('¿Aún no contrató? Escríbenos'), findsOneWidget);
    });

    testWidgets('a failed check offers to try again instead of the activation', (tester) async {
      licenses.refreshFailure = const LicenseOffline();
      register();
      phone(tester);
      await tester.pumpWidget(app(LicenseGatePage.path));
      await tester.pumpAndSettle();

      expect(find.text('Reintentar'), findsOneWidget);
      expect(find.text('Activar licencia'), findsNothing);

      licenses
        ..refreshFailure = null
        ..server = _license();
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('a code that cannot be used says so in the place of the explanation',
        (tester) async {
      licenses.activateFailure = const LicenseCodeNotRedeemable();
      register();
      phone(tester);
      await tester.pumpWidget(app(LicenseActivationPage.path));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'gest-7k2q');
      await tester.pump();
      expect(find.text('GEST-7K2Q'), findsOneWidget);
      await tester.tap(find.text('Activar licencia'));
      await tester.pumpAndSettle();

      expect(
        find.text('Código no válido o ya usado. Pide uno nuevo al equipo de Viora.'),
        findsOneWidget,
      );
      expect(
        find.text('Si tu organización ya contrató Viora, ingresa el código que te entregamos.'),
        findsNothing,
      );
    });

    testWidgets('a valid code shows what the license covers, and then the Home', (tester) async {
      register();
      phone(tester);
      await tester.pumpWidget(app(LicenseActivationPage.path));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'GEST-1111');
      await tester.pump();
      await tester.tap(find.text('Activar licencia'));
      await tester.pumpAndSettle();

      expect(find.text('Cooperativa Olivar del Sur'), findsOneWidget);
      expect(find.text('60 plazas · 200 ha'), findsOneWidget);
      expect(find.textContaining('Hasta el 31 dic'), findsOneWidget);

      await tester.tap(find.text('Ir al inicio'));
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('in English the quota and the date read in English', (tester) async {
      register();
      phone(tester);
      await tester.pumpWidget(app(LicenseActivationPage.path, locale: const Locale('en')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'GEST-1111');
      await tester.pump();
      await tester.tap(find.text('Activate license'));
      await tester.pumpAndSettle();

      expect(find.text('60 seats · 200 ha'), findsOneWidget);
      expect(find.textContaining('Until 31 Dec'), findsOneWidget);
    });

    testWidgets('the badge and the organization show only with a license in force',
        (tester) async {
      licenses.keptLicense = _license();
      licenses.server = _license();
      register();
      phone(tester);
      await tester.pumpWidget(app('/badge'));
      await tester.pumpAndSettle();

      expect(find.text('Licencia activa'), findsOneWidget);
      expect(find.text(' · Cooperativa Olivar del Sur'), findsOneWidget);
    });

    testWidgets('without a license there is no badge', (tester) async {
      register();
      phone(tester);
      await tester.pumpWidget(app('/badge'));
      await tester.pumpAndSettle();

      expect(find.text('Licencia activa'), findsNothing);
    });
  });
}
