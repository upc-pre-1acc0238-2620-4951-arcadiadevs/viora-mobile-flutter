import 'package:flutter_test/flutter_test.dart';
import 'package:viora/features/iam/infrastructure/remote/auth_session_dto.dart';

void main() {
  test('turns the answer of the server into the session of the domain', () {
    final session = AuthSessionDto.fromJson(const {
      'accessToken': 'access',
      'refreshToken': 'refresh',
      'expiresIn': 900,
      'userId': 'user-1',
      'role': 'ROLE_TECHNICAL_MANAGER',
    }).toDomain();

    expect(session.accessToken, 'access');
    expect(session.refreshToken, 'refresh');
    expect(session.userId, 'user-1');
    expect(session.role, 'ROLE_TECHNICAL_MANAGER');
  });
}
