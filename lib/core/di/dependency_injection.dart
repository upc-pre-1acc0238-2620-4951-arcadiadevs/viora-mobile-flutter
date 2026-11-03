import 'package:get_it/get_it.dart';

import 'package:viora/core/database/app_database.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  _setupCore();
  _setupViewModels();
}

void _setupCore() {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
}

// Los ViewModels guardan estado de pantalla: una instancia nueva cada vez.
void _setupViewModels() {
  getIt.registerFactory<HomeViewModel>(() => HomeViewModel());
}
