import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/domain/valueobject/registration.dart';
import 'package:viora/features/iam/infrastructure/remote/auth_api.dart';
import 'package:viora/features/iam/infrastructure/repository/auth_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const registration = Registration(
    email: 'rosa@example.com',
    password: 'Clave1234',
    fullName: 'Rosa Condori',
    countryIso: 'PE',
    nationalPhone: '987654321',
    termsAccepted: true,
  );

  const session = {
    'accessToken': 'access',
    'refreshToken': 'refresh',
    'tokenType': 'Bearer',
    'expiresIn': 900,
    'userId': 'user-1',
    'role': 'ROLE_TECHNICAL_MANAGER',
  };

  late http.Request lastRequest;

  AuthRepositoryImpl repository(int status, Map<String, dynamic> body, {Map<String, String>? headers}) {
    FlutterSecureStorage.setMockInitialValues({});
    final client = MockClient((request) async {
      lastRequest = request;
      return http.Response(
        jsonEncode(body),
        status,
        headers: headers ?? const {},
      );
    });
    return AuthRepositoryImpl(
      api: AuthApi(client: ApiClient(client: client)),
      sessionStore: const SessionStore(),
    );
  }

  group('signUp', () {
    test('sends the contract of the backend as a producer', () async {
      final email = await repository(202, {
        'userId': 'user-1',
        'email': 'rosa@example.com',
        'status': 'PENDING_VERIFICATION',
      }).signUp(registration);

      expect(email, 'rosa@example.com');
      expect(lastRequest.url.path, endsWith('/auth/sign-up'));
      expect(jsonDecode(lastRequest.body), {
        'email': 'rosa@example.com',
        'password': 'Clave1234',
        'role': 'ROLE_TECHNICAL_MANAGER',
        'termsAccepted': true,
        'profile': {
          'fullName': 'Rosa Condori',
          'country': 'PE',
          'phoneNumber': '+51987654321',
        },
      });
    });

    test('a taken email is EmailTaken', () {
      expect(
        repository(409, {'code': 'CONFLICT'}).signUp(registration),
        throwsA(isA<EmailTaken>()),
      );
    });

    test('the password rules of the server are WeakPassword', () {
      expect(
        repository(400, {
          'code': 'VALIDATION_ERROR',
          'violations': ['user.password.min_length'],
        }).signUp(registration),
        throwsA(isA<WeakPassword>()),
      );
    });

    test('an unknown validation error is not mistaken for a weak password', () {
      expect(
        repository(400, {'code': 'VALIDATION_ERROR'}).signUp(registration),
        throwsA(isA<AuthUnexpected>()),
      );
    });

    test('a pending email of another role is EmailPendingWithOtherRole', () {
      expect(
        repository(400, {'code': 'VALIDATION_ERROR', 'reason': 'user.role.sign_up_not_allowed'})
            .signUp(registration),
        throwsA(isA<EmailPendingWithOtherRole>()),
      );
    });

    test('a number the server refuses is PhoneRejected', () {
      expect(
        repository(422, {'code': 'BUSINESS_RULE_VIOLATION'}).signUp(registration),
        throwsA(isA<PhoneRejected>()),
      );
    });

    test('a recent code tells how long to wait', () {
      expect(
        repository(429, {'retryAfterSeconds': 30}).signUp(registration),
        throwsA(isA<CodeNotYetResendable>()
            .having((failure) => failure.retryAfterSeconds, 'seconds', 30)),
      );
    });
  });

  group('changePassword', () {
    test('saves the session of the answer', () async {
      final repo = repository(200, session);

      await repo.changePassword('Clave1234', 'Nueva1234');

      expect(lastRequest.method, 'PATCH');
      expect(lastRequest.url.path, endsWith('/auth/passwords'));
      expect(await repo.isSignedIn(), isTrue);
    });

    test('a wrong current password is CurrentPasswordIncorrect', () {
      expect(
        repository(422, {'reason': 'user.password.current_invalid'})
            .changePassword('x', 'Nueva1234'),
        throwsA(isA<CurrentPasswordIncorrect>()),
      );
    });

    test('a recent password is PasswordReused', () {
      expect(
        repository(422, {'reason': 'user.password.reused'}).changePassword('x', 'Nueva1234'),
        throwsA(isA<PasswordReused>()),
      );
    });
  });

  group('signOut', () {
    test('closes the session on the phone and on the server', () async {
      final repo = repository(200, session);
      await repo.signIn('rosa@example.com', 'Clave1234');

      await repo.signOut();
      await Future<void>.delayed(Duration.zero);

      expect(await repo.isSignedIn(), isFalse);
      expect(lastRequest.url.path, endsWith('/auth/sign-out'));
      expect(jsonDecode(lastRequest.body), {'refreshToken': 'refresh'});
    });

    test('closes the session on the phone even if the server fails', () async {
      final repo = repository(200, session);
      await repo.signIn('rosa@example.com', 'Clave1234');

      await repository(500, {}).signOut();
      await Future<void>.delayed(Duration.zero);

      expect(await repo.isSignedIn(), isFalse);
    });
  });

  group('signIn', () {
    test('saves the session', () async {
      final repo = repository(200, session);

      await repo.signIn('rosa@example.com', 'Clave1234');

      expect(await repo.isSignedIn(), isTrue);
    });

    test('tells the server the role this app serves', () async {
      await repository(200, session).signIn('rosa@example.com', 'Clave1234');

      expect(jsonDecode(lastRequest.body)['role'], 'ROLE_TECHNICAL_MANAGER');
    });

    test('an account of another role is AccountOfOtherRole', () {
      expect(
        repository(403, {'code': 'USER_ROLE_FORBIDDEN'}).signIn('rosa@example.com', 'x'),
        throwsA(isA<AccountOfOtherRole>()),
      );
    });

    test('wrong credentials are InvalidCredentials', () {
      expect(
        repository(403, {'code': 'USER_FORBIDDEN'}).signIn('rosa@example.com', 'x'),
        throwsA(isA<InvalidCredentials>()),
      );
    });

    test('an unknown refusal is not mistaken for wrong credentials', () {
      expect(
        repository(403, {'code': 'SOMETHING_FORBIDDEN'}).signIn('rosa@example.com', 'x'),
        throwsA(isA<AuthUnexpected>()),
      );
    });

    test('an unverified email is EmailNotVerified', () {
      expect(
        repository(403, {'code': 'EMAIL_VERIFICATION_FORBIDDEN'}).signIn('rosa@example.com', 'x'),
        throwsA(isA<EmailNotVerified>()),
      );
    });

    test('no connection is AuthOffline', () {
      final repo = AuthRepositoryImpl(
        api: AuthApi(
          client: ApiClient(
            client: MockClient((_) async => throw http.ClientException('offline')),
          ),
        ),
        sessionStore: const SessionStore(),
      );

      expect(repo.signIn('rosa@example.com', 'x'), throwsA(isA<AuthOffline>()));
    });
  });

  group('verifyEmail', () {
    test('a right code opens the session', () async {
      final repo = repository(200, session);

      await repo.verifyEmail('rosa@example.com', '123456');

      expect(await repo.isSignedIn(), isTrue);
    });

    Future<void> failsWith(String reason, Matcher matcher) => expectLater(
          repository(422, {'reason': reason, 'remainingAttempts': 2})
              .verifyEmail('rosa@example.com', '123456'),
          throwsA(matcher),
        );

    test('each reason of the server has its failure', () async {
      await failsWith(
        'user.email_verification.invalid_code',
        isA<InvalidCode>().having((failure) => failure.remainingAttempts, 'left', 2),
      );
      await failsWith('user.email_verification.attempts_exceeded', isA<CodeAttemptsExceeded>());
      await failsWith('user.email_verification.code_expired', isA<CodeExpired>());
      await failsWith('user.email_verification.no_active_code', isA<NoActiveCode>());
    });
  });

  group('password recovery', () {
    test('an expired link is ResetLinkExpired', () {
      expect(
        repository(404, {}).checkPasswordResetLink('token'),
        throwsA(isA<ResetLinkExpired>()),
      );
    });

    test('a repeated password is PasswordReused', () {
      expect(
        repository(422, {'reason': 'user.password.reused'}).resetPassword('token', 'Clave1234'),
        throwsA(isA<PasswordReused>()),
      );
    });
  });
}
