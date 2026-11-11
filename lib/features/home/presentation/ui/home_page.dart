import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/home/presentation/state/home_ui_state.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:viora/features/home/presentation/ui/widgets/home_header.dart';
import 'package:viora/features/home/presentation/ui/widgets/home_headline.dart';

void _noop() {}

/// Home screen. Connects the ViewModel with the UI.
///
/// The sections owned by other features (valley risk, cooperative summary, suggested
/// visits) plug into [sections], in design order, and their line in the voice of Viora into
/// [voice]. This way the Home is only the container and doesn't know those features.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.onOpenAlerts = _noop,
    this.onOpenAccount = _noop,
    this.voice,
    this.onRefresh,
    this.sections = const [],
  });

  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenAccount;
  final Widget? voice;

  /// Pulling the Home down reads its sections again.
  final Future<void> Function()? onRefresh;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeViewModel>(),
      child: BlocBuilder<HomeViewModel, HomeUiState>(
        builder: (context, state) => HomePageContent(
          state: state,
          onOpenAlerts: onOpenAlerts,
          onOpenAccount: onOpenAccount,
          voice: voice,
          onRefresh: onRefresh,
          sections: sections,
        ),
      ),
    );
  }
}

/// Visual container of the Home. It has no Bloc dependency, so it can be tested with
/// a fixed [HomeUiState].
class HomePageContent extends StatelessWidget {
  const HomePageContent({
    super.key,
    required this.state,
    this.onOpenAlerts = _noop,
    this.onOpenAccount = _noop,
    this.voice,
    this.onRefresh,
    this.sections = const [],
  });

  final HomeUiState state;
  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenAccount;

  /// Takes the place of [HomeUiState.voiceMessage] when a feature says the line.
  final Widget? voice;
  final Future<void> Function()? onRefresh;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final l10n = AppLocalizations.of(context);
    final voice = this.voice ?? (state.voiceMessage == null ? null : VioraVoice(text: state.voiceMessage!));
    final onRefresh = this.onRefresh;

    final content = SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.sm,
            Spacing.lg,
            // Every tab screen reserves the space of the floating bar.
            VioraTabBarDefaults.contentBottomPadding + bottomInset,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                displayName: state.displayName,
                organizationName: state.organizationName,
                hasUnreadAlerts: state.hasUnreadAlerts,
                onOpenAlerts: onOpenAlerts,
                onOpenAccount: onOpenAccount,
              ),
              const SizedBox(height: 28),
              HomeHeadline(lead: l10n.homeHeadlineLead, emphasis: l10n.homeHeadlineEmphasis),
              if (voice != null) ...[
                const SizedBox(height: Spacing.sm),
                voice,
              ],
              for (var i = 0; i < sections.length; i++) ...[
                SizedBox(height: i == 0 ? Spacing.md : 28),
                sections[i],
              ],
            ],
          ),
        );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: onRefresh == null
            ? content
            : RefreshIndicator(color: VioraColors.green800, onRefresh: onRefresh, child: content),
      ),
    );
  }
}
