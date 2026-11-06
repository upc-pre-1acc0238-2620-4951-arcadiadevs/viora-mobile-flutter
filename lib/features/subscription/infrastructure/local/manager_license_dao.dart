import 'package:viora/core/database/app_database.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';

/// Reads and writes the kept licenses, one per account.
class ManagerLicenseDao {
  const ManagerLicenseDao(this.db);

  final AppDatabase db;

  Stream<ManagerLicense?> watch(String userId) => (db.select(db.managerLicenses)
        ..where((row) => row.userId.equals(userId)))
      .watchSingleOrNull()
      .map((row) => row?.toDomain());

  Future<ManagerLicense?> read(String userId) async => (await (db.select(db.managerLicenses)
            ..where((row) => row.userId.equals(userId)))
          .getSingleOrNull())
      ?.toDomain();

  Future<void> keep(String userId, ManagerLicense license) =>
      db.into(db.managerLicenses).insertOnConflictUpdate(
            ManagerLicensesCompanion.insert(
              userId: userId,
              licenseId: license.id,
              organizationName: license.organizationName,
              seats: license.seats,
              contractedAreaHa: license.contractedAreaHa,
              startsAt: license.startsAt,
              endsAt: license.endsAt,
            ),
          );

  Future<void> forget(String userId) =>
      (db.delete(db.managerLicenses)..where((row) => row.userId.equals(userId))).go();

  Future<void> clear() => db.delete(db.managerLicenses).go();
}

extension on ManagerLicenseRow {
  ManagerLicense toDomain() => ManagerLicense(
        id: licenseId,
        organizationName: organizationName,
        seats: seats,
        contractedAreaHa: contractedAreaHa,
        startsAt: startsAt,
        endsAt: endsAt,
      );
}
