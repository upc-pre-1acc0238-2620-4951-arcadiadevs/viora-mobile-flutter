import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/presentation/voice_animation_preference.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('defaults to enabled', () async {
    final cubit = VoiceAnimationPreferenceCubit();
    await cubit.load();
    expect(cubit.state, isTrue);
    await cubit.close();
  });

  test('loads and persists the choice', () async {
    final cubit = VoiceAnimationPreferenceCubit();
    await cubit.setEnabled(false);
    final next = VoiceAnimationPreferenceCubit();
    await next.load();
    expect(next.state, isFalse);
    await cubit.close();
    await next.close();
  });
}
