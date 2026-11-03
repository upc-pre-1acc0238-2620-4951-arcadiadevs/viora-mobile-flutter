import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/spacing.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/features/home/presentation/state/home_ui_state.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:viora/features/home/presentation/ui/widgets/campaign_chip.dart';
import 'package:viora/features/home/presentation/ui/widgets/home_header.dart';
import 'package:viora/features/home/presentation/ui/widgets/home_headline.dart';

void _noop() {}

/// Home screen. Connects the ViewModel with the UI.
///
/// The sections owned by other features (phase, "Hoy en tu campo", alternation) plug
/// into [sections], in design order; "Mis lotes" always comes last. This way the Home
/// is only the container and doesn't know those features.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.onOpenAlerts = _noop,
    this.sections = const [],
  });

  final VoidCallback onOpenAlerts;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeViewModel>(),
      child: BlocBuilder<HomeViewModel, HomeUiState>(
        builder: (context, state) => HomePageContent(
          state: state,
          onOpenAlerts: onOpenAlerts,
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
    this.sections = const [],
    this.today,
  });

  final HomeUiState state;
  final VoidCallback onOpenAlerts;
  final List<Widget> sections;

  /// Date shown; today by default (injectable for tests).
  final DateTime? today;

  @override
  Widget build(BuildContext context) {
    final date = today ?? DateTime.now();
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
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
                date: date,
                displayName: state.displayName,
                hasUnreadAlerts: state.hasUnreadAlerts,
                onOpenAlerts: onOpenAlerts,
              ),
              const SizedBox(height: 28),
              const HomeHeadline(lead: 'Tu campo,', emphasis: 'hoy.'),
              const SizedBox(height: Spacing.sm),
              CampaignChip(text: 'Campaña ${date.year}'),
              for (final section in sections) ...[
                const SizedBox(height: Spacing.lg),
                section,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
