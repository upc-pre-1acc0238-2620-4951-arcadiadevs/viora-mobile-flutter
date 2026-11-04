import 'dart:async';

/// Announces how the session of the phone ends.
class SessionEvents {
  final _expired = StreamController<void>.broadcast();
  final _ended = StreamController<void>.broadcast();

  /// The saved session can no longer be renewed (the refresh token expired, was reused or
  /// revoked), so the app can go back to sign-in.
  Stream<void> get expired => _expired.stream;

  /// The session ended for any reason, so what belongs to the account can be forgotten.
  Stream<void> get ended => _ended.stream;

  void notifyExpired() {
    _expired.add(null);
    _ended.add(null);
  }

  void notifySignedOut() => _ended.add(null);
}
