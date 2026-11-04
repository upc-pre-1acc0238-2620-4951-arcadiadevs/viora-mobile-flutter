import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/domain/account_rules.dart';
import 'package:viora/features/profiles/application/usecase/get_current_profile_use_case.dart';
import 'package:viora/features/profiles/application/usecase/update_profile_use_case.dart';
import 'package:viora/features/profiles/domain/exception/profile_failure.dart';
import 'package:viora/features/profiles/presentation/state/edit_profile_ui_state.dart';

class EditProfileViewModel extends Cubit<EditProfileUiState> {
  EditProfileViewModel({required this.getCurrentProfile, required this.updateProfile})
      : super(const EditProfileUiState()) {
    _load();
  }

  final GetCurrentProfileUseCase getCurrentProfile;
  final UpdateProfileUseCase updateProfile;

  Future<void> _load() async {
    final profile = await getCurrentProfile.execute();
    if (isClosed || profile == null) return;
    final country = PhoneCountry.fromIso(profile.countryIso);
    final phone = country.nationalOf(profile.phoneNumber);
    emit(state.copyWith(
      fullName: profile.fullName,
      initialFullName: profile.fullName,
      country: country,
      phone: phone,
      initialPhone: phone,
      email: profile.email,
    ));
  }

  void onName(String value) =>
      emit(state.copyWith(fullName: value, nameTouched: true, failure: null));

  void onPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > PhoneCountry.nationalDigits
        ? digits.substring(0, PhoneCountry.nationalDigits)
        : digits;
    emit(state.copyWith(phone: limited, failure: null));
  }

  Future<void> save() async {
    if (!state.canSave || state.loading) return;
    emit(state.copyWith(loading: true, failure: null));
    try {
      await updateProfile.execute(
        fullName: state.fullName.trim(),
        countryIso: state.country.iso,
        phoneNumber: state.country.e164(state.phone),
      );
      if (!isClosed) emit(state.copyWith(loading: false, saved: true));
    } on ProfileFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(loading: false, failure: failure));
    }
  }
}
