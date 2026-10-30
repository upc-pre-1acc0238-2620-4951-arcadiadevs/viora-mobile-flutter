import '../designsystem/component/viora_icon.dart';

/// Destinos de la barra flotante, en orden de aparición. Para cambiar los tabs
/// basta con editar esta lista: el shell y la barra se arman solos.
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
