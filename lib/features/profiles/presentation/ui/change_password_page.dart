import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/iam/domain/exception/auth_failure.dart';
import 'package:viora/features/profiles/presentation/state/change_password_ui_state.dart';
import 'package:viora/features/profiles/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/profiles/presentation/viewmodel/change_password_view_model.dart';

/// Changes the password after checking the current one.
class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  static const path = '/account/password';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangePasswordViewModel>(),
      child: BlocConsumer<ChangePasswordViewModel, ChangePasswordUiState>(
        listenWhen: (previous, current) => !previous.changed && current.changed,
        listener: (context, state) => context.pop(true),
        builder: (context, state) => _ChangePasswordView(state: state),
      ),
    );
  }
}

class _ChangePasswordView extends StatelessWidget {
  const _ChangePasswordView({required this.state});

  final ChangePasswordUiState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<ChangePasswordViewModel>();
    final reveal = l10n.iamShow;
    final generalError = switch (state.failure) {
      AuthOffline() => l10n.iamErrorOffline,
      AuthTooManyRequests() => l10n.iamErrorWait,
      AuthUnexpected() => l10n.iamErrorGeneric,
      _ => null,
    };
    final newPasswordError = switch (state.failure) {
      PasswordReused() => l10n.iamPasswordReused,
      WeakPassword() => l10n.iamPasswordWeak,
      _ => state.showRuleErrors && !state.newPasswordValid ? l10n.accountPasswordRules : null,
    };
    return Scaffold(
      backgroundColor: VioraColors.neutral100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(accountGutter, 8, accountGutter, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AccountTopBar(
                title: l10n.accountSecurityTitle,
                subtitle: l10n.accountTitle,
                isClose: true,
                onBack: context.pop,
              ),
              // The scrolled content stops short of the bar and the button, instead of touching them.
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      VioraEditorialTitle(l10n.accountPasswordHeadline),
                      const SizedBox(height: 16),
                      ValidatedFieldCard(
                        label: l10n.accountCurrentPassword,
                        value: state.currentPassword,
                        onChanged: viewModel.onCurrent,
                        secret: true,
                        revealLabel: reveal,
                        error: state.failure is CurrentPasswordIncorrect
                            ? l10n.accountCurrentPasswordWrong
                            : null,
                      ),
                      const SizedBox(height: 16),
                      ValidatedFieldCard(
                        label: l10n.iamNewPassword,
                        value: state.newPassword,
                        onChanged: viewModel.onNew,
                        secret: true,
                        revealLabel: reveal,
                        error: newPasswordError,
                      ),
                      const SizedBox(height: 16),
                      _Requirements(state: state),
                      const SizedBox(height: 16),
                      ValidatedFieldCard(
                        label: l10n.accountConfirmNewPassword,
                        value: state.confirmPassword,
                        onChanged: viewModel.onConfirm,
                        secret: true,
                        revealLabel: reveal,
                        textInputAction: TextInputAction.done,
                        error: state.confirmMismatch ? l10n.accountPasswordMismatch : null,
                        onSubmitted: viewModel.submit,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (generalError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FieldNote(text: generalError, isError: true),
                ),
              CheckmarkPillButton(
                label: l10n.accountChangePassword,
                loading: state.loading,
                onPressed: state.canSubmit ? viewModel.submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The strength bar and the three rules of the new password.
class _Requirements extends StatelessWidget {
  const _Requirements({required this.state});

  final ChangePasswordUiState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final barColor = state.newPasswordValid ? VioraColors.green700 : VioraColors.terracotta500;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: VioraColors.neutral0,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var segment = 0; segment < 4; segment++) ...[
                if (segment > 0) const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: segment < state.strength ? barColor : VioraColors.neutral200,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _Rule(l10n.accountRuleLength, met: state.longEnough, judged: state.showRuleErrors),
          const SizedBox(height: 6),
          _Rule(
            l10n.iamRuleLettersNumbers,
            met: state.hasLettersAndDigits,
            judged: state.showRuleErrors,
          ),
          const SizedBox(height: 6),
          _Rule(
            l10n.accountRuleDifferent,
            met: state.differsFromCurrent,
            judged: state.showRuleErrors,
          ),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule(this.label, {required this.met, required this.judged});

  final String label;
  final bool met;

  /// Before this, a rule that isn't met yet doesn't count as an error.
  final bool judged;

  @override
  Widget build(BuildContext context) {
    final failed = judged && !met;
    final color = failed ? VioraColors.terracotta700 : VioraColors.neutral700;
    return Row(
      children: [
        VioraIcon(failed ? VioraIcons.close : VioraIcons.check, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  height: 18 / 13,
                  color: color,
                ),
          ),
        ),
      ],
    );
  }
}
