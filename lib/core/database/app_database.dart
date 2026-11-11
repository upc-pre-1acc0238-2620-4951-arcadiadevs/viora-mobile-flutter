import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:viora/features/cooperative_operations/infrastructure/local/manager_snapshot_table.dart';
import 'package:viora/features/subscription/infrastructure/local/manager_license_table.dart';

part 'app_database.g.dart';

/// Local database shared by every feature. Each feature registers its own tables
/// and DAOs here.
@DriftDatabase(tables: [ManagerLicenses, ManagerSnapshots])
class AppDatabase extends _$AppDatabase {
  // The connection opens on the first query, so startup doesn't have to await it.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'viora'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          // Version 1 had no tables: the license is the first thing the phone keeps.
          if (from < 2) await migrator.createTable(managerLicenses);
          // Version 3 keeps the last answer of the manager's reads, for the screens without a connection.
          if (from < 3) await migrator.createTable(managerSnapshots);
        },
      );
}
