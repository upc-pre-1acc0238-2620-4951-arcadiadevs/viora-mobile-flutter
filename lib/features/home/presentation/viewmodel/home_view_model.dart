import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/home/presentation/state/home_ui_state.dart';
import 'package:viora/features/profiles/application/usecase/refresh_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/watch_current_profile_use_case.dart';

/// Holds the Home greeting, voice line and alerts badge.
///
/// TODO(home): read the active alerts from telemetry, through a use case in `application/`.
class HomeViewModel extends Cubit<HomeUiState> {
  HomeViewModel({
    required WatchCurrentProfileUseCase watchProfile,
    required RefreshProfileUseCase refreshProfile,
  }) : super(const HomeUiState()) {
    _profile = watchProfile.execute().listen((profile) {
      if (profile != null) emit(state.copyWith(displayName: profile.fullName));
    });
    unawaited(refreshProfile.execute());
  }

  late final StreamSubscription<void> _profile;

  @override
  Future<void> close() {
    _profile.cancel();
    return super.close();
  }
}
