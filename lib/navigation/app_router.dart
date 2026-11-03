import 'package:go_router/go_router.dart';

import 'package:viora/app_shell.dart';
import 'package:viora/core/navigation/placeholder_screen.dart';
import 'package:viora/core/navigation/top_level_destination.dart';
import 'package:viora/features/home/presentation/ui/home_page.dart';

/// Raíz de composición de la navegación: conoce las pantallas de todos los
/// features. En `core/`, solo `di/` y `database/` pueden importar `features/`.
///
/// Para integrar un feature: reemplaza el `PlaceholderScreen` de su tab por su
/// pantalla raíz y agrega sus rutas de detalle dentro de la rama.
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
                    : PlaceholderScreen(title: d.label),
              ),
            ],
          ),
      ],
    ),
  ],
);
