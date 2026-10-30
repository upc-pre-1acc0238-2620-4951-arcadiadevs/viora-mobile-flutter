import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/designsystem/component/viora_tab_bar.dart';
import 'core/navigation/top_level_destination.dart';

/// Shell de la app: el contenido de la rama activa con la barra flotante encima.
/// Las pantallas que se abren fuera del shell (asistentes, mapas a pantalla
/// completa) tapan la barra de forma natural.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: VioraTabBarDefaults.bottomMargin),
              child: VioraTabBar(
                items: [
                  for (final d in TopLevelDestination.values)
                    TabBarItem(iconAsset: d.iconAsset, label: d.label),
                ],
                selectedIndex: navigationShell.currentIndex,
                onItemSelected: (index) => navigationShell.goBranch(
                  index,
                  // Tocar el tab activo vuelve a la raíz de su rama.
                  initialLocation: index == navigationShell.currentIndex,
                ),
                actionLabel: '¿Qué vas a registrar?',
                // TODO(shell): abrir el menú "¿Qué vas a registrar?".
                onActionPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
