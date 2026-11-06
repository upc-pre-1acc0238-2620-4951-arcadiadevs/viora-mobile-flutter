import 'package:flutter/foundation.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';
import 'package:viora/features/subscription/domain/valueobject/manager_code.dart';

@immutable
class LicenseActivationUiState {
  const LicenseActivationUiState({
    this.code = '',
    this.email,
    this.expired = false,
    this.loading = false,
    this.failure,
    this.activated,
    this.alreadyLicensed = false,
    this.signedOut = false,
  });

  /// The code as typed, normalized.
  final String code;

  /// The email of the signed-in account; null until it is read.
  final String? email;

  /// The manager had a license that ran out.
  final bool expired;
  final bool loading;
  final LicenseFailure? failure;

  /// The license the code activated; null until then.
  final ManagerLicense? activated;

  /// The server says the manager already holds a license in force: the check runs again.
  final bool alreadyLicensed;
  final bool signedOut;

  bool get canActivate => !loading && ManagerCode.tryParse(code) != null;

  bool get codeRejected => failure is LicenseCodeNotRedeemable;

  static const _keep = Object();

  LicenseActivationUiState copyWith({
    String? code,
    String? email,
    bool? expired,
    bool? loading,
    Object? failure = _keep,
    ManagerLicense? activated,
    bool? alreadyLicensed,
    bool? signedOut,
  }) {
    return LicenseActivationUiState(
      code: code ?? this.code,
      email: email ?? this.email,
      expired: expired ?? this.expired,
      loading: loading ?? this.loading,
      failure: identical(failure, _keep) ? this.failure : failure as LicenseFailure?,
      activated: activated ?? this.activated,
      alreadyLicensed: alreadyLicensed ?? this.alreadyLicensed,
      signedOut: signedOut ?? this.signedOut,
    );
  }
}
