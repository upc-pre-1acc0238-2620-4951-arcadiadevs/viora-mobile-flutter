import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/designsystem/component/viora_underline_field.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/presentation/ui/iam_page.dart';
import 'package:viora/features/iam/presentation/ui/onboarding_page.dart';
import 'package:viora/features/iam/presentation/ui/welcome_page.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    setupDependencies();
  });
  tearDown(() => getIt.reset());

  Widget iamPage({bool createAccount = false}) => BlocProvider(
        create: (context) => getIt<IamViewModel>()..start(createAccount: createAccount),
        child: const IamPage(),
      );

  Widget app(Widget home, {Locale locale = const Locale('es')}) => MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      );

  // Phone sized, as the screens are laid out for.
  void phoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('the welcome shows the introduction and then the plate', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(app(const WelcomePage()));
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('BIENVENIDO A VIORA'), findsOneWidget);
    expect(find.text('Ya tengo una cuenta'), findsOneWidget);

    await tester.tap(find.text('Comenzar'));
    await tester.pump();
    // Halfway, both plates are still there and the first one no longer takes taps.
    await tester.pump(const Duration(milliseconds: 210));
    expect(find.text('BIENVENIDO A VIORA'), findsOneWidget);
    expect(find.text('PARA GESTORES TÉCNICOS'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('BIENVENIDO A VIORA'), findsNothing);

    expect(find.text('PARA GESTORES TÉCNICOS'), findsOneWidget);
    expect(find.text('Omitir'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the welcome stays still when the phone turns animations off', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: app(const WelcomePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BIENVENIDO A VIORA'), findsOneWidget);
  });

  testWidgets('the onboarding reaches the summary with no layout errors', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(app(const OnboardingPage()));
    await tester.pumpAndSettle();

    expect(find.text('01 / 03'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Rubén Ticona');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.text('02 / 03'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '951406118');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.text('03 / 03'), findsOneWidget);
    await tester.tap(find.text('Ahora no'));
    await tester.pumpAndSettle();

    expect(find.text('Rubén Ticona'), findsOneWidget);
    expect(find.text('+51 951 406 118'), findsOneWidget);
    expect(find.text('Desactivadas'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the sign-in enables its button with valid data', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(app(iamPage()));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'rosa@example.com');
    await tester.enterText(find.byType(TextField).last, 'Clave1234');
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('creating the account marks the password rules as they are met', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(app(iamPage(createAccount: true)));
    await tester.pumpAndSettle();

    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(find.text('8 caracteres'), findsOneWidget);
    expect(find.text('Letras y números'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping the label of a field focuses it', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(
      app(Scaffold(body: VioraUnderlineField(label: 'Contraseña', value: '', onChanged: (_) {}))),
    );

    await tester.tap(find.text('Contraseña'));
    await tester.pump();

    expect(tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus, isTrue);
  });

  testWidgets('the screens also read in English', (tester) async {
    phoneSize(tester);
    await tester.pumpWidget(app(const WelcomePage(), locale: const Locale('en')));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('WELCOME TO VIORA'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });
}
