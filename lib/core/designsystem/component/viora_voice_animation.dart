import 'package:flutter/widgets.dart';

/// The producer's preference "Voz de Viora animada" (Mi cuenta › Preferencias), provided once at
/// the root of the app. Off, fixed texts of [VioraVoice] show complete with the isotype.
class VioraVoiceAnimation extends InheritedWidget {
  const VioraVoiceAnimation({super.key, required this.enabled, required super.child});

  final bool enabled;

  /// The preference above [context]; on when nothing provides it.
  static bool enabledOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VioraVoiceAnimation>()?.enabled ?? true;

  @override
  bool updateShouldNotify(VioraVoiceAnimation oldWidget) => enabled != oldWidget.enabled;
}
