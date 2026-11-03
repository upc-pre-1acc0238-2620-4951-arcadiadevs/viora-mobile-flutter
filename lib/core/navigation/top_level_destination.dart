import 'package:viora/core/designsystem/component/viora_icon.dart';

/// The destinations of the floating tab bar, in display order. The shell and the
/// bar are built from this list, so changing the tabs only means editing it.
enum TopLevelDestination {
  home('/home', 'Inicio', VioraIcons.home),
  plots('/plots', 'Lotes', VioraIcons.map),
  plan('/plan', 'Plan', VioraIcons.calendarMonth),
  logbook('/logbook', 'Bitácora', VioraIcons.menuBook);

  const TopLevelDestination(this.path, this.label, this.iconAsset);

  final String path;
  final String label;
  final String iconAsset;
}
