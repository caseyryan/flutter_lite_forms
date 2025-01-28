import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'smooth_icon_base.dart';

class SmoothIconDataIcon extends StatelessWidget {
  final double size;
  final IconData iconData;
  final Color? color;
  final Color? backgroundColor;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final EdgeInsets? iconPadding;

  const SmoothIconDataIcon({
    Key? key,
    this.size = 24.0,
    required this.iconData,
    this.color,
    this.iconPadding,
    this.backgroundColor,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget icon = FaIcon(
      iconData,
      size: size,
      color: color,
    );

    return SmoothIconBase(
      paddingBottom: paddingBottom,
      paddingLeft: paddingLeft,
      paddingRight: paddingRight,
      paddingTop: paddingTop,
      backgroundColor: backgroundColor,
      iconColor: color,
      child: Padding(
        padding: iconPadding ?? const EdgeInsets.all(5.0),
        child: icon,
      ),
    );
  }
}
