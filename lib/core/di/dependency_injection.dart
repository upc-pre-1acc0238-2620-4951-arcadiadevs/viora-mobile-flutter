import 'package:get_it/get_it.dart';

import 'package:viora/core/database/app_database.dart';
import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/iam/application/usecase/check_password_reset_link_use_case.dart';
import 'package:viora/features/iam/application/usecase/is_signed_in_use_case.dart';
import 'package:viora/features/iam/application/usecase/request_password_reset_use_case.dart';
import 'package:viora/features/iam/application/usecase/resend_code_use_case.dart';
import 'package:viora/features/iam/application/usecase/reset_password_use_case.dart';
import 'package:viora/features/iam/application/usecase/sign_in_use_case.dart';
import 'package:viora/features/iam/application/usecase/sign_up_use_case.dart';
import 'package:viora/features/iam/application/usecase/verify_email_use_case.dart';
import 'package:viora/features/iam/domain/repository/auth_repository.dart';
import 'package:viora/features/iam/domain/repository/onboarding_repository.dart';
import 'package:viora/features/iam/infrastructure/local/onboarding_store.dart';
import 'package:viora/features/iam/infrastructure/remote/auth_api.dart';
import 'package:viora/features/iam/infrastructure/repository/auth_repository_impl.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';
import 'package:viora/features/iam/presentation/viewmodel/onboarding_view_model.dart';
import 'package:viora/features/iam/presentation/viewmodel/splash_view_model.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  _setupCore();
  _setupIam();
  _setupViewModels();
}

void _setupCore() {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<SessionStore>(() => const SessionStore());
}

void _setupIam() {
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(client: getIt<ApiClient>()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(api: getIt<AuthApi>(), sessionStore: getIt<SessionStore>()),
  );
  getIt.registerLazySingleton<OnboardingRepository>(() => const OnboardingStore());

  getIt.registerLazySingleton<IsSignedInUseCase>(
    () => IsSignedInUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<VerifyEmailUseCase>(
    () => VerifyEmailUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ResendCodeUseCase>(
    () => ResendCodeUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RequestPasswordResetUseCase>(
    () => RequestPasswordResetUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<CheckPasswordResetLinkUseCase>(
    () => CheckPasswordResetLinkUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(repository: getIt<AuthRepository>()),
  );
}

// ViewModels hold screen state, so every screen gets a new instance.
void _setupViewModels() {
  getIt.registerFactory<HomeViewModel>(() => HomeViewModel());
  getIt.registerFactory<SplashViewModel>(
    () => SplashViewModel(isSignedIn: getIt<IsSignedInUseCase>()),
  );
  getIt.registerFactory<OnboardingViewModel>(
    () => OnboardingViewModel(repository: getIt<OnboardingRepository>()),
  );
  getIt.registerFactory<IamViewModel>(
    () => IamViewModel(
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      verifyEmailUseCase: getIt<VerifyEmailUseCase>(),
      resendCodeUseCase: getIt<ResendCodeUseCase>(),
      requestPasswordResetUseCase: getIt<RequestPasswordResetUseCase>(),
      checkPasswordResetLinkUseCase: getIt<CheckPasswordResetLinkUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      onboardingRepository: getIt<OnboardingRepository>(),
    ),
  );
}
