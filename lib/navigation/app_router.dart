import 'package:go_router/go_router.dart';

import 'package:viora/app_shell.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/navigation/placeholder_screen.dart';
import 'package:viora/core/navigation/top_level_destination.dart';
import 'package:viora/features/home/presentation/ui/home_page.dart';

/// Composition root of navigation: the one place that knows the screens of every
/// feature. Inside `core/`, only `di/` and `database/` may import `features/`.
///
/// When a feature is ready, replace the `PlaceholderScreen` of its tab with the
/// feature's root screen and add its detail routes inside the branch.
final GoRouter appRouter = GoRouter(
  initialLocation: TopLevelDestination.home.path,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
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
