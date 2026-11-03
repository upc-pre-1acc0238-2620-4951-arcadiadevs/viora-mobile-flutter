import 'package:flutter/material.dart';

/// Crossfade between full screens, the same motion the Producer app gets from its
/// navigation host: both screens fade over 700 ms, with no slide or zoom.
class VioraPageTransitionsBuilder extends PageTransitionsBuilder {
  const VioraPageTransitionsBuilder();

  static const theme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: VioraPageTransitionsBuilder(),
      TargetPlatform.iOS: VioraPageTransitionsBuilder(),
    },
  );

  static final _ease = CurveTween(curve: Curves.fastOutSlowIn);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(_ease),
      child: FadeTransition(
        opacity: ReverseAnimation(secondaryAnimation).drive(_ease),
        child: child,
      ),
    );
  }
}
