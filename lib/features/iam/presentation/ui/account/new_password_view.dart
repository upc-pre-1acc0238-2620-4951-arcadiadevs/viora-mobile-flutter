import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_underline_field.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

class NewPasswordView extends StatelessWidget {
  const NewPasswordView({super.key, required this.state, required this.onBack});

  final IamUiState state;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<IamViewModel>();
    return IamFormFrame(
      onBack: onBack,
      footer: [
        IamGeneralError(state.failure),
        VioraButton(
          label: l10n.iamSavePassword,
          loading: state.loading,
          onPressed: state.canSaveNewPassword ? viewModel.saveNewPassword : null,
        ),
      ],
      children: [
        VioraEditorialTitle(l10n.iamNewPasswordTitle),
        const SizedBox(height: 16),
        VioraVoice(text: l10n.iamNewPasswordVoice, markSize: 17),
        const SizedBox(height: 28),
        VioraUnderlineField(
          label: l10n.iamNewPassword,
          value: state.password,
          onChanged: viewModel.onPassword,
          secret: true,
          revealLabel: l10n.iamShow,
          hideLabel: l10n.iamHide,
          autofocus: true,
          autofillHints: const [AutofillHints.newPassword],
          error: switch (state.failure) {
            PasswordReused() => l10n.iamPasswordReused,
            WeakPassword() => l10n.iamPasswordWeak,
            _ => null,
          },
        ),
        const SizedBox(height: 20),
        VioraUnderlineField(
          label: l10n.iamConfirmPassword,
          value: state.confirmPassword,
          onChanged: viewModel.onConfirmPassword,
          secret: true,
          revealLabel: l10n.iamShow,
          hideLabel: l10n.iamHide,
          textInputAction: TextInputAction.done,
          onSubmitted: viewModel.saveNewPassword,
        ),
        const SizedBox(height: 12),
        PasswordRuleRow(
          rules: [
            PasswordRule(
              l10n.iamRuleLength,
              met: state.passwordLongEnough,
              touched: state.password.isNotEmpty,
            ),
            PasswordRule(
              l10n.iamRuleLettersNumbers,
              met: state.passwordHasLettersAndDigits,
              touched: state.password.isNotEmpty,
            ),
            PasswordRule(
              l10n.iamRuleMatch,
              met: state.confirmOk,
              touched: state.confirmPassword.isNotEmpty,
            ),
          ],
        ),
      ],
    );
  }
}
