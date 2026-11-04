import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The languages a person can choose in the app.
enum AppLanguage {
  spanish('es'),
  english('en');

  const AppLanguage(this.code);

  final String code;

  Locale get locale => Locale(code);

  static AppLanguage? fromCode(String? code) {
    for (final language in values) {
      if (language.code == code) return language;
    }
    return null;
  }

  /// The language the app shows for a [locale]: anything but Spanish falls back to English.
  static AppLanguage of(Locale locale) =>
      locale.languageCode == AppLanguage.spanish.code ? spanish : english;
}

/// The language the person chose, kept on the phone. Null follows the language of the phone.
class AppLanguageCubit extends Cubit<AppLanguage?> {
  AppLanguageCubit({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(),
        super(null);

  static const _key = 'app.language';

  final FlutterSecureStorage _storage;

  /// The language tag the server should answer in.
  String get languageTag =>
      state?.code ?? PlatformDispatcher.instance.locale.toLanguageTag();

  Future<void> load() async {
    try {
      emit(AppLanguage.fromCode(await _storage.read(key: _key)));
    } on Exception {
      // Unreadable storage is the same as no choice.
    }
  }

  Future<void> choose(AppLanguage language) async {
    emit(language);
    await _storage.write(key: _key, value: language.code);
  }
}
