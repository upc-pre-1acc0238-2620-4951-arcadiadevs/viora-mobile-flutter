import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/has_active_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/home/presentation/state/home_ui_state.dart';
import 'package:viora/features/profiles/application/usecase/refresh_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/watch_current_profile_use_case.dart';
import 'package:viora/features/subscription/application/usecase/watch_current_license_use_case.dart';

/// Holds the greeting of the Home and of the tabs that open with it: the manager's name, the
/// organization of their license and the dot of the bell while a sector alert is active.
class HomeViewModel extends Cubit<HomeUiState> {
  HomeViewModel({
    required WatchCurrentProfileUseCase watchProfile,
    required RefreshProfileUseCase refreshProfile,
    required WatchCurrentLicenseUseCase watchLicense,
    required HasActiveSectorAlertsUseCase hasActiveAlerts,
  }) : super(const HomeUiState()) {
    _profile = watchProfile.execute().listen((profile) {
      if (profile != null) _emit(state.copyWith(displayName: profile.fullName));
    });
    _license = watchLicense.execute().listen((license) {
      if (license != null) _emit(state.copyWith(organizationName: license.organizationName));
    });
    unawaited(refreshProfile.execute());
    unawaited(_readAlerts(hasActiveAlerts));
  }

  late final StreamSubscription<void> _profile;
  late final StreamSubscription<void> _license;

  Future<void> _readAlerts(HasActiveSectorAlertsUseCase hasActiveAlerts) async {
    try {
      // Read first: the state may change while the server answers.
      final active = await hasActiveAlerts.execute();
      _emit(state.copyWith(hasUnreadAlerts: active));
    } on CooperativeFailure {
      // The dot is a hint: without it the bell still opens the alerts.
    }
  }

  void _emit(HomeUiState next) {
    if (!isClosed) emit(next);
  }

  @override
  Future<void> close() {
    _profile.cancel();
    _license.cancel();
    return super.close();
  }
}
