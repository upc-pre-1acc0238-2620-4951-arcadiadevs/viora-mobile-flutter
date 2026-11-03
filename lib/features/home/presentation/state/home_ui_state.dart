import 'package:flutter/foundation.dart';

/// What the Home shows.
///
/// Only the parts that belong to the Home itself live here (greeting, voice line and
/// alerts). The blocks of other features plug in as sections, with their own state.
@immutable
class HomeUiState {
  const HomeUiState({
    this.displayName,
    this.subtitle,
    this.voiceMessage,
    this.hasUnreadAlerts = false,
  });

  /// Full name of the profile; `null` while it isn't known.
  final String? displayName;

  /// Organization and role under the greeting; hidden while it isn't known.
  final String? subtitle;

  /// Line in the voice of Viora under the headline; hidden when there's nothing to say.
  final String? voiceMessage;

  /// Shows the notice dot on the bell.
  final bool hasUnreadAlerts;

  HomeUiState copyWith({
    String? displayName,
    String? subtitle,
    String? voiceMessage,
    bool? hasUnreadAlerts,
  }) {
    return HomeUiState(
      displayName: displayName ?? this.displayName,
      subtitle: subtitle ?? this.subtitle,
      voiceMessage: voiceMessage ?? this.voiceMessage,
      hasUnreadAlerts: hasUnreadAlerts ?? this.hasUnreadAlerts,
    );
  }
}
