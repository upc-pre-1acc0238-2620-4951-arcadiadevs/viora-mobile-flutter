import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/l10n/app_localizations.dart';

/// The destinations of the floating tab bar, in display order. The shell and the
/// bar are built from this list, so changing the tabs only means editing it.
enum TopLevelDestination {
  home('/home', VioraIcons.home),
  risk('/risk', VioraIcons.locationOn),
  collection('/collection', VioraIcons.inventory2),
  members('/members', VioraIcons.groups);

  const TopLevelDestination(this.path, this.iconAsset);

  final String path;
  final String iconAsset;

  String label(AppLocalizations l10n) => switch (this) {
        home => l10n.navHome,
        risk => l10n.navRisk,
        collection => l10n.navCollection,
        members => l10n.navMembers,
      };
}
