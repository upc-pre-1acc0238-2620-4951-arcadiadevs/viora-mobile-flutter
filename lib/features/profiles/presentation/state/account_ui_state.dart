import 'package:flutter/foundation.dart';
import 'package:viora/features/profiles/domain/entity/profile.dart';

/// What the top bar confirms for a moment.
enum AccountNotice { language, detailsSaved, passwordChanged }

@immutable
class AccountUiState {
  const AccountUiState({this.profile, this.signedOut = false, this.notice});

  /// Null while it loads or when it can't be read.
  final Profile? profile;
  final bool signedOut;

  final AccountNotice? notice;

  static const _keep = Object();

  AccountUiState copyWith({Profile? profile, bool? signedOut, Object? notice = _keep}) {
    return AccountUiState(
      profile: profile ?? this.profile,
      signedOut: signedOut ?? this.signedOut,
      notice: identical(notice, _keep) ? this.notice : notice as AccountNotice?,
    );
  }
}
