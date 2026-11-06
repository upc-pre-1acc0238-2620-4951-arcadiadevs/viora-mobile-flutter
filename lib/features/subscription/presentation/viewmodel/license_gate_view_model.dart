import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/iam/application/usecase/sign_out_use_case.dart';
import 'package:viora/features/subscription/application/usecase/get_kept_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/refresh_license_use_case.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';
import 'package:viora/features/subscription/presentation/state/license_gate_ui_state.dart';

/// Decides, once signed in, whether the manager opens the Home or has to activate a license.
class LicenseGateViewModel extends Cubit<LicenseGateUiState> {
  LicenseGateViewModel({
    required this.getKeptLicense,
    required this.refreshLicense,
    required this.signOutUseCase,
    DateTime Function()? now,
  })  : _now = now ?? DateTime.now,
        super(const LicenseGateUiState());

  final GetKeptLicenseUseCase getKeptLicense;
  final RefreshLicenseUseCase refreshLicense;
  final SignOutUseCase signOutUseCase;
  final DateTime Function() _now;

  Future<void> check() async {
    emit(const LicenseGateUiState());
    final kept = await getKeptLicense.execute();
    if (isClosed) return;
    // A kept license in force opens the Home right away, with or without a connection, and is
    // brought up to date on the way.
    if (kept != null && kept.isActiveAt(_now())) {
      unawaited(_refreshQuietly());
      emit(state.copyWith(destination: LicenseGateDestination.home));
      return;
    }
    try {
      final license = await refreshLicense.execute();
      if (isClosed) return;
      final active = license != null && license.isActiveAt(_now());
      emit(state.copyWith(
        destination: active ? LicenseGateDestination.home : LicenseGateDestination.activation,
      ));
    } on LicenseFailure catch (failure) {
      // An answer the server couldn't give is never taken as "no license".
      if (!isClosed) emit(state.copyWith(failure: failure));
    }
  }

  Future<void> signOut() async {
    await signOutUseCase.execute();
    if (!isClosed) emit(state.copyWith(signedOut: true));
  }

  Future<void> _refreshQuietly() async {
    try {
      await refreshLicense.execute();
    } on LicenseFailure {
      // The kept license stays.
    }
  }
}
