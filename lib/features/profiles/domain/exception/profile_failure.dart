/// Why saving the profile failed.
sealed class ProfileFailure implements Exception {
  const ProfileFailure();
}

/// The server couldn't be reached.
class ProfileOffline extends ProfileFailure {
  const ProfileOffline();
}

/// Anything else, shown as a generic failure.
class ProfileUnexpected extends ProfileFailure {
  const ProfileUnexpected();
}

/// The server refused the mobile number.
class ProfilePhoneRejected extends ProfileFailure {
  const ProfilePhoneRejected();
}
