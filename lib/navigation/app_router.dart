import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:viora/app_shell.dart';
import 'package:viora/core/datastore/session_events.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/navigation/placeholder_screen.dart';
import 'package:viora/core/navigation/top_level_destination.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/codes_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/issued_codes_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/manager_alerts_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/member_detail_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/members_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/risk_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/provisional_dossier_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/risk_plot_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/sector_detail_page.dart';
import 'package:viora/features/home/presentation/ui/home_page.dart';
import 'package:viora/features/home/presentation/ui/widgets/home_greeting.dart';
import 'package:viora/features/iam/presentation/ui/iam_page.dart';
import 'package:viora/features/iam/presentation/ui/onboarding_page.dart';
import 'package:viora/features/iam/presentation/ui/splash_page.dart';
import 'package:viora/features/iam/presentation/ui/welcome_page.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';
import 'package:viora/features/profiles/presentation/ui/account_page.dart';
import 'package:viora/features/profiles/presentation/ui/change_password_page.dart';
import 'package:viora/features/profiles/presentation/ui/edit_profile_page.dart';
import 'package:viora/features/subscription/presentation/ui/license_activation_page.dart';
import 'package:viora/features/subscription/presentation/ui/license_gate_page.dart';
import 'package:viora/features/subscription/presentation/ui/producer_plan_page.dart';
import 'package:viora/features/subscription/presentation/ui/widgets/license_guard.dart';
import 'package:viora/features/subscription/presentation/ui/widgets/license_status_widgets.dart';

/// Composition root of navigation: the one place that knows the screens of every
/// feature. Inside `core/`, only `di/` and `database/` may import `features/`.
///
/// When a feature is ready, replace the `PlaceholderScreen` of its tab with the
/// feature's root screen and add its detail routes inside the branch.
/// The navigator over the shell: screens on it cover the tab bar.
final _rootNavigator = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigator,
  initialLocation: SplashPage.path,
  routes: [
    GoRoute(
      path: SplashPage.path,
      pageBuilder: (context, state) => const NoTransitionPage(child: SplashPage()),
    ),
    GoRoute(path: WelcomePage.path, builder: (context, state) => const WelcomePage()),
    GoRoute(path: OnboardingPage.path, builder: (context, state) => const OnboardingPage()),
    GoRoute(
      path: IamPage.path,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<IamViewModel>()
          ..start(createAccount: state.uri.queryParameters['create'] == 'true'),
        child: const IamPage(),
      ),
    ),
    GoRoute(
      path: IamPage.resetPath,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<IamViewModel>()..start(resetToken: state.pathParameters['token']),
        child: const IamPage(),
      ),
    ),
    GoRoute(
      path: LicenseGatePage.path,
      pageBuilder: (context, state) => const NoTransitionPage(child: LicenseGatePage()),
    ),
    GoRoute(path: LicenseActivationPage.path, builder: (context, state) => const LicenseActivationPage()),
    GoRoute(path: ProducerPlanPage.path, builder: (context, state) => const ProducerPlanPage()),
    GoRoute(
      path: AccountPage.path,
      builder: (context, state) => const AccountPage(
        statusBadge: LicenseStatusBadge(),
        roleSuffix: LicenseOrganizationSuffix(),
      ),
    ),
    GoRoute(path: EditProfilePage.path, builder: (context, state) => const EditProfilePage()),
    GoRoute(path: ChangePasswordPage.path, builder: (context, state) => const ChangePasswordPage()),
    StatefulShellRoute.indexedStack(
      // The tabs and the screens opened over them need a license in force.
      builder: (context, state, navigationShell) =>
          LicenseGuard(child: AppShell(navigationShell: navigationShell)),
      branches: [
        for (final d in TopLevelDestination.values)
          StatefulShellBranch(
            routes: [
              if (d == TopLevelDestination.members)
                _membersRoute(d.path)
              else if (d == TopLevelDestination.risk)
                _riskRoute(d.path)
              else
                GoRoute(
                  path: d.path,
                  builder: (context, state) => d == TopLevelDestination.home
                      ? HomePage(
                          onOpenAccount: () => context.push(AccountPage.path),
                          onOpenAlerts: () => context.push('${d.path}/${ManagerAlertsPage.path}'),
                        )
                      : PlaceholderScreen(title: d.label(AppLocalizations.of(context))),
                  routes: [if (d == TopLevelDestination.home) _alertsRoute(d.path)],
                ),
            ],
          ),
      ],
    ),
  ],
);

