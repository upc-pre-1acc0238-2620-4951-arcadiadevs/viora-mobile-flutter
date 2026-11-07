import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/navigation/app_routes.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_guard_view_model.dart';

/// Wraps the screens that need a license in force. When it runs out or is taken away, the
/// manager goes back to the license check, so without a license only the activation (G01) shows.
class LicenseGuard extends StatefulWidget {
  const LicenseGuard({super.key, required this.child});

  final Widget child;

  @override
  State<LicenseGuard> createState() => _LicenseGuardState();
}

class _LicenseGuardState extends State<LicenseGuard> {
  final LicenseGuardViewModel _viewModel = getIt<LicenseGuardViewModel>();
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _viewModel.recheck);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LicenseGuardViewModel, bool>(
      bloc: _viewModel,
      listenWhen: (previous, current) => current,
      listener: (context, _) => context.go(AppRoutes.licenseGate),
      child: widget.child,
    );
  }
}
