import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/subscription/application/usecase/refresh_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/watch_current_license_use_case.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';

/// The kept license of the manager, for the screens that only show it. Null while there is none.
class LicenseStatusViewModel extends Cubit<ManagerLicense?> {
  LicenseStatusViewModel({
    required WatchCurrentLicenseUseCase watchLicense,
    required this.refreshLicense,
    DateTime Function()? now,
  })  : _now = now ?? DateTime.now,
        super(null) {
    _license = watchLicense.execute().listen((license) {
      if (!isClosed) emit(license);
    });
  }

  final RefreshLicenseUseCase refreshLicense;
  final DateTime Function() _now;
  late final StreamSubscription<ManagerLicense?> _license;

  bool get isActive => state?.isActiveAt(_now()) ?? false;

  /// Brings the kept license up to date. Without a connection, the kept one stays.
  Future<void> refresh() async {
    try {
      await refreshLicense.execute();
    } on LicenseFailure {
      // The kept license stays.
    }
  }

  @override
  Future<void> close() {
    _license.cancel();
    return super.close();
  }
}
