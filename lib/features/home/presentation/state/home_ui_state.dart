import 'package:flutter/foundation.dart';

/// What the Home shows.
///
/// Only the parts that already have data behind them live here (greeting and
/// alerts). Once plots are integrated this becomes a `sealed class` with mutually
/// exclusive states (`Loading`, `Error`, `NoPlots`, `Content`).
@immutable
class HomeUiState {
  const HomeUiState({
    this.displayName,
    this.hasUnreadAlerts = false,
  });

  /// Full name of the profile; `null` while it isn't known.
  final String? displayName;

  /// Shows the notice dot on the bell.
  final bool hasUnreadAlerts;

  HomeUiState copyWith({String? displayName, bool? hasUnreadAlerts}) {
    return HomeUiState(
      displayName: displayName ?? this.displayName,
      hasUnreadAlerts: hasUnreadAlerts ?? this.hasUnreadAlerts,
    );
  }
}
