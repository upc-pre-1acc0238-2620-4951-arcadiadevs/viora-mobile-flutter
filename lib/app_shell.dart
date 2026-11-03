import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/navigation/top_level_destination.dart';

/// App shell: the content of the active branch with the floating bar on top, over a
/// gradient that fades the content behind it. Screens opened outside the shell
/// (wizards, full-screen maps) cover the bar naturally.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 150,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.55, 1],
                    colors: [
                      Color(0x00F3F0EA),
                      Color(0xEBF3F0EA),
                      VioraColors.neutral100,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: VioraTabBarDefaults.bottomMargin),
              child: VioraTabBar(
                items: [
                  for (final d in TopLevelDestination.values)
                    TabBarItem(iconAsset: d.iconAsset, label: d.label(l10n)),
                ],
                selectedIndex: navigationShell.currentIndex,
                onItemSelected: (index) => navigationShell.goBranch(
                  index,
                  // Tapping the active tab goes back to the root of its branch.
                  initialLocation: index == navigationShell.currentIndex,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
