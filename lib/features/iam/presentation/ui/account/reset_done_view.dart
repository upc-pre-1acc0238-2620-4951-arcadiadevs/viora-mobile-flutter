import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

class ResetDoneView extends StatelessWidget {
  const ResetDoneView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<IamViewModel>();
    return IamMessageScreen(
      art: const IsotypeBadge(),
      eyebrow: l10n.iamResetDoneEyebrow,
      dotColor: VioraColors.harvest300,
      title: l10n.iamResetDoneTitle,
      body: Text(
        l10n.iamResetDoneBody,
        textAlign: TextAlign.center,
        style: IamMessageScreen.bodyStyle(context),
      ),
      footer: [
        VioraButton(
          label: l10n.iamSignIn,
          onPressed: () => viewModel.goTo(IamStep.signIn),
        ),
      ],
    );
  }
}
