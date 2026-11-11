import 'package:drift/drift.dart';

/// The last answer of the server to each read of the manager (the map, the alerts, the intake),
/// kept as it came so the screens can show it without a connection. One row per account and read.
@DataClassName('ManagerSnapshotRow')
class ManagerSnapshots extends Table {
  TextColumn get userId => text()();

  /// The read it answers, such as `member-plots` or `intake-forecasts/2026`.
  TextColumn get readKey => text()();

  /// The JSON body of the answer.
  TextColumn get body => text()();
  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {userId, readKey};
}
