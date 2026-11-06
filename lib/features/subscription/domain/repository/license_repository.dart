import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/valueobject/manager_code.dart';

/// The license of the signed-in technical manager, kept on the phone so it shows without a
/// connection and is updated when there is one.
abstract class LicenseRepository {
  /// The kept license, again every time it changes; null while there is none.
  Stream<ManagerLicense?> watchCurrent();

  /// The kept license, without going to the server.
  Future<ManagerLicense?> kept();

  /// Downloads the license and keeps it; null when the manager is in charge of none. Throws a
  /// LicenseFailure when it can't, and the kept one stays.
  Future<ManagerLicense?> refresh();

  /// Redeems [code] and keeps the license the manager is now in charge of. Throws a
  /// LicenseFailure when it can't.
  Future<ManagerLicense> activate(ManagerCode code);

  /// The email of the signed-in account, as the activation shows it.
  Future<String?> accountEmail();

  /// Forgets the kept license, when the session ends.
  Future<void> clear();
}
