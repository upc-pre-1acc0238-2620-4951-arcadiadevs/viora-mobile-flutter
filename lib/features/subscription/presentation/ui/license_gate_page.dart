import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_wavy_progress_indicator.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/navigation/app_routes.dart';
import 'package:viora/core/navigation/top_level_destination.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';
import 'package:viora/features/subscription/presentation/state/license_gate_ui_state.dart';
import 'package:viora/features/subscription/presentation/ui/license_activation_page.dart';
import 'package:viora/features/subscription/presentation/ui/widgets/license_widgets.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_gate_view_model.dart';

/// Checks the license once the manager is signed in: the Home when it is in force, its
/// activation when there is none.
class LicenseGatePage extends StatelessWidget {
  const LicenseGatePage({super.key});

  static const path = AppRoutes.licenseGate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LicenseGateViewModel>()..check(),
      child: BlocConsumer<LicenseGateViewModel, LicenseGateUiState>(
        listenWhen: (previous, current) =>
            previous.destination != current.destination || previous.signedOut != current.signedOut,
        listener: (context, state) {
          if (state.signedOut) {
            context.go(AppRoutes.signIn);
            return;
          }
          switch (state.destination) {
            case LicenseGateDestination.home:
              context.go(TopLevelDestination.home.path);
            case LicenseGateDestination.activation:
              context.go(LicenseActivationPage.path);
            case null:
              break;
          }
        },
        builder: (context, state) {
          final failure = state.failure;
          return Scaffold(
            backgroundColor: VioraColors.neutral50,
            body: SafeArea(
              child: failure == null ? const _Checking() : _CheckFailed(failure: failure),
            ),
          );
        },
      ),
    );
  }
}

class _Checking extends StatelessWidget {
  const _Checking();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.square(
        dimension: 48,
        child: VioraWavyProgressIndicator(
          color: VioraColors.green900,
          trackColor: VioraColors.green200,
        ),
      ),
    );
  }
}

class _CheckFailed extends StatelessWidget {
  const _CheckFailed({required this.failure});

  final LicenseFailure failure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<LicenseGateViewModel>();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(licenseGutter, Spacing.sm, licenseGutter, 0),
            child: Column(
              children: [
                const LicenseArt(),
                const SizedBox(height: 28),
                VioraEditorialTitle(
                  l10n.licenseCheckFailedTitle,
                  fontSize: 40,
                  lineHeight: 44,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.xs),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    failure is LicenseOffline ? l10n.licenseErrorOffline : l10n.licenseErrorGeneric,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          height: 22 / 15,
                          letterSpacing: 0,
                          color: VioraColors.neutral700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(licenseGutter, Spacing.md, licenseGutter, 20),
          child: Column(
            children: [
              VioraButton(label: l10n.licenseRetry, onPressed: viewModel.check),
              const SizedBox(height: Spacing.xs),
              VioraTextButton(label: l10n.accountSignOut, onPressed: viewModel.signOut),
            ],
          ),
        ),
      ],
    );
  }
}
