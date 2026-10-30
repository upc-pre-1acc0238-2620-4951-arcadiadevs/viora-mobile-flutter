import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/home_ui_state.dart';

/// Equivale a `HomeViewModel` + `HomeGreetingViewModel` de Android.
///
/// TODO(home): leer el nombre desde el feature de perfiles (IAM/Profiles) y
/// las alertas activas desde telemetría; ambos entran por casos de uso en
/// `application/`, no directamente aquí.
class HomeViewModel extends Notifier<HomeUiState> {
  @override
  HomeUiState build() => const HomeUiState();
}

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, HomeUiState>(HomeViewModel.new);
