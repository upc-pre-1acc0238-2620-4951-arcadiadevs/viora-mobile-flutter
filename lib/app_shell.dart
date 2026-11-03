import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/navigation/top_level_destination.dart';

/// App shell: the content of the active branch with the floating bar on top.
/// Screens opened outside the shell (wizards, full-screen maps) cover the bar
/// naturally.
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
                  // Tapping the active tab goes back to the root of its branch.
                  initialLocation: index == navigationShell.currentIndex,
                ),
                actionLabel: '¿Qué vas a registrar?',
                // TODO(shell): open the "¿Qué vas a registrar?" menu.
                onActionPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
