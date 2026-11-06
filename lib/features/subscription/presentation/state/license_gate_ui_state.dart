import 'package:flutter/foundation.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';

/// Where the manager goes once the license is known.
enum LicenseGateDestination { home, activation }

@immutable
class LicenseGateUiState {
  const LicenseGateUiState({this.destination, this.failure, this.signedOut = false});

  /// Null while the license is being checked or the check failed.
  final LicenseGateDestination? destination;

  /// Why the license couldn't be checked, with nothing kept to fall back on.
  final LicenseFailure? failure;
  final bool signedOut;

  bool get checking => destination == null && failure == null;

  LicenseGateUiState copyWith({
    LicenseGateDestination? destination,
    LicenseFailure? failure,
    bool? signedOut,
  }) {
    return LicenseGateUiState(
      destination: destination ?? this.destination,
      failure: failure ?? this.failure,
      signedOut: signedOut ?? this.signedOut,
    );
  }
}
