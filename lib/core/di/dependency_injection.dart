import 'package:get_it/get_it.dart';
import 'package:viora/core/database/app_database.dart';
import 'package:viora/core/datastore/session_events.dart';
import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/locale/app_language.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_intake_forecasts_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_invitation_codes_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_member_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_members_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_provisional_dossier_pdf_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_provisional_dossier_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plot_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_risk_plots_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/has_active_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/issue_invitation_codes_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/revoke_invitation_code_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/sector_use_cases.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';
import 'package:viora/features/cooperative_operations/domain/repository/dossier_repository.dart';
import 'package:viora/features/cooperative_operations/domain/repository/intake_repository.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';
import 'package:viora/features/cooperative_operations/domain/repository/sector_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/local/device_document_exporter.dart';
import 'package:viora/features/cooperative_operations/infrastructure/local/device_location_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/cooperative_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/dossier_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/intake_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/risk_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/sector_api.dart';
import 'package:viora/features/cooperative_operations/infrastructure/repository/cooperative_repository_impl.dart';
import 'package:viora/features/cooperative_operations/infrastructure/repository/dossier_repository_impl.dart';
import 'package:viora/features/cooperative_operations/infrastructure/repository/intake_repository_impl.dart';
import 'package:viora/features/cooperative_operations/infrastructure/repository/risk_repository_impl.dart';
import 'package:viora/features/cooperative_operations/infrastructure/repository/sector_repository_impl.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/codes_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/issue_codes_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/manager_alerts_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/manager_home_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/member_detail_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/members_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/provisional_dossier_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/risk_map_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/risk_plot_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/sector_detail_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/sectors_view_model.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:viora/features/iam/application/usecase/change_password_use_case.dart';
import 'package:viora/features/iam/application/usecase/check_password_reset_link_use_case.dart';
import 'package:viora/features/iam/application/usecase/is_signed_in_use_case.dart';
import 'package:viora/features/iam/application/usecase/request_password_reset_use_case.dart';
import 'package:viora/features/iam/application/usecase/resend_code_use_case.dart';
import 'package:viora/features/iam/application/usecase/reset_password_use_case.dart';
import 'package:viora/features/iam/application/usecase/sign_in_use_case.dart';
import 'package:viora/features/iam/application/usecase/sign_out_use_case.dart';
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
import 'package:viora/features/profiles/application/usecase/get_current_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/refresh_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/update_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/watch_current_profile_use_case.dart';
import 'package:viora/features/profiles/domain/repository/profile_repository.dart';
import 'package:viora/features/profiles/infrastructure/local/profile_store.dart';
import 'package:viora/features/profiles/infrastructure/remote/profile_api.dart';
import 'package:viora/features/profiles/infrastructure/repository/profile_repository_impl.dart';
import 'package:viora/features/profiles/presentation/viewmodel/account_view_model.dart';
import 'package:viora/features/profiles/presentation/viewmodel/change_password_view_model.dart';
import 'package:viora/features/profiles/presentation/viewmodel/edit_profile_view_model.dart';
import 'package:viora/features/subscription/application/usecase/activate_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/get_account_email_use_case.dart';
import 'package:viora/features/subscription/application/usecase/get_kept_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/get_kept_producer_plan_catalog_use_case.dart';
import 'package:viora/features/subscription/application/usecase/refresh_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/refresh_producer_plan_catalog_use_case.dart';
import 'package:viora/features/subscription/application/usecase/watch_current_license_use_case.dart';
import 'package:viora/features/subscription/domain/repository/license_repository.dart';
import 'package:viora/features/subscription/domain/repository/producer_plan_repository.dart';
import 'package:viora/features/subscription/infrastructure/local/manager_license_dao.dart';
import 'package:viora/features/subscription/infrastructure/remote/license_api.dart';
import 'package:viora/features/subscription/infrastructure/remote/producer_plan_api.dart';
import 'package:viora/features/subscription/infrastructure/repository/license_repository_impl.dart';
import 'package:viora/features/subscription/infrastructure/repository/producer_plan_repository_impl.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_activation_view_model.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_gate_view_model.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_guard_view_model.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_status_view_model.dart';
import 'package:viora/features/subscription/presentation/viewmodel/producer_plan_view_model.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  _setupCore();
  _setupIam();
  _setupProfiles();
  _setupSubscription();
  _setupCooperativeOperations();
  _setupTerritorialRisk();
  _setupViewModels();
}

