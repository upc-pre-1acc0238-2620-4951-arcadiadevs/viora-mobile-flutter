import 'package:go_router/go_router.dart';

import '../app_shell.dart';
import '../core/navigation/placeholder_screen.dart';
import '../core/navigation/top_level_destination.dart';
import '../features/home/presentation/ui/home_page.dart';

/// Raíz de composición de la navegación: el único código que conoce todos los
/// features (`core/` nunca importa `features/`).
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
