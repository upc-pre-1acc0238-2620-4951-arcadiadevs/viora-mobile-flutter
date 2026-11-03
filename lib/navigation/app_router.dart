import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:viora/app_shell.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/navigation/placeholder_screen.dart';
import 'package:viora/core/navigation/top_level_destination.dart';
import 'package:viora/features/home/presentation/ui/home_page.dart';
import 'package:viora/features/iam/presentation/ui/iam_page.dart';
import 'package:viora/features/iam/presentation/ui/onboarding_page.dart';
import 'package:viora/features/iam/presentation/ui/splash_page.dart';
import 'package:viora/features/iam/presentation/ui/welcome_page.dart';
import 'package:viora/features/iam/presentation/viewmodel/iam_view_model.dart';

/// Composition root of navigation: the one place that knows the screens of every
/// feature. Inside `core/`, only `di/` and `database/` may import `features/`.
///
/// When a feature is ready, replace the `PlaceholderScreen` of its tab with the
/// feature's root screen and add its detail routes inside the branch.
final GoRouter appRouter = GoRouter(
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        for (final d in TopLevelDestination.values)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: d.path,
                builder: (context, state) => d == TopLevelDestination.home
                    ? const HomePage()
                    : PlaceholderScreen(title: d.label(AppLocalizations.of(context))),
              ),
            ],
          ),
      ],
    ),
  ],
);
