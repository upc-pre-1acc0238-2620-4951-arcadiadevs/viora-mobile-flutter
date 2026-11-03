import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_underline_field.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({super.key, required this.state, required this.onBack});

  final IamUiState state;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<IamViewModel>();
    final failure = state.failure;
    return IamFormFrame(
      onBack: onBack,
      footer: [
        IamGeneralError(failure),
        VioraButton(
          label: l10n.iamCreateAccount,
          loading: state.loading,
          onPressed: state.canCreateAccount ? viewModel.signUp : null,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.iamCreateNote,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                letterSpacing: 0,
                color: VioraColors.neutral600,
              ),
        ),
      ],
      children: [
        VioraEditorialTitle(l10n.iamCreateTitle),
        const SizedBox(height: 16),
        VioraVoice(
          text: state.firstName.isEmpty
              ? l10n.iamCreateVoiceAnonymous
              : l10n.iamCreateVoice(state.firstName),
          markSize: 17,
        ),
        const SizedBox(height: 28),
        IamEmailField(
          state: state,
          autofocus: true,
          error: switch (failure) {
            EmailPendingWithOtherRole() => l10n.iamEmailOtherRole,
            EmailTaken() => l10n.iamEmailTaken,
            _ => null,
          },
          errorAction: failure is EmailTaken
              ? UnderlinedLink(text: l10n.iamSignIn, onTap: viewModel.goToSignInWithEmail)
              : null,
        ),
        const SizedBox(height: 20),
        VioraUnderlineField(
          label: l10n.iamPassword,
          value: state.password,
          onChanged: viewModel.onPassword,
          secret: true,
          revealLabel: l10n.iamShow,
          hideLabel: l10n.iamHide,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          error: failure is WeakPassword || (state.passwordLongEnough && !state.passwordOk)
              ? l10n.iamPasswordWeak
              : null,
          onSubmitted: viewModel.signUp,
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
          ],
        ),
      ],
    );
  }
}
