import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:viora/features/home/presentation/state/home_ui_state.dart';

/// Equivale a `HomeViewModel` + `HomeGreetingViewModel` de Android.
///
/// TODO(home): leer el nombre desde el feature de perfiles (IAM/Profiles) y
/// las alertas activas desde telemetría; ambos entran por casos de uso en
/// `application/`, no directamente aquí.
class HomeViewModel extends Cubit<HomeUiState> {
  HomeViewModel() : super(const HomeUiState());
}
