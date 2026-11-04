import 'package:flutter/foundation.dart';
import 'package:viora/core/domain/account_rules.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';

@immutable
class ChangePasswordUiState {
  const ChangePasswordUiState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.loading = false,
    this.changed = false,
    this.failure,
  });

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool loading;
  final bool changed;
  final AuthFailure? failure;

  bool get longEnough => PasswordPolicy.isLongEnough(newPassword);
  bool get hasLettersAndDigits => PasswordPolicy.hasLettersAndDigits(newPassword);
  bool get differsFromCurrent => newPassword.isNotEmpty && newPassword != currentPassword;
  bool get newPasswordValid => longEnough && hasLettersAndDigits && differsFromCurrent;

  /// How many of the four segments of the strength bar fill: one per rule, the fourth when all pass.
  int get strength {
    if (newPassword.isEmpty) return 0;
    if (newPasswordValid) return 4;
    final met = [longEnough, hasLettersAndDigits, differsFromCurrent].where((rule) => rule).length;
    return met < 1 ? 1 : met;
  }

  /// The rules are judged once the password reaches the minimum length, not on the first key.
  bool get showRuleErrors => longEnough || (newPassword.isNotEmpty && !differsFromCurrent);

  bool get confirmMismatch =>
      confirmPassword.isNotEmpty &&
      confirmPassword != newPassword &&
      confirmPassword.length >= newPassword.length;

  bool get canSubmit =>
      currentPassword.isNotEmpty && newPasswordValid && confirmPassword == newPassword;

  static const _keep = Object();

  ChangePasswordUiState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? loading,
    bool? changed,
    Object? failure = _keep,
  }) {
    return ChangePasswordUiState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      loading: loading ?? this.loading,
      changed: changed ?? this.changed,
      failure: identical(failure, _keep) ? this.failure : failure as AuthFailure?,
    );
  }
}