void _setupCooperativeOperations() {
  getIt.registerLazySingleton<CooperativeApi>(() => CooperativeApi(client: getIt<ApiClient>()));
  getIt.registerLazySingleton<CooperativeRepository>(
    () => CooperativeRepositoryImpl(api: getIt<CooperativeApi>()),
  );
  getIt.registerLazySingleton(() => GetLicenseCapacityUseCase(repository: getIt<CooperativeRepository>()));
  getIt.registerLazySingleton(() => GetMembersUseCase(repository: getIt<CooperativeRepository>()));
  getIt.registerLazySingleton(() => GetMemberUseCase(repository: getIt<CooperativeRepository>()));
  getIt.registerLazySingleton(() => GetInvitationCodesUseCase(repository: getIt<CooperativeRepository>()));
  getIt.registerLazySingleton(() => IssueInvitationCodesUseCase(repository: getIt<CooperativeRepository>()));
  getIt.registerLazySingleton(() => RevokeInvitationCodeUseCase(repository: getIt<CooperativeRepository>()));
  getIt.registerLazySingleton<SectorApi>(() => SectorApi(client: getIt<ApiClient>()));
  getIt.registerLazySingleton<SectorRepository>(() => SectorRepositoryImpl(api: getIt<SectorApi>()));
  getIt.registerLazySingleton(() => GetSectorsUseCase(repository: getIt<SectorRepository>()));
  getIt.registerLazySingleton(() => SaveSectorUseCase(repository: getIt<SectorRepository>()));
  getIt.registerLazySingleton(() => ResolvePendingSectorUseCase(repository: getIt<SectorRepository>()));
  getIt.registerFactory<SectorsViewModel>(
    () => SectorsViewModel(
      getSectors: getIt<GetSectorsUseCase>(),
      saveSector: getIt<SaveSectorUseCase>(),
      resolvePending: getIt<ResolvePendingSectorUseCase>(),
    ),
  );

  getIt.registerFactory<MembersViewModel>(
    () => MembersViewModel(
      getCapacity: getIt<GetLicenseCapacityUseCase>(),
      getMembers: getIt<GetMembersUseCase>(),
      getCodes: getIt<GetInvitationCodesUseCase>(),
      getSectors: getIt<GetSectorsUseCase>(),
    ),
  );
  getIt.registerFactory<MemberDetailViewModel>(
    () => MemberDetailViewModel(
      getMember: getIt<GetMemberUseCase>(),
      getCapacity: getIt<GetLicenseCapacityUseCase>(),
    ),
  );
  getIt.registerFactory<CodesViewModel>(
    () => CodesViewModel(
      getCodes: getIt<GetInvitationCodesUseCase>(),
      getCapacity: getIt<GetLicenseCapacityUseCase>(),
      revokeCode: getIt<RevokeInvitationCodeUseCase>(),
    ),
  );
  // G43 opens with the capacity G40 or G42 already read.
  getIt.registerFactoryParam<IssueCodesViewModel, LicenseCapacity, void>(
    (capacity, _) => IssueCodesViewModel(
      capacity: capacity,
      issueCodes: getIt<IssueInvitationCodesUseCase>(),
      getCapacity: getIt<GetLicenseCapacityUseCase>(),
    ),
  );
}

