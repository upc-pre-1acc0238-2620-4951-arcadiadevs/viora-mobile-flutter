/// Paths that features open without knowing the feature that serves them. The router maps
/// each one to its screen.
abstract final class AppRoutes {
  /// Signing in and creating the account.
  static const signIn = '/auth';

  /// Checks the license of the signed-in manager and opens the Home or its activation.
  static const licenseGate = '/license';
}
