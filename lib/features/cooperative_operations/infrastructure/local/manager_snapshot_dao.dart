import 'package:drift/drift.dart';
import 'package:viora/core/database/app_database.dart';

/// Reads and writes the kept answers of the manager's reads.
class ManagerSnapshotDao {
  const ManagerSnapshotDao(this.db);

  final AppDatabase db;

  Future<void> keep(String userId, String readKey, String body, DateTime savedAt) =>
      db.into(db.managerSnapshots).insertOnConflictUpdate(
            ManagerSnapshotsCompanion.insert(userId: userId, readKey: readKey, body: body, savedAt: savedAt),
          );

  Future<ManagerSnapshotRow?> read(String userId, String readKey) => (db.select(db.managerSnapshots)
        ..where((row) => row.userId.equals(userId) & row.readKey.equals(readKey)))
      .getSingleOrNull();

  Future<void> clear() => db.delete(db.managerSnapshots).go();
}