void _setupTerritorialRisk() {
  getIt.registerLazySingleton<RiskApi>(() => RiskApi(client: getIt<ApiClient>()));
  getIt.registerLazySingleton<RiskRepository>(() => RiskRepositoryImpl(api: getIt<RiskApi>()));
  // One instance: G22 reuses the place the map found.
  getIt.registerLazySingleton<LocationRepository>(() => DeviceLocationRepository());
  getIt.registerLazySingleton(() => GetRiskPlotsUseCase(repository: getIt<RiskRepository>()));
  getIt.registerLazySingleton(() => GetRiskPlotUseCase(repository: getIt<RiskRepository>()));
  getIt.registerLazySingleton(() => HasActiveSectorAlertsUseCase(repository: getIt<RiskRepository>()));
  getIt.registerLazySingleton(() => GetSectorAlertsUseCase(repository: getIt<RiskRepository>()));

  getIt.registerFactory<RiskMapViewModel>(
    () => RiskMapViewModel(
      getPlots: getIt<GetRiskPlotsUseCase>(),
      getPlot: getIt<GetRiskPlotUseCase>(),
      hasActiveAlerts: getIt<HasActiveSectorAlertsUseCase>(),
      location: getIt<LocationRepository>(),
    ),
  );
  getIt.registerFactory<SectorDetailViewModel>(
    () => SectorDetailViewModel(getPlots: getIt<GetRiskPlotsUseCase>(), location: getIt<LocationRepository>()),
  );
  getIt.registerFactory<RiskPlotViewModel>(() => RiskPlotViewModel(getPlot: getIt<GetRiskPlotUseCase>()));
  getIt.registerFactory<ManagerAlertsViewModel>(() => ManagerAlertsViewModel(getAlerts: getIt<GetSectorAlertsUseCase>()));

  getIt.registerLazySingleton<IntakeApi>(() => IntakeApi(client: getIt<ApiClient>()));
  getIt.registerLazySingleton<IntakeRepository>(() => IntakeRepositoryImpl(api: getIt<IntakeApi>()));
  getIt.registerLazySingleton(() => GetIntakeForecastsUseCase(repository: getIt<IntakeRepository>()));
  getIt.registerFactory<ManagerHomeViewModel>(
    () => ManagerHomeViewModel(
      getPlots: getIt<GetRiskPlotsUseCase>(),
      getCapacity: getIt<GetLicenseCapacityUseCase>(),
      getAlerts: getIt<GetSectorAlertsUseCase>(),
      getIntake: getIt<GetIntakeForecastsUseCase>(),
      location: getIt<LocationRepository>(),
    ),
  );

  getIt.registerLazySingleton<DossierApi>(() => DossierApi(client: getIt<ApiClient>()));
  getIt.registerLazySingleton<DossierRepository>(() => DossierRepositoryImpl(api: getIt<DossierApi>()));
  getIt.registerLazySingleton<DocumentExporter>(() => const DeviceDocumentExporter());
  getIt.registerLazySingleton(() => GetProvisionalDossierUseCase(repository: getIt<DossierRepository>()));
  getIt.registerLazySingleton(() => GetProvisionalDossierPdfUseCase(repository: getIt<DossierRepository>()));
  getIt.registerFactory<ProvisionalDossierViewModel>(
    () => ProvisionalDossierViewModel(
      getDossier: getIt<GetProvisionalDossierUseCase>(),
      getPdf: getIt<GetProvisionalDossierPdfUseCase>(),
      exporter: getIt<DocumentExporter>(),
    ),
  );
}

void _setupSubscription() {
  getIt.registerLazySingleton<LicenseApi>(() => LicenseApi(client: getIt<ApiClient>()));
  getIt.registerLazySingleton<ManagerLicenseDao>(() => ManagerLicenseDao(getIt<AppDatabase>()));
  getIt.registerLazySingleton<LicenseRepository>(
    () => LicenseRepositoryImpl(
      api: getIt<LicenseApi>(),
      dao: getIt<ManagerLicenseDao>(),
      sessionStore: getIt<SessionStore>(),
    ),
  );
  getIt.registerLazySingleton<WatchCurrentLicenseUseCase>(
    () => WatchCurrentLicenseUseCase(repository: getIt<LicenseRepository>()),
  );
  getIt.registerLazySingleton<GetKeptLicenseUseCase>(
    () => GetKeptLicenseUseCase(repository: getIt<LicenseRepository>()),
  );
  getIt.registerLazySingleton<RefreshLicenseUseCase>(
    () => RefreshLicenseUseCase(repository: getIt<LicenseRepository>()),
  );
  getIt.registerLazySingleton<ActivateLicenseUseCase>(
    () => ActivateLicenseUseCase(repository: getIt<LicenseRepository>()),
  );
  getIt.registerLazySingleton<GetAccountEmailUseCase>(
    () => GetAccountEmailUseCase(repository: getIt<LicenseRepository>()),
  );
  getIt.registerLazySingleton<ProducerPlanApi>(() => ProducerPlanApi(client: getIt<ApiClient>()));
  // A singleton, because it keeps the last catalog read for as long as the app runs.
  getIt.registerLazySingleton<ProducerPlanRepository>(
    () => ProducerPlanRepositoryImpl(api: getIt<ProducerPlanApi>()),
  );
  getIt.registerLazySingleton<GetKeptProducerPlanCatalogUseCase>(
    () => GetKeptProducerPlanCatalogUseCase(repository: getIt<ProducerPlanRepository>()),
  );
  getIt.registerLazySingleton<RefreshProducerPlanCatalogUseCase>(
    () => RefreshProducerPlanCatalogUseCase(repository: getIt<ProducerPlanRepository>()),
  );
}

