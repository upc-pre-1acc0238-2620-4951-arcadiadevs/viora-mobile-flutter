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

/// Home / "Inicio" (Figma P10). Conecta el ViewModel con la UI; equivale a
/// `HomeScreen` de Android.
///
/// Las secciones de otros features (fase, "Hoy en tu campo", alternancia) se
/// enchufan por [sections], en el orden del diseño; "Mis lotes" va siempre al
/// final. Así el Home solo es el contenedor y no conoce a esos features.
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

/// Contenedor visual del Home: sin Bloc, para poder probarlo con un
/// [HomeUiState] fijo (equivale a `HomeScreenContent`).
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

  /// Fecha mostrada; por defecto la de hoy (inyectable para pruebas).
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
            // Toda pantalla de tab reserva el espacio de la barra flotante.
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
