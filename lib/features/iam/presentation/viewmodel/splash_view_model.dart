import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/iam/application/usecase/is_signed_in_use_case.dart';

/// Where the app goes once the splash ends.
enum SplashDestination { home, welcome }

/// Decides, while the splash plays, whether a saved session opens the Home or the welcome.
/// The state stays null until the saved session has been read.
class SplashViewModel extends Cubit<SplashDestination?> {
  SplashViewModel({required this.isSignedIn}) : super(null) {
    _read();
  }

  final IsSignedInUseCase isSignedIn;

  Future<void> _read() async {
    var signedIn = false;
    try {
      signedIn = await isSignedIn.execute();
    } on Exception {
      // Unreadable storage is the same as no session.
    }
    if (!isClosed) emit(signedIn ? SplashDestination.home : SplashDestination.welcome);
  }
}
