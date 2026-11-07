import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/features/home/presentation/state/home_ui_state.dart';
import 'package:viora/features/home/presentation/ui/widgets/home_header.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';

void _noop() {}

/// The greeting of the Home ("Hola, Rubén", the account and the alerts) for the other tabs
/// that open with it, such as Socios (G40).
class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, this.onOpenAccount = _noop, this.onOpenAlerts = _noop});

  final VoidCallback onOpenAccount;
  final VoidCallback onOpenAlerts;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeViewModel>(),
      child: BlocBuilder<HomeViewModel, HomeUiState>(
        builder: (context, state) => HomeHeader(
          displayName: state.displayName,
          subtitle: state.subtitle,
          hasUnreadAlerts: state.hasUnreadAlerts,
          onOpenAlerts: onOpenAlerts,
          onOpenAccount: onOpenAccount,
        ),
      ),
    );
  }
}
