import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_underline_field.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/onboarding_page.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key, required this.state, required this.onBack});

  final IamUiState state;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<IamViewModel>();
    final textTheme = Theme.of(context).textTheme;
    return IamFormFrame(
      onBack: onBack,
      footer: [
        IamGeneralError(state.failure),
        VioraButton(
          label: l10n.iamSignIn,
          loading: state.loading,
          onPressed: state.canSignIn ? viewModel.signIn : null,
        ),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            text: '${l10n.iamNoAccount} ',
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: InkWell(
                  onTap: () => context.push(OnboardingPage.path),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      l10n.iamLetsStart,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontVariations: const [FontVariation.weight(500)],
                        color: VioraColors.neutral900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          style: textTheme.bodyMedium?.copyWith(letterSpacing: 0, color: VioraColors.neutral700),
        ),
      ],
      children: [
        VioraEditorialTitle(l10n.iamSignInTitle),
        const SizedBox(height: 16),
        VioraVoice(text: l10n.iamSignInVoice, markSize: 17),
        const SizedBox(height: 28),
        IamEmailField(state: state, showAsError: state.failure is InvalidCredentials),
        const SizedBox(height: 20),
        VioraUnderlineField(
          label: l10n.iamPassword,
          value: state.password,
          onChanged: viewModel.onPassword,
          secret: true,
          revealLabel: l10n.iamShow,
          hideLabel: l10n.iamHide,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          error: switch (state.failure) {
            AccountOfOtherRole() => l10n.iamOtherRoleAccount,
            InvalidCredentials() => l10n.iamInvalidCredentials,
            _ => null,
          },
          onSubmitted: viewModel.signIn,
        ),
        const SizedBox(height: 12),
        UnderlinedLink(
          text: l10n.iamForgotLink,
          onTap: () => viewModel.goTo(IamStep.forgot),
        ),
      ],
    );
  }
}
