import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Whether Viora's fixed voice messages animate, kept on the phone.
class VoiceAnimationPreferenceCubit extends Cubit<bool> {
  VoiceAnimationPreferenceCubit({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage(),
      super(true);

  static const _key = 'app.animated_voice';
  final FlutterSecureStorage _storage;

  Future<void> load() async {
    try {
      emit(await _storage.read(key: _key) != 'false');
    } on Exception {
      emit(true);
    }
  }

  Future<void> setEnabled(bool enabled) async {
    emit(enabled);
    await _storage.write(key: _key, value: enabled.toString());
  }
}
