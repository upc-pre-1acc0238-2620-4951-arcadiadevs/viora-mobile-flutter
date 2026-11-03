import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Paths of the SVG icons bundled in `assets/icons`.
abstract final class VioraIcons {
  static const home = 'assets/icons/ic_home.svg';
  static const map = 'assets/icons/ic_map.svg';
  static const calendarMonth = 'assets/icons/ic_calendar_month.svg';
  static const menuBook = 'assets/icons/ic_menu_book.svg';
  static const notifications = 'assets/icons/ic_notifications.svg';
  static const add = 'assets/icons/ic_add.svg';
  static const chevronRight = 'assets/icons/ic_chevron_right.svg';
  static const isotype = 'assets/icons/ic_isotype.svg';
  static const locationOn = 'assets/icons/ic_location_on.svg';
  static const inventory2 = 'assets/icons/ic_inventory_2.svg';
  static const groups = 'assets/icons/ic_groups.svg';
  static const arrowForward = 'assets/icons/ic_arrow_forward.svg';
  static const brote = 'assets/icons/ic_brote.svg';
  static const acUnit = 'assets/icons/ic_ac_unit.svg';
  static const scale = 'assets/icons/ic_scale.svg';
  static const arrowBack = 'assets/icons/ic_arrow_back.svg';
  static const check = 'assets/icons/ic_check.svg';
  static const close = 'assets/icons/ic_close.svg';
  static const logoWordmarkMark = 'assets/icons/logo_wordmark_mark.svg';
  static const logoWordmarkLetters = 'assets/icons/logo_wordmark_letters.svg';
}

/// SVG icon tinted with [color].
class VioraIcon extends StatelessWidget {
  const VioraIcon(
    this.asset, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  final String asset;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? IconTheme.of(context).color;
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      semanticsLabel: semanticLabel,
      colorFilter: tint == null ? null : ColorFilter.mode(tint, BlendMode.srcIn),
    );
  }
}
