import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/domain/account_rules.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/locale/app_language.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:viora/features/iam/application/usecase/change_password_use_case.dart';
import 'package:viora/features/iam/application/usecase/sign_out_use_case.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/presentation/ui/iam_page.dart';
import 'package:viora/features/profiles/application/usecase/get_current_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/refresh_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/update_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/watch_current_profile_use_case.dart';
import 'package:viora/features/profiles/domain/entity/profile.dart';
import 'package:viora/features/profiles/domain/exception/profile_failure.dart';
import 'package:viora/features/profiles/domain/repository/profile_repository.dart';
import 'package:viora/features/iam/domain/repository/auth_repository.dart';
import 'package:viora/features/profiles/presentation/ui/account_page.dart';
import 'package:viora/features/profiles/presentation/viewmodel/account_view_model.dart';
import 'package:viora/features/profiles/presentation/viewmodel/change_password_view_model.dart';
import 'package:viora/features/profiles/presentation/viewmodel/edit_profile_view_model.dart';

const _profile = Profile(
  id: 'profile-1',
  userId: 'user-1',
  fullName: 'Rubén Ticona',
  countryIso: 'PE',
  phoneNumber: '+51951406118',
  email: 'ruben@example.com',
);

class _FakeProfiles implements ProfileRepository {
  _FakeProfiles(this.profile, {this.failure});

  Profile? profile;
  final ProfileFailure? failure;
  final _changes = StreamController<Profile?>.broadcast();
  String? savedName;
  String? savedPhone;

  @override
  Future<Profile?> current() async => profile;

  @override
  Stream<Profile?> watchCurrent() async* {
    yield profile;
    yield* _changes.stream;
  }

  @override
  Future<void> refresh() async {}

  @override
  Future<void> clear() async {}

  @override
  Future<void> update({
    required String fullName,
    required String countryIso,
    required String phoneNumber,
  }) async {
    final failure = this.failure;
    if (failure != null) throw failure;
    savedName = fullName;
    savedPhone = phoneNumber;
  }
}

class _FakeAuth implements AuthRepository {
  int signOuts = 0;
  AuthFailure? failure;
  String? changedTo;

  @override
  Future<void> signOut() async => signOuts++;

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final failure = this.failure;
    if (failure != null) throw failure;
    changedTo = newPassword;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final auth = _FakeAuth();

  AccountViewModel viewModel(Profile? profile) => AccountViewModel(
        watchProfile: WatchCurrentProfileUseCase(repository: _FakeProfiles(profile)),
        refreshProfile: RefreshProfileUseCase(repository: _FakeProfiles(profile)),
        signOutUseCase: SignOutUseCase(repository: auth),
      );

  HomeViewModel homeOf(ProfileRepository profiles) => HomeViewModel(
        watchProfile: WatchCurrentProfileUseCase(repository: profiles),
        refreshProfile: RefreshProfileUseCase(repository: profiles),
      );

  test('the Home greets with the name of the profile', () async {
    final home = homeOf(_FakeProfiles(_profile));
    await Future<void>.delayed(Duration.zero);

    expect(home.state.displayName, 'Rubén Ticona');
  });

  test('the Home stays anonymous when the profile cannot be read', () async {
    final home = homeOf(_FakeProfiles(null));
    await Future<void>.delayed(Duration.zero);

    expect(home.state.displayName, isNull);
  });

  group('edit profile', () {
    Future<EditProfileViewModel> editing(_FakeProfiles profiles) async {
      final viewModel = EditProfileViewModel(
        getCurrentProfile: GetCurrentProfileUseCase(repository: profiles),
        updateProfile: UpdateProfileUseCase(repository: profiles),
      );
      await Future<void>.delayed(Duration.zero);
      return viewModel;
    }

    test('starts from the profile, with nothing to save', () async {
      final viewModel = await editing(_FakeProfiles(_profile));

      expect(viewModel.state.fullName, 'Rubén Ticona');
      expect(viewModel.state.phone, '951406118');
      expect(viewModel.state.canSave, isFalse);
    });

    test('saves the trimmed name and the number in E.164', () async {
      final profiles = _FakeProfiles(_profile);
      final viewModel = await editing(profiles);

      viewModel
        ..onName(' Rubén Ticona Paz ')
        ..onPhone('987-654-321-000');
      await viewModel.save();

      expect(profiles.savedName, 'Rubén Ticona Paz');
      expect(profiles.savedPhone, '+51987654321');
      expect(viewModel.state.saved, isTrue);
    });

    test('groups the digits of the mobile to read them', () {
      expect(PhoneCountry.pe.grouped('951406118'), '951 406 118');
      expect(PhoneCountry.pe.grouped('9514'), '951 4');
    });

    test('an empty name or an invalid number cannot be saved', () async {
      final viewModel = await editing(_FakeProfiles(_profile));

      viewModel.onName(' ');
      expect(viewModel.state.showNameError, isTrue);
      expect(viewModel.state.canSave, isFalse);

      viewModel
        ..onName('Rubén')
        ..onPhone('12345');
      expect(viewModel.state.showPhoneError, isTrue);
      expect(viewModel.state.canSave, isFalse);
    });

    test('a number the server refuses marks the field', () async {
      final viewModel = await editing(
        _FakeProfiles(_profile, failure: const ProfilePhoneRejected()),
      );

      viewModel.onPhone('987654321');
      await viewModel.save();

      expect(viewModel.state.showPhoneError, isTrue);
      expect(viewModel.state.saved, isFalse);
    });
  });

