import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/navigation/top_level_destination.dart';
import 'package:viora/features/iam/presentation/state/iam_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/account/checking_link_view.dart';
import 'package:viora/features/iam/presentation/ui/account/create_account_view.dart';
import 'package:viora/features/iam/presentation/ui/account/forgot_password_view.dart';
import 'package:viora/features/iam/presentation/ui/account/link_expired_view.dart';
import 'package:viora/features/iam/presentation/ui/account/link_sent_view.dart';
import 'package:viora/features/iam/presentation/ui/account/new_password_view.dart';
import 'package:viora/features/iam/presentation/ui/account/reset_done_view.dart';
import 'package:viora/features/iam/presentation/ui/account/sign_in_view.dart';
import 'package:viora/features/iam/presentation/ui/account/verify_email_view.dart';
import 'package:viora/features/iam/presentation/ui/welcome_page.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

/// Signing in, creating the account, verifying the email and recovering the password. The
/// route provides the [IamViewModel] with the screen it starts on.
class IamPage extends StatelessWidget {
  const IamPage({super.key});

  static const path = '/auth';

  /// Path of the recovery link the backend emails.
  static const resetPath = '/password-resets/:token';

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<IamViewModel>();
    return BlocConsumer<IamViewModel, IamUiState>(
      listenWhen: (previous, current) =>
          previous.authenticated != current.authenticated || previous.notice != current.notice,
      listener: (context, state) {
        if (state.authenticated) {
          context.go(TopLevelDestination.home.path);
          return;
        }
        final l10n = AppLocalizations.of(context);
        final notice = switch (state.notice) {
          IamNotice.codeResent => l10n.iamCodeResent,
          IamNotice.linkResent => l10n.iamLinkResent,
          null => null,
        };
        if (notice != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(notice)));
        }
      },
      builder: (context, state) {
        void leaveOrBack() {
          if (viewModel.back()) return;
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(WelcomePage.path);
          }
        }

        return PopScope(
          canPop: state.step == IamStep.signIn || state.step == IamStep.createAccount,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) viewModel.back();
          },
          child: switch (state.step) {
            IamStep.signIn => SignInView(state: state, onBack: leaveOrBack),
            IamStep.createAccount => CreateAccountView(state: state, onBack: leaveOrBack),
            IamStep.verify => VerifyEmailView(state: state, onBack: leaveOrBack),
            IamStep.forgot => ForgotPasswordView(state: state, onBack: leaveOrBack),
            IamStep.linkSent => LinkSentView(state: state, onBack: leaveOrBack),
            IamStep.checkingLink => CheckingLinkView(state: state, onBack: leaveOrBack),
            IamStep.newPassword => NewPasswordView(state: state, onBack: leaveOrBack),
            IamStep.resetDone => const ResetDoneView(),
            IamStep.linkExpired => LinkExpiredView(onBack: leaveOrBack),
          },
        );
      },
    );
  }
}
