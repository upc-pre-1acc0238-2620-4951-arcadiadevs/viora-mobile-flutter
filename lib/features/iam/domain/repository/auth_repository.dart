import 'package:viora/features/iam/domain/valueobject/registration.dart';

/// The person's account. Every operation throws an AuthFailure when it can't complete.
abstract class AuthRepository {
  /// Changes the password; the phone stays signed in with a new session.
  Future<void> changePassword(String currentPassword, String newPassword);

  /// Closes the session on this phone, and on the server when it can be reached.
  Future<void> signOut();

  /// Opens a session.
  Future<void> signIn(String email, String password);

  /// Creates the account, which waits for its email code. Returns the email the code went to.
  Future<String> signUp(Registration registration);

  /// Checks the email code and, when it's right, opens the session.
  Future<void> verifyEmail(String email, String code);

  Future<void> resendCode(String email);

  Future<void> requestPasswordReset(String email);

  /// Whether the recovery link with [token] still works.
  Future<void> checkPasswordResetLink(String token);

  /// Sets a new password through the recovery link. The server closes every session.
  Future<void> resetPassword(String token, String newPassword);

  Future<bool> isSignedIn();
}
