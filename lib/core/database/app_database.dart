import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Local database shared by every feature. Each feature registers its own tables
/// and DAOs here.
@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  // The connection opens on the first query, so startup doesn't have to await it.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'viora'));

  @override
  int get schemaVersion => 1;
}
