import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/iam/application/usecase/is_signed_in_use_case.dart';
import 'package:viora/features/subscription/application/usecase/refresh_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/watch_current_license_use_case.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';

/// Keeps the manager in the app only while the license is in force. True once it ran out or was
/// taken away: the manager then goes back to the license check, which opens the activation.
class LicenseGuardViewModel extends Cubit<bool> {
  LicenseGuardViewModel({
    required WatchCurrentLicenseUseCase watchLicense,
    required this.refreshLicense,
    required this.isSignedIn,
    this.onLicenseEnded,
    DateTime Function()? now,
  })  : _now = now ?? DateTime.now,
        super(false) {
    _license = watchLicense.execute().listen(_onLicense);
  }

  final RefreshLicenseUseCase refreshLicense;
  final IsSignedInUseCase isSignedIn;

  /// Forgets what the phone kept of the license, once the manager is sent back.
  final Future<void> Function()? onLicenseEnded;
  final DateTime Function() _now;
  late final StreamSubscription<ManagerLicense?> _license;
  Timer? _end;

  /// Back in the app: the server may have taken the license away in the meantime.
  Future<void> recheck() async {
    try {
      await refreshLicense.execute();
    } on LicenseFailure {
      // Without an answer, the kept license and its end date still decide.
    }
  }

  Future<void> _onLicense(ManagerLicense? license) async {
    _end?.cancel();
    if (license == null) {
      // A session that ended opens the sign-in by itself; only a signed-in manager is sent back.
      if (await isSignedIn.execute()) _leave();
      return;
    }
    final now = _now();
    if (!license.isActiveAt(now)) {
      _leave();
      return;
    }
    _end = Timer(license.endsAt.difference(now), _leave);
  }

  void _leave() {
    if (isClosed || state) return;
    onLicenseEnded?.call();
    emit(true);
  }

  @override
  Future<void> close() {
    _end?.cancel();
    _license.cancel();
    return super.close();
  }
}
