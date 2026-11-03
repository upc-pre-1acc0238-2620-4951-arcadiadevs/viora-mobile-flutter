import 'package:viora/features/iam/domain/valueobject/account_role.dart';

/// The name of each role in the backend.
extension AccountRoleDto on AccountRole {
  String get serverName => switch (this) {
        AccountRole.producer => 'ROLE_PRODUCER',
        AccountRole.technicalManager => 'ROLE_TECHNICAL_MANAGER',
      };
}
