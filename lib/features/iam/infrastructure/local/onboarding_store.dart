import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viora/features/iam/domain/repository/onboarding_repository.dart';
import 'package:viora/features/iam/domain/valueobject/onboarding_answers.dart';
import 'package:viora/features/iam/infrastructure/local/onboarding_answers_dto.dart';

class OnboardingStore implements OnboardingRepository {
  const OnboardingStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'onboarding.answers';

  final FlutterSecureStorage _storage;

  @override
  Future<OnboardingAnswers> answers() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return const OnboardingAnswers();
    return OnboardingAnswersDto.fromJson(jsonDecode(raw) as Map<String, dynamic>).toDomain();
  }

  @override
  Future<void> save(OnboardingAnswers answers) => _storage.write(
        key: _key,
        value: jsonEncode(OnboardingAnswersDto.fromDomain(answers).toJson()),
      );

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