/// G40 · Socios and what opens from it: G41 · Socio, G42 · Códigos and G44 · Códigos generados,
/// which covers the tab bar as in the design.
GoRoute _membersRoute(String path) {
  final codes = '$path/codes';
  final issued = '$path/issued';
  return GoRoute(
    path: path,
    builder: (context, state) => MembersPage(
      header: HomeGreeting(
        onOpenAccount: () => context.push(AccountPage.path),
        onOpenAlerts: () => context.push('$path/${ManagerAlertsPage.path}'),
      ),
      onOpenMember: (id) => context.push('$path/$id'),
      onOpenCodes: () => context.push<void>(codes),
      onIssued: (args) => context.push<void>(issued, extra: args),
    ),
    routes: [
      _alertsRoute(path),
      GoRoute(
        path: 'codes',
        builder: (context, state) => CodesPage(
          onBack: () => context.pop(),
          onIssued: (args) => context.push<void>(issued, extra: args),
          onOpenMembers: () => context.go(path),
        ),
      ),
      GoRoute(
        path: 'issued',
        parentNavigatorKey: _rootNavigator,
        builder: (context, state) => IssuedCodesPage(
          args: state.extra! as IssuedCodesArgs,
          onClose: () => context.pop(),
          onSeeAll: () => context.go(codes),
        ),
      ),
      GoRoute(
        path: MemberDetailPage.path,
        builder: (context, state) => MemberDetailPage(
          memberId: state.pathParameters['memberId']!,
          onBack: () => context.pop(),
          onOpenPlot: (plotId) => context.push('$path/${state.pathParameters['memberId']}/plots/$plotId'),
        ),
        routes: [_plotRoute((state) => '$path/${state.pathParameters['memberId']}')],
      ),
    ],
  );
}

/// G20 · Riesgo territorial and what opens from it: T14 · Alertas del gestor, G22 · Detalle del
/// sector, G23 · Parcela del socio and T16 · Expediente técnico. The alert preferences are a
/// placeholder until that screen lands.
GoRoute _riskRoute(String path) {
  return GoRoute(
    path: path,
    builder: (context, state) => RiskPage(
      onOpenAlerts: () => context.push('$path/${ManagerAlertsPage.path}'),
      onOpenScope: (scope) => context.push('$path/sectors/$scope'),
      onOpenPlot: (plotId) => context.push('$path/plots/$plotId'),
    ),
    routes: [
      _alertsRoute(path),
      _sectorRoute(path),
      _plotRoute((state) => path),
    ],
  );
}

/// T14 · Alertas del gestor over the tab at [parent] whose bell opened it, so going back returns
/// to that tab. The sectors and plots it opens stay on the same tab.
GoRoute _alertsRoute(String parent) {
  final alerts = '$parent/${ManagerAlertsPage.path}';
  return GoRoute(
    path: ManagerAlertsPage.path,
    builder: (context, state) => ManagerAlertsPage(
      onBack: () => context.pop(),
      onOpenPreferences: () => context.push('$alerts/preferences'),
      onOpenSector: (sectorId) => context.push('$alerts/sectors/$sectorId'),
    ),
    routes: [
      GoRoute(
        path: 'preferences',
        builder: (context, state) => PlaceholderScreen(title: AppLocalizations.of(context).alertsPreferences),
      ),
      _sectorRoute(alerts, nestPlots: true),
    ],
  );
}

/// G22 · Detalle del sector under [parent]. On the map its plots open next to it, under
/// [parent]; opened from an alert, with [nestPlots], they open under the sector itself.
GoRoute _sectorRoute(String parent, {bool nestPlots = false}) {
  String plotParent(GoRouterState state) =>
      nestPlots ? '$parent/sectors/${state.pathParameters['scope']}' : parent;
  return GoRoute(
    path: SectorDetailPage.path,
    builder: (context, state) => SectorDetailPage(
      scope: state.pathParameters['scope']!,
      onBack: () => context.pop(),
      onOpenPlot: (plotId) => context.push('${plotParent(state)}/plots/$plotId'),
    ),
    routes: [if (nestPlots) _plotRoute(plotParent)],
  );
}

/// G23 · Parcela del socio under [parent], with T16 opening from it.
GoRoute _plotRoute(String Function(GoRouterState) parent) {
  return GoRoute(
    path: RiskPlotPage.path,
    builder: (context, state) => RiskPlotPage(
      plotId: state.pathParameters['plotId']!,
      onBack: () => context.pop(),
      onOpenDossier: () => context.push('${parent(state)}/plots/${state.pathParameters['plotId']}/dossier'),
    ),
    routes: [
      GoRoute(
        path: ProvisionalDossierPage.path,
        builder: (context, state) => ProvisionalDossierPage(
          plotId: state.pathParameters['plotId']!,
          onBack: () => context.pop(),
        ),
      ),
    ],
  );
}

/// A session that can no longer be renewed goes back to sign-in, from any screen.
void openSignInWhenSessionExpires() {
  getIt<SessionEvents>().expired.listen((_) => appRouter.go(IamPage.path));
}
