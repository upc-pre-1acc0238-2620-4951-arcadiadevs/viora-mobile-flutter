import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/iam/infrastructure/remote/auth_session_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/email_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/reset_password_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/sign_in_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/sign_up_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/sign_up_response_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/verify_email_request_dto.dart';

/// Authentication endpoints of the backend.
class AuthApi {
  const AuthApi({required this.client});

  final ApiClient client;

  Future<AuthSessionDto> signIn(SignInRequestDto request) async =>
      AuthSessionDto.fromJson(await client.post('auth/sign-in', request.toMap()));

  Future<SignUpResponseDto> signUp(SignUpRequestDto request) async =>
      SignUpResponseDto.fromJson(await client.post('auth/sign-up', request.toMap()));

  Future<AuthSessionDto> verifyEmail(VerifyEmailRequestDto request) async =>
      AuthSessionDto.fromJson(await client.post('auth/email-verifications', request.toMap()));

  Future<void> resendCode(EmailRequestDto request) =>
      client.post('auth/email-verification-codes', request.toMap());

  Future<void> requestPasswordReset(EmailRequestDto request) =>
      client.post('auth/password-reset-tokens', request.toMap());

  Future<void> checkPasswordResetToken(String token) =>
      client.get('auth/password-reset-tokens/${Uri.encodeComponent(token)}');

  Future<void> resetPassword(String token, ResetPasswordRequestDto request) => client.put(
        'auth/password-reset-tokens/${Uri.encodeComponent(token)}',
        request.toMap(),
      );
}
