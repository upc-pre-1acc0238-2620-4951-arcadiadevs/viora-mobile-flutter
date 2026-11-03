import 'package:viora/features/iam/domain/valueobject/account_role.dart';
import 'package:viora/features/iam/infrastructure/remote/account_role_dto.dart';

class SignInRequestDto {
  const SignInRequestDto({required this.email, required this.password, required this.role});

  final String email;
  final String password;
  final AccountRole role;

  Map<String, dynamic> toMap() => {'email': email, 'password': password, 'role': role.serverName};
}