  group('change password', () {
    ChangePasswordViewModel changing() =>
        ChangePasswordViewModel(changePassword: ChangePasswordUseCase(repository: auth));

    void fill(ChangePasswordViewModel viewModel, String newPassword) => viewModel
      ..onCurrent('Clave1234')
      ..onNew(newPassword)
      ..onConfirm(newPassword);

    setUp(() {
      auth.failure = null;
      auth.changedTo = null;
    });

    test('the new password must meet every rule and match', () {
      final viewModel = changing();

      fill(viewModel, 'Clave1234');
      expect(viewModel.state.differsFromCurrent, isFalse);
      expect(viewModel.state.canSubmit, isFalse);

      fill(viewModel, 'solotexto');
      expect(viewModel.state.hasLettersAndDigits, isFalse);
      expect(viewModel.state.canSubmit, isFalse);

      fill(viewModel, 'Nueva1234');
      expect(viewModel.state.strength, 4);
      expect(viewModel.state.canSubmit, isTrue);

      viewModel.onConfirm('Nueva12345');
      expect(viewModel.state.confirmMismatch, isTrue);
      expect(viewModel.state.canSubmit, isFalse);
    });

    test('changes it with valid data', () async {
      final viewModel = changing();

      fill(viewModel, 'Nueva1234');
      await viewModel.submit();

      expect(auth.changedTo, 'Nueva1234');
      expect(viewModel.state.changed, isTrue);
    });

    test('a wrong current password stays on the screen', () async {
      auth.failure = const CurrentPasswordIncorrect();
      final viewModel = changing();

      fill(viewModel, 'Nueva1234');
      await viewModel.submit();

      expect(viewModel.state.failure, isA<CurrentPasswordIncorrect>());
      expect(viewModel.state.changed, isFalse);
    });
  });

  group('language', () {
    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    test('follows the phone until the person chooses one', () async {
      final cubit = AppLanguageCubit();
      await cubit.load();

      expect(cubit.state, isNull);
    });

    test('the choice is kept for the next time', () async {
      await AppLanguageCubit().choose(AppLanguage.english);

      final nextTime = AppLanguageCubit();
      await nextTime.load();

      expect(nextTime.state, AppLanguage.english);
      expect(nextTime.languageTag, 'en');
    });

    test('any language but Spanish reads as English', () {
      expect(AppLanguage.of(const Locale('es', 'PE')), AppLanguage.spanish);
      expect(AppLanguage.of(const Locale('fr')), AppLanguage.english);
    });
  });

  Widget app(AccountViewModel accountViewModel) {
    getIt.registerFactory<AccountViewModel>(() => accountViewModel);
    getIt.registerLazySingleton<AppLanguageCubit>(() => AppLanguageCubit());
    final router = GoRouter(
      initialLocation: AccountPage.path,
      routes: [
        GoRoute(path: AccountPage.path, builder: (context, state) => const AccountPage()),
        GoRoute(path: IamPage.path, builder: (context, state) => const Text('sign-in')),
      ],
    );
    return MaterialApp.router(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }

  tearDown(() => getIt.reset());

  testWidgets('the account shows the profile', (tester) async {
    await tester.pumpWidget(app(viewModel(_profile)));
    await tester.pumpAndSettle();

    expect(find.text('Mi cuenta'), findsOneWidget);
    expect(find.text('ruben@example.com'), findsOneWidget);
    expect(find.text('Rubén Ticona'), findsOneWidget);
    expect(find.text('+51 951 406 118'), findsOneWidget);
    expect(find.text('Cambiar contraseña'), findsOneWidget);
    expect(find.text('Idioma'), findsOneWidget);
    expect(find.text('Notificaciones'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('closing the session goes to sign-in', (tester) async {
    await tester.pumpWidget(app(viewModel(_profile)));
    await tester.pumpAndSettle();
    final before = auth.signOuts;

    await tester.ensureVisible(find.text('Cerrar sesión'));
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();

    expect(auth.signOuts, before + 1);
    expect(find.text('sign-in'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the language sheet answers the chosen language', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    await tester.pumpWidget(app(viewModel(_profile)));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Idioma'));
    await tester.tap(find.text('Idioma'));
    await tester.pumpAndSettle();
    expect(find.text('Cambiar a Español'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Change to English'));
    await tester.pumpAndSettle();

    expect(getIt<AppLanguageCubit>().state, AppLanguage.english);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('the account opens without a profile', (tester) async {
    await tester.pumpWidget(app(viewModel(null)));
    await tester.pumpAndSettle();

    expect(find.text('Cerrar sesión'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
