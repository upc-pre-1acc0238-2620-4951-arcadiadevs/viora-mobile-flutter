import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/iam/application/usecase/sign_out_use_case.dart';
import 'package:viora/features/profiles/application/usecase/refresh_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/watch_current_profile_use_case.dart';
import 'package:viora/features/profiles/presentation/state/account_ui_state.dart';

/// Shows the kept profile right away and updates it when the download arrives.
class AccountViewModel extends Cubit<AccountUiState> {
  AccountViewModel({
    required WatchCurrentProfileUseCase watchProfile,
    required RefreshProfileUseCase refreshProfile,
    required this.signOutUseCase,
  }) : super(const AccountUiState()) {
    _profile = watchProfile.execute().listen(
      (profile) => emit(state.copyWith(profile: profile)),
    );
    unawaited(refreshProfile.execute());
  }

  static const _noticeTime = Duration(seconds: 3);

  final SignOutUseCase signOutUseCase;

  late final StreamSubscription<void> _profile;
  Timer? _notice;

  void showNotice(AccountNotice notice) {
    _notice?.cancel();
    emit(state.copyWith(notice: notice));
    _notice = Timer(_noticeTime, () => emit(state.copyWith(notice: null)));
  }

  Future<void> signOut() async {
    await signOutUseCase.execute();
    if (!isClosed) emit(state.copyWith(signedOut: true));
  }

  @override
  Future<void> close() {
    _notice?.cancel();
    _profile.cancel();
    return super.close();
  }
}
