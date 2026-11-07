import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/iam/application/usecase/sign_out_use_case.dart';
import 'package:viora/features/subscription/application/usecase/activate_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/get_account_email_use_case.dart';
import 'package:viora/features/subscription/application/usecase/get_kept_license_use_case.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';
import 'package:viora/features/subscription/domain/valueobject/manager_code.dart';
import 'package:viora/features/subscription/presentation/state/license_activation_ui_state.dart';

/// Typing the code that activates the license, and the license it activated.
class LicenseActivationViewModel extends Cubit<LicenseActivationUiState> {
  LicenseActivationViewModel({
    required this.activateLicense,
    required this.getKeptLicense,
    required this.getAccountEmail,
    required this.signOutUseCase,
    DateTime Function()? now,
  })  : _now = now ?? DateTime.now,
        super(const LicenseActivationUiState());

  final ActivateLicenseUseCase activateLicense;
  final GetKeptLicenseUseCase getKeptLicense;
  final GetAccountEmailUseCase getAccountEmail;
  final SignOutUseCase signOutUseCase;
  final DateTime Function() _now;

  Future<void> start() async {
    final email = await getAccountEmail.execute();
    final kept = await getKeptLicense.execute();
    if (isClosed) return;
    emit(state.copyWith(email: email, expired: kept != null && !kept.isActiveAt(_now())));
  }

  void onCode(String value) {
    var code = ManagerCode.normalize(value);
    if (code.length > ManagerCode.length) code = code.substring(0, ManagerCode.length);
    emit(state.copyWith(code: code, failure: null));
  }

  Future<void> activate() async {
    final code = ManagerCode.tryParse(state.code);
    if (code == null || state.loading) return;
    emit(state.copyWith(loading: true, failure: null));
    try {
      final license = await activateLicense.execute(code);
      if (!isClosed) emit(state.copyWith(loading: false, activated: license));
    } on LicenseAlreadyHeld {
      if (!isClosed) emit(state.copyWith(loading: false, alreadyLicensed: true));
    } on LicenseFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(loading: false, failure: failure));
    }
  }

  Future<void> signOut() async {
    await signOutUseCase.execute();
    if (!isClosed) emit(state.copyWith(signedOut: true));
  }
}
