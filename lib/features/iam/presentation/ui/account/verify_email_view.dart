import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key, required this.state, required this.onBack});

  final IamUiState state;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<IamViewModel>();
    final textTheme = Theme.of(context).textTheme;
    final codeMessage = switch (state.failure) {
      InvalidCode(remainingAttempts: final left?) => l10n.iamCodeWrongAttempts(left),
      InvalidCode() => l10n.iamCodeWrong,
      CodeAttemptsExceeded() => l10n.iamCodeBlocked,
      CodeExpired() => l10n.iamCodeExpired,
      NoActiveCode() => l10n.iamCodeMissing,
      _ => null,
    };
    return IamFormFrame(
      onBack: onBack,
      children: [
        VioraEditorialTitle(l10n.iamVerifyTitle),
        const SizedBox(height: 16),
        VioraVoice(text: l10n.iamVerifyVoice(state.pendingEmail), markSize: 17),
        const SizedBox(height: 28),
        CodeInput(
          code: state.code,
          onChanged: viewModel.onCode,
          isError: codeMessage != null,
          length: IamUiState.codeLength,
        ),
        const SizedBox(height: 20),
        if (codeMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              codeMessage,
              style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        IamGeneralError(state.failure),
        if (state.loading)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: VioraColors.green900),
            ),
          ),
        if (state.resendSeconds > 0)
          Text(
            l10n.iamResendIn(_clock(state.resendSeconds)),
            style: textTheme.bodyMedium?.copyWith(color: VioraColors.neutral600),
          )
        else
          UnderlinedLink(text: l10n.iamResendCode, onTap: viewModel.resend),
        UnderlinedLink(
          text: l10n.iamChangeEmail,
          onTap: () => viewModel.goTo(IamStep.createAccount),
        ),
      ],
    );
  }

  String _clock(int seconds) => '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
}
