import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Rutas de los iconos SVG (convertidos desde los vector drawables de Android,
/// mismos nombres que en `res/drawable`).
abstract final class VioraIcons {
  static const home = 'assets/icons/ic_home.svg';
  static const map = 'assets/icons/ic_map.svg';
  static const calendarMonth = 'assets/icons/ic_calendar_month.svg';
  static const menuBook = 'assets/icons/ic_menu_book.svg';
  static const notifications = 'assets/icons/ic_notifications.svg';
  static const add = 'assets/icons/ic_add.svg';
  static const chevronRight = 'assets/icons/ic_chevron_right.svg';
  static const isotype = 'assets/icons/ic_isotype.svg';
}

/// Icono SVG teñido con [color] (equivale a `Icon(painter, tint)` de Compose).
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
