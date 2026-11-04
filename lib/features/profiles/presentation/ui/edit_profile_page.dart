import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/domain/account_rules.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/profiles/domain/exception/profile_failure.dart';
import 'package:viora/features/profiles/presentation/state/edit_profile_ui_state.dart';
import 'package:viora/features/profiles/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/profiles/presentation/viewmodel/edit_profile_view_model.dart';

/// The full name and the mobile of the profile; the email is read-only.
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static const path = '/account/details';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditProfileViewModel>(),
      child: BlocConsumer<EditProfileViewModel, EditProfileUiState>(
        listenWhen: (previous, current) => !previous.saved && current.saved,
        listener: (context, state) => context.pop(true),
        builder: (context, state) => _EditProfileView(state: state),
      ),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView({required this.state});

  final EditProfileUiState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<EditProfileViewModel>();
    final country = state.country;
    final phoneHint = country == PhoneCountry.es
        ? l10n.onboardingPhoneInvalidSixOrSeven
        : l10n.onboardingPhoneInvalidNine;
    final generalError = switch (state.failure) {
      ProfileOffline() => l10n.accountSaveOffline,
      ProfileUnexpected() => l10n.accountSaveFailed,
      _ => null,
    };
    return Scaffold(
      backgroundColor: VioraColors.neutral100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(accountGutter, 8, accountGutter, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AccountTopBar(
                title: l10n.accountDetailsTitle,
                subtitle: l10n.accountTitle,
                isClose: true,
                onBack: context.pop,
              ),
              // The scrolled content stops short of the bar and the button, instead of touching them.
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      VioraEditorialTitle(l10n.accountDetailsHeadline),
                      const SizedBox(height: 16),
                      ValidatedFieldCard(
                        label: l10n.accountFullName,
                        value: state.fullName,
                        onChanged: viewModel.onName,
                        placeholder: l10n.accountFullNamePlaceholder,
                        textCapitalization: TextCapitalization.words,
                        error: state.showNameError ? l10n.accountFullNameRequired : null,
                      ),
                      const SizedBox(height: 16),
                      ValidatedFieldCard(
                        label: l10n.accountPhoneLabel(_countryName(country), country.dialCode),
                        value: country.grouped(state.phone),
                        onChanged: viewModel.onPhone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        error: state.failure is ProfilePhoneRejected
                            ? l10n.iamErrorPhone
                            : state.showPhoneError
                                ? phoneHint
                                : null,
                        helper: l10n.accountPhoneHelper(country.international('9XXXXXXXX')),
                        onSubmitted: viewModel.save,
                      ),
                      const SizedBox(height: 16),
                      ValidatedFieldCard(
                        label: l10n.accountEmail,
                        value: state.email,
                        helper: l10n.accountEmailHelper,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (generalError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FieldNote(text: generalError, isError: true),
                ),
              CheckmarkPillButton(
                label: l10n.accountSaveChanges,
                loading: state.loading,
                onPressed: state.canSave ? viewModel.save : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _countryName(PhoneCountry country) => switch (country) {
        PhoneCountry.pe => 'Perú',
        PhoneCountry.es => 'España',
        PhoneCountry.cl => 'Chile',
      };
}
