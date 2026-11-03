import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:viora/features/home/presentation/state/home_ui_state.dart';

/// Holds the Home greeting, voice line and alerts badge.
///
/// TODO(home): read the name from the profiles feature (IAM/Profiles) and the active
/// alerts from telemetry; both come in through use cases in `application/`, not
/// directly here.
class HomeViewModel extends Cubit<HomeUiState> {
  HomeViewModel() : super(const HomeUiState());
}
