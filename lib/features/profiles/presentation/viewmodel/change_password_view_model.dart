import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/iam/application/usecase/change_password_use_case.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/profiles/presentation/state/change_password_ui_state.dart';

/// On success the phone keeps its session, with the tokens of the answer.
class ChangePasswordViewModel extends Cubit<ChangePasswordUiState> {
  ChangePasswordViewModel({required this.changePassword})
      : super(const ChangePasswordUiState());

  final ChangePasswordUseCase changePassword;

  void onCurrent(String value) => emit(state.copyWith(currentPassword: value, failure: null));

  void onNew(String value) => emit(state.copyWith(newPassword: value, failure: null));

  void onConfirm(String value) => emit(state.copyWith(confirmPassword: value, failure: null));

  Future<void> submit() async {
    if (!state.canSubmit || state.loading) return;
    emit(state.copyWith(loading: true, failure: null));
    try {
      await changePassword.execute(state.currentPassword, state.newPassword);
      if (!isClosed) emit(state.copyWith(loading: false, changed: true));
    } on AuthFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(loading: false, failure: failure));
    }
  }
}
