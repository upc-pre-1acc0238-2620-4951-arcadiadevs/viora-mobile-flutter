import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

class LinkSentView extends StatelessWidget {
  const LinkSentView({super.key, required this.state, required this.onBack});

  final IamUiState state;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<IamViewModel>();
    return IamMessageScreen(
      onBack: onBack,
      art: SvgPicture.asset('assets/images/ill_envelope.svg', width: 240, height: 220),
      eyebrow: l10n.iamLinkSentEyebrow,
      dotColor: VioraColors.green800,
      title: l10n.iamLinkSentTitle,
      body: _body(context, l10n.iamLinkSentBody(state.normalizedEmail), state.normalizedEmail),
      footer: [
        IamGeneralError(state.failure),
        VioraButton(
          label: l10n.iamOpenEmail,
          onPressed: () => launchUrl(Uri.parse('mailto:')),
        ),
        const SizedBox(height: 6),
        VioraTextButton(
          label: l10n.iamResendLink,
          onPressed: state.loading ? null : () => viewModel.requestResetLink(isResend: true),
        ),
      ],
    );
  }

  Widget _body(BuildContext context, String text, String email) {
    final start = text.indexOf(email);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: email,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontVariations: [FontVariation.weight(500)],
              color: VioraColors.neutral900,
            ),
          ),
          TextSpan(text: text.substring(start + email.length)),
        ],
      ),
      textAlign: TextAlign.center,
      style: IamMessageScreen.bodyStyle(context),
    );
  }
}
