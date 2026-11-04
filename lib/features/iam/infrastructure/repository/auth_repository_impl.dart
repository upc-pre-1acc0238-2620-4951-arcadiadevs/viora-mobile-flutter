import 'dart:async';

import 'package:viora/core/datastore/session_events.dart';
import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/domain/valueobject/registration.dart';
import 'package:viora/features/iam/domain/repository/auth_repository.dart';
import 'package:viora/features/iam/domain/valueobject/account_role.dart';
import 'package:viora/features/iam/infrastructure/remote/auth_api.dart';
import 'package:viora/features/iam/infrastructure/remote/auth_session_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/change_password_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/email_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/refresh_token_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/reset_password_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/sign_in_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/sign_up_request_dto.dart';
import 'package:viora/features/iam/infrastructure/remote/verify_email_request_dto.dart';
import 'package:viora/features/iam/infrastructure/mapper/auth_error_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.api, required this.sessionStore, this.sessionEvents});

  final AuthApi api;
  final SessionStore sessionStore;
  final SessionEvents? sessionEvents;

  @override
  Future<void> signIn(String email, String password) => _attempt(
        () => _saveSession(
          api.signIn(SignInRequestDto(email: email, password: password, role: AccountRole.app)),
        ),
        AuthErrorMapper.signIn,
      );

  @override
  Future<String> signUp(Registration registration) => _attempt(
        () async {
          final request = SignUpRequestDto.fromDomain(registration, role: AccountRole.app);
          return (await api.signUp(request)).email;
        },
        AuthErrorMapper.signUp,
      );

  @override
  Future<void> verifyEmail(String email, String code) => _attempt(
        () => _saveSession(api.verifyEmail(VerifyEmailRequestDto(email: email, code: code))),
        AuthErrorMapper.verifyEmail,
      );

  @override
  Future<void> resendCode(String email) => _attempt(
        () => api.resendCode(EmailRequestDto(email: email)),
        AuthErrorMapper.resendCode,
      );

  @override
  Future<void> requestPasswordReset(String email) =>
      _attempt(() => api.requestPasswordReset(EmailRequestDto(email: email)), (_) => null);

  @override
  Future<void> checkPasswordResetLink(String token) => _attempt(
        () => api.checkPasswordResetToken(token),
        AuthErrorMapper.checkPasswordResetLink,
      );

  @override
  Future<void> resetPassword(String token, String newPassword) => _attempt(
        () => api.resetPassword(token, ResetPasswordRequestDto(newPassword: newPassword)),
        AuthErrorMapper.resetPassword,
      );

  @override
  Future<bool> isSignedIn() => sessionStore.hasSession();

  @override
  Future<void> changePassword(String currentPassword, String newPassword) => _attempt(
        () => _saveSession(
          api.changePassword(
            ChangePasswordRequestDto(currentPassword: currentPassword, newPassword: newPassword),
          ),
        ),
        AuthErrorMapper.changePassword,
      );

  @override
  Future<void> signOut() async {
    final refreshToken = await sessionStore.refreshToken();
    await sessionStore.clear();
    sessionEvents?.notifySignedOut();
    // The phone is signed out already: the server may be asleep or out of reach.
    if (refreshToken != null) unawaited(_closeOnServer(refreshToken));
  }

  Future<void> _closeOnServer(String refreshToken) async {
    try {
      await api.signOut(RefreshTokenRequestDto(refreshToken: refreshToken));
    } on ApiException {
      // The refresh token expires by itself.
    } on ApiUnreachableException {
      // The refresh token expires by itself.
    }
  }

  Future<void> _saveSession(Future<AuthSessionDto> response) async {
    final session = (await response).toDomain();
    await sessionStore.save(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      userId: session.userId,
      email: session.email,
      role: session.role,
    );
  }

  /// Runs [call] and turns its errors into [AuthFailure]s; [onError] handles the statuses
  /// that mean something for this operation.
  Future<T> _attempt<T>(
    Future<T> Function() call,
    AuthFailure? Function(ApiException error) onError,
  ) async {
    try {
      return await call();
    } on ApiUnreachableException {
      throw const AuthOffline();
    } on ApiException catch (error) {
      throw onError(error) ??
          (error.status == 429 ? const AuthTooManyRequests() : const AuthUnexpected());
    }
  }
}
