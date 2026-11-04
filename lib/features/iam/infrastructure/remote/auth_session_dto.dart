import 'package:viora/features/iam/domain/valueobject/auth_session.dart';

class AuthSessionDto {
  const AuthSessionDto({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.role,
  });

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) => AuthSessionDto(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        userId: json['userId'] as String,
        email: json['email'] as String? ?? '',
        role: json['role'] as String,
      );

  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;
  final String role;

  AuthSession toDomain() => AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        email: email,
        role: role,
      );
}
