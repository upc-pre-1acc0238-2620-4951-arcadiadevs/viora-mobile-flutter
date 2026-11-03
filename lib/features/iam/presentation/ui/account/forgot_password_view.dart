import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key, required this.state, required this.onBack});

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
          label: l10n.iamSendLink,
          loading: state.loading,
          onPressed: state.emailValid ? viewModel.requestResetLink : null,
        ),
      ],
      children: [
        VioraEditorialTitle(l10n.iamForgotTitle),
        const SizedBox(height: 16),
        VioraVoice(text: l10n.iamForgotVoice, markSize: 17),
        const SizedBox(height: 28),
        IamEmailField(state: state, autofocus: true),
      ],
    );
  }
}
