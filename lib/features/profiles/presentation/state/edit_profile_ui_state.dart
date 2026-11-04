import 'package:flutter/foundation.dart';
import 'package:viora/core/domain/account_rules.dart';
import 'package:viora/features/profiles/domain/exception/profile_failure.dart';

@immutable
class EditProfileUiState {
  const EditProfileUiState({
    this.fullName = '',
    this.initialFullName = '',
    this.country = PhoneCountry.pe,
    this.phone = '',
    this.initialPhone = '',
    this.email = '',
    this.nameTouched = false,
    this.loading = false,
    this.saved = false,
    this.failure,
  });

  final String fullName;
  final String initialFullName;
  final PhoneCountry country;
  final String phone;
  final String initialPhone;
  final String email;

  /// The name was edited, so an empty one may show its error.
  final bool nameTouched;
  final bool loading;
  final bool saved;
  final ProfileFailure? failure;

  bool get showNameError => nameTouched && !PersonName.isValid(fullName);
  bool get showPhoneError =>
      failure is ProfilePhoneRejected || (phone.isNotEmpty && !country.isValidMobile(phone));
  bool get modified => fullName.trim() != initialFullName.trim() || phone != initialPhone;
  bool get canSave =>
      PersonName.isValid(fullName) &&
      country.isValidMobile(phone) &&
      modified &&
      failure is! ProfilePhoneRejected;

  static const _keep = Object();

  EditProfileUiState copyWith({
    String? fullName,
    String? initialFullName,
    PhoneCountry? country,
    String? phone,
    String? initialPhone,
    String? email,
    bool? nameTouched,
    bool? loading,
    bool? saved,
    Object? failure = _keep,
  }) {
    return EditProfileUiState(
      fullName: fullName ?? this.fullName,
      initialFullName: initialFullName ?? this.initialFullName,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      initialPhone: initialPhone ?? this.initialPhone,
      email: email ?? this.email,
      nameTouched: nameTouched ?? this.nameTouched,
      loading: loading ?? this.loading,
      saved: saved ?? this.saved,
      failure: identical(failure, _keep) ? this.failure : failure as ProfileFailure?,
    );
  }
}
