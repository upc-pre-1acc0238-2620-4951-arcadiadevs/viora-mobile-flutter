import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

class CheckingLinkView extends StatelessWidget {
  const CheckingLinkView({super.key, required this.state, required this.onBack});

  final IamUiState state;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<IamViewModel>();
    return IamFormFrame(
      onBack: onBack,
      footer: [
        IamGeneralError(state.failure),
        if (state.failure != null)
          VioraButton(
            label: AppLocalizations.of(context).commonRetry,
            onPressed: viewModel.checkResetLink,
          ),
      ],
      children: [
        if (state.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 120),
              child: CircularProgressIndicator(color: VioraColors.green900),
            ),
          ),
      ],
    );
  }
}
