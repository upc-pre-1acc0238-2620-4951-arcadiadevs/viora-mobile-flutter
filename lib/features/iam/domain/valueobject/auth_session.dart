/// An open session of the account.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.role,
  });

  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;
  final String role;
}
