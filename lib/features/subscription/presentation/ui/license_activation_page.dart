import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/navigation/app_routes.dart';
import 'package:viora/core/navigation/top_level_destination.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';
import 'package:viora/features/subscription/presentation/state/license_activation_ui_state.dart';
import 'package:viora/features/subscription/presentation/ui/widgets/license_widgets.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_activation_view_model.dart';

/// A manager without a license in force types the code their organization got, and then sees
/// what the license covers.
class LicenseActivationPage extends StatelessWidget {
  const LicenseActivationPage({super.key});

  static const path = '/license/activation';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LicenseActivationViewModel>()..start(),
      child: BlocConsumer<LicenseActivationViewModel, LicenseActivationUiState>(
        listenWhen: (previous, current) =>
            previous.alreadyLicensed != current.alreadyLicensed ||
            previous.signedOut != current.signedOut,
        listener: (context, state) {
          if (state.signedOut) {
            context.go(AppRoutes.signIn);
          } else if (state.alreadyLicensed) {
            // The license on the phone was out of date: the check reads it again.
            context.go(AppRoutes.licenseGate);
          }
        },
        builder: (context, state) {
          final activated = state.activated;
          return Scaffold(
            backgroundColor: VioraColors.neutral50,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: activated == null
                  ? _NoLicense(state: state)
                  : _Activated(license: activated),
            ),
          );
        },
      ),
    );
  }
}

class _NoLicense extends StatelessWidget {
  const _NoLicense({required this.state});

  final LicenseActivationUiState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<LicenseActivationViewModel>();
    final otherError = switch (state.failure) {
      LicenseOffline() => l10n.licenseErrorOffline,
      LicenseTooManyAttempts() => l10n.licenseErrorWait,
      LicenseUnexpected() => l10n.licenseErrorGeneric,
      _ => null,
    };
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(licenseGutter, Spacing.sm, licenseGutter, 20),
      child: Column(
        children: [
          LicenseHeadline(
            eyebrow: l10n.licenseNoneEyebrow,
            title: l10n.licenseNoneTitle,
            body: state.codeRejected ? l10n.licenseCodeNotRedeemable : l10n.licenseNoneBody,
            bodyIsError: state.codeRejected,
          ),
          const SizedBox(height: Spacing.lg),
          LicenseCodeField(
            value: state.code,
            onChanged: viewModel.onCode,
            label: l10n.licenseCodeLabel,
            hint: l10n.licenseCodeHint,
            isError: state.codeRejected,
            onSubmitted: viewModel.activate,
          ),
          const SizedBox(height: 14),
          LicenseFacts(
            facts: [
              (
                l10n.licenseStatus,
                state.expired ? l10n.licenseStatusExpired : l10n.licenseStatusNone,
              ),
              (l10n.licenseEmail, state.email ?? ''),
            ],
          ),
          if (otherError != null)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.md),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  otherError,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: VioraColors.terracotta700,
                      ),
                ),
              ),
            ),
          const SizedBox(height: 36),
          VioraButton(
            label: l10n.licenseActivate,
            loading: state.loading,
            onPressed: state.canActivate ? viewModel.activate : null,
          ),
          const SizedBox(height: Spacing.xs),
          VioraTextButton(label: l10n.licenseContact, onPressed: viewModel.contactSales),
          const SizedBox(height: 2),
          VioraTextButton(label: l10n.accountSignOut, onPressed: viewModel.signOut),
        ],
      ),
    );
  }
}

class _Activated extends StatelessWidget {
  const _Activated({required this.license});

  final ManagerLicense license;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final hectares = NumberFormat.decimalPattern(locale)
      ..maximumFractionDigits = 2;
    // The license ends at an instant, exclusive: its last day is the one before.
    final lastDay = license.endsAt.toLocal().subtract(const Duration(microseconds: 1));
    void goHome() => context.go(TopLevelDestination.home.path);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) goHome();
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(licenseGutter, 76, licenseGutter, 0),
              child: Column(
                children: [
                  LicenseHeadline(
                    eyebrow: l10n.licenseActivatedEyebrow,
                    title: l10n.licenseActivatedTitle,
                    body: l10n.licenseActivatedBody,
                  ),
                  const SizedBox(height: 26),
                  LicenseFacts(
                    facts: [
                      (l10n.licenseOrganization, license.organizationName),
                      (
                        l10n.licenseQuota,
                        l10n.licenseQuotaValue(
                          license.seats,
                          hectares.format(license.contractedAreaHa),
                        ),
                      ),
                      (
                        l10n.licenseValidity,
                        l10n.licenseValidUntil(DateFormat('d MMM y', locale).format(lastDay)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(licenseGutter, Spacing.md, licenseGutter, 20),
            child: VioraButton(label: l10n.licenseGoHome, onPressed: goHome),
          ),
        ],
      ),
    );
  }
}
