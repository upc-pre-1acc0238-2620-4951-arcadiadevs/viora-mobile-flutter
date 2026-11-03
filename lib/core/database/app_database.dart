import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Base de datos local, compartida por todos los features (equivale a la
/// `AppDatabase` de Room). Cada feature agrega aquí sus tablas y DAOs.
@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  // La conexión se abre en la primera consulta; por eso no hace falta await.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'viora'));

  @override
  int get schemaVersion => 1;
}