void _setupCore() {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  getIt.registerLazySingleton<AppLanguageCubit>(() => AppLanguageCubit());
  getIt.registerLazySingleton<SessionStore>(() => const SessionStore());
  getIt.registerLazySingleton<SessionEvents>(() => SessionEvents());
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      sessionStore: getIt<SessionStore>(),
      sessionEvents: getIt<SessionEvents>(),
      languageTag: () => getIt<AppLanguageCubit>().languageTag,
    ),
  );
}

void _setupProfiles() {
  getIt.registerLazySingleton<ProfileStore>(() => ProfileStore());
  getIt.registerLazySingleton<ProfileApi>(() => ProfileApi(client: getIt<ApiClient>()));
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      api: getIt<ProfileApi>(),
      store: getIt<ProfileStore>(),
      sessionStore: getIt<SessionStore>(),
    ),
  );
  getIt.registerLazySingleton<GetCurrentProfileUseCase>(
    () => GetCurrentProfileUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<WatchCurrentProfileUseCase>(
    () => WatchCurrentProfileUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<RefreshProfileUseCase>(
    () => RefreshProfileUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(repository: getIt<ProfileRepository>()),
  );
}

void _setupIam() {
  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(client: getIt<ApiClient>()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      api: getIt<AuthApi>(),
      sessionStore: getIt<SessionStore>(),
      sessionEvents: getIt<SessionEvents>(),
    ),
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
  getIt.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      watchProfile: getIt<WatchCurrentProfileUseCase>(),
      refreshProfile: getIt<RefreshProfileUseCase>(),
      watchLicense: getIt<WatchCurrentLicenseUseCase>(),
      hasActiveAlerts: getIt<HasActiveSectorAlertsUseCase>(),
    ),
  );
  getIt.registerFactory<EditProfileViewModel>(
    () => EditProfileViewModel(
      getCurrentProfile: getIt<GetCurrentProfileUseCase>(),
      updateProfile: getIt<UpdateProfileUseCase>(),
    ),
  );
  getIt.registerFactory<ChangePasswordViewModel>(
    () => ChangePasswordViewModel(changePassword: getIt<ChangePasswordUseCase>()),
  );
  getIt.registerFactory<AccountViewModel>(
    () => AccountViewModel(
      watchProfile: getIt<WatchCurrentProfileUseCase>(),
      refreshProfile: getIt<RefreshProfileUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );
  getIt.registerFactory<SplashViewModel>(
    () => SplashViewModel(isSignedIn: getIt<IsSignedInUseCase>()),
  );
  getIt.registerFactory<OnboardingViewModel>(
    () => OnboardingViewModel(repository: getIt<OnboardingRepository>()),
  );
  getIt.registerFactory<LicenseGateViewModel>(
    () => LicenseGateViewModel(
      getKeptLicense: getIt<GetKeptLicenseUseCase>(),
      refreshLicense: getIt<RefreshLicenseUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );
  getIt.registerFactory<LicenseActivationViewModel>(
    () => LicenseActivationViewModel(
      activateLicense: getIt<ActivateLicenseUseCase>(),
      getKeptLicense: getIt<GetKeptLicenseUseCase>(),
      getAccountEmail: getIt<GetAccountEmailUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );
  getIt.registerFactory<LicenseStatusViewModel>(
    () => LicenseStatusViewModel(
      watchLicense: getIt<WatchCurrentLicenseUseCase>(),
      refreshLicense: getIt<RefreshLicenseUseCase>(),
    ),
  );
  getIt.registerFactory<LicenseGuardViewModel>(
    () => LicenseGuardViewModel(
      watchLicense: getIt<WatchCurrentLicenseUseCase>(),
      refreshLicense: getIt<RefreshLicenseUseCase>(),
      isSignedIn: getIt<IsSignedInUseCase>(),
    ),
  );
  getIt.registerFactory<ProducerPlanViewModel>(
    () => ProducerPlanViewModel(
      getKeptCatalog: getIt<GetKeptProducerPlanCatalogUseCase>(),
      refreshCatalog: getIt<RefreshProducerPlanCatalogUseCase>(),
    ),
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

/// What belongs to the account stays on the phone only while its session lasts.
void forgetAccountDataWhenSessionEnds() {
  getIt<SessionEvents>().ended.listen((_) {
    getIt<ProfileRepository>().clear();
    getIt<LicenseRepository>().clear();
  });
}
