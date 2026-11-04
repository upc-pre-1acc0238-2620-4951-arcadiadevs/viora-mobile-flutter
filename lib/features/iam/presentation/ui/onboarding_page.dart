import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viora/core/designsystem/component/viora_button.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/component/viora_underline_field.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/domain/account_rules.dart';
import 'package:viora/features/iam/presentation/state/onboarding_ui_state.dart';
import 'package:viora/features/iam/presentation/ui/iam_page.dart';
import 'package:viora/features/iam/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/iam/presentation/viewmodel/onboarding_view_model.dart';

/// The onboarding questions before creating the account.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const path = '/onboarding';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingViewModel>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<OnboardingViewModel>();
    return BlocBuilder<OnboardingViewModel, OnboardingUiState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        void leaveOrBack() {
          if (!viewModel.back()) context.pop();
        }

        final number = state.step.number;
        return PopScope(
          canPop: state.step == OnboardingStep.name && !state.editing,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) viewModel.back();
          },
          child: VioraFormFrame(
            onBack: leaveOrBack,
            backLabel: MaterialLocalizations.of(context).backButtonTooltip,
            stepLabel: number == null
                ? null
                : l10n.onboardingStepCounter(
                    number.toString().padLeft(2, '0'),
                    OnboardingStep.questions.toString().padLeft(2, '0'),
                  ),
            footer: _footer(context, state, viewModel),
            children: _content(context, state, viewModel),
          ),
        );
      },
    );
  }

  List<Widget> _content(
    BuildContext context,
    OnboardingUiState state,
    OnboardingViewModel viewModel,
  ) {
    final l10n = AppLocalizations.of(context);
    switch (state.step) {
      case OnboardingStep.name:
        return [
          VioraEditorialTitle(l10n.onboardingNameTitle),
          const SizedBox(height: 16),
          VioraVoice(text: l10n.onboardingNameVoice, markSize: 17),
          const SizedBox(height: 32),
          VioraUnderlineField(
            label: l10n.onboardingNameLabel,
            value: state.fullName,
            onChanged: viewModel.onName,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.name],
            onSubmitted: viewModel.continueFromName,
          ),
        ];
      case OnboardingStep.phone:
        return [
          VioraEditorialTitle(l10n.onboardingPhoneTitle),
          const SizedBox(height: 16),
          VioraVoice(text: l10n.onboardingPhoneVoice, markSize: 17),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 100, child: _CountryField(state: state, viewModel: viewModel)),
              const SizedBox(width: 16),
              Expanded(
                child: VioraUnderlineField(
                  label: l10n.onboardingPhoneLabel,
                  value: state.phone,
                  onChanged: viewModel.onPhone,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  error: state.showPhoneError ? _phoneHint(l10n, state.country) : null,
                  supporting: l10n.onboardingPhoneSupporting,
                  onSubmitted: viewModel.continueFromPhone,
                ),
              ),
            ],
          ),
        ];
      case OnboardingStep.alerts:
        return [
          VioraEditorialTitle(l10n.onboardingAlertsTitle),
          const SizedBox(height: 16),
          VioraVoice(text: l10n.onboardingAlertsVoice, markSize: 17),
          const SizedBox(height: 40),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Opacity(
                  opacity: 0.6,
                  child: AlertExampleCard(
                    meta: l10n.onboardingAlertBackMeta,
                    body: l10n.onboardingAlertBackBody,
                    dotColor: VioraColors.green800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: AlertExampleCard(
                  meta: l10n.onboardingAlertFrontMeta,
                  body: l10n.onboardingAlertFrontBody,
                  dotColor: VioraColors.terracotta500,
                  elevated: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          for (final item in [
            l10n.onboardingAlertsItemLoad,
            l10n.onboardingAlertsItemClimate,
            l10n.onboardingAlertsItemMembers,
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(width: 14, height: 1, color: VioraColors.neutral900),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            letterSpacing: 0,
                            color: VioraColors.neutral700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
        ];
      case OnboardingStep.summary:
        return [
          VioraEditorialTitle(l10n.onboardingSummaryTitle(state.firstName)),
          const SizedBox(height: 16),
          VioraVoice(text: l10n.onboardingSummaryVoice, markSize: 17),
          const SizedBox(height: 28),
          _SummaryRow(
            label: l10n.onboardingSummaryName,
            value: state.fullName.trim(),
            onEdit: () => viewModel.edit(OnboardingStep.name),
          ),
          _SummaryRow(
            label: l10n.onboardingSummaryPhone,
            value: state.country.international(state.phone),
            onEdit: () => viewModel.edit(OnboardingStep.phone),
          ),
          _SummaryRow(
            label: l10n.onboardingSummaryAlerts,
            value: state.alertsEnabled ? l10n.onboardingAlertsOn : l10n.onboardingAlertsOff,
            onEdit: () => viewModel.edit(OnboardingStep.alerts),
          ),
        ];
    }
  }

  List<Widget> _footer(
    BuildContext context,
    OnboardingUiState state,
    OnboardingViewModel viewModel,
  ) {
    final l10n = AppLocalizations.of(context);
    switch (state.step) {
      case OnboardingStep.name:
        return [
          VioraButton(
            label: l10n.commonContinue,
            onPressed: state.nameValid ? viewModel.continueFromName : null,
          ),
        ];
      case OnboardingStep.phone:
        return [
          VioraButton(
            label: l10n.commonContinue,
            onPressed: state.phoneValid ? viewModel.continueFromPhone : null,
          ),
        ];
      case OnboardingStep.alerts:
        return [
          VioraButton(
            label: l10n.onboardingAlertsEnable,
            onPressed: () async {
              final status = await Permission.notification.request();
              viewModel.onAlertsAnswered(status.isGranted);
            },
          ),
          const SizedBox(height: 6),
          VioraTextButton(
            label: l10n.onboardingNotNow,
            onPressed: () => viewModel.onAlertsAnswered(false),
          ),
        ];
      case OnboardingStep.summary:
        return [
          VioraButton(
            label: l10n.onboardingCreate,
            onPressed: () async {
              await viewModel.acceptTerms();
              if (context.mounted) context.push('${IamPage.path}?create=true');
            },
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboardingLegalNotice,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 16 / 12,
                  letterSpacing: 0,
                  color: VioraColors.neutral600,
                ),
          ),
        ];
    }
  }

  String _phoneHint(AppLocalizations l10n, PhoneCountry country) => switch (country) {
        PhoneCountry.pe || PhoneCountry.cl => l10n.onboardingPhoneInvalidNine,
        PhoneCountry.es => l10n.onboardingPhoneInvalidSixOrSeven,
      };
}

class _CountryField extends StatelessWidget {
  const _CountryField({required this.state, required this.viewModel});

  final OnboardingUiState state;
  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final names = {
      PhoneCountry.pe: l10n.countryPeru,
      PhoneCountry.es: l10n.countrySpain,
      PhoneCountry.cl: l10n.countryChile,
    };
    return PopupMenuButton<PhoneCountry>(
      tooltip: l10n.onboardingCountryLabel,
      onSelected: viewModel.onCountry,
      color: VioraColors.neutral50,
      itemBuilder: (context) => [
        for (final country in PhoneCountry.values)
          PopupMenuItem(
            value: country,
            child: Text('${names[country]}  ${country.dialCode}'),
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingCountryLabel,
            style: textTheme.labelMedium?.copyWith(color: VioraColors.neutral600),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              '${state.country.iso} ${state.country.dialCode}',
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                height: 28 / 20,
                letterSpacing: 0,
                color: VioraColors.neutral900,
              ),
            ),
          ),
          Container(height: 1, color: VioraColors.neutral300),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, required this.onEdit});

  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: VioraColors.neutral200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.1,
                    color: VioraColors.neutral600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: textTheme.headlineSmall?.copyWith(color: VioraColors.neutral900),
                ),
              ],
            ),
          ),
          UnderlinedLink(text: AppLocalizations.of(context).onboardingEdit, onTap: onEdit),
        ],
      ),
    );
  }
}
