import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

class LinkExpiredView extends StatelessWidget {
  const LinkExpiredView({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<IamViewModel>();
    return IamMessageScreen(
      onBack: onBack,
      art: SvgPicture.asset('assets/images/ill_envelope.svg', width: 240, height: 220),
      eyebrow: l10n.iamLinkExpiredEyebrow,
      dotColor: VioraColors.terracotta500,
      title: l10n.iamLinkExpiredTitle,
      body: Text(
        l10n.iamLinkExpiredBody,
        textAlign: TextAlign.center,
        style: IamMessageScreen.bodyStyle(context),
      ),
      footer: [
        VioraButton(
          label: l10n.iamRequestNewLink,
          onPressed: () => viewModel.goTo(IamStep.forgot),
        ),
        const SizedBox(height: 6),
        VioraTextButton(
          label: l10n.iamBackToSignIn,
          onPressed: () => viewModel.goTo(IamStep.signIn),
        ),
      ],
    );
  }
}
