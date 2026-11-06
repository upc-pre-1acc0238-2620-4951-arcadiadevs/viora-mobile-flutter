import 'package:drift/drift.dart';

/// The license of each manager who signed in on the phone: one at most per account. Kept so
/// the Home opens without a connection.
@DataClassName('ManagerLicenseRow')
class ManagerLicenses extends Table {
  TextColumn get userId => text()();
  TextColumn get licenseId => text()();
  TextColumn get organizationName => text()();
  IntColumn get seats => integer()();
  RealColumn get contractedAreaHa => real()();
  DateTimeColumn get startsAt => dateTime()();
  DateTimeColumn get endsAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}
