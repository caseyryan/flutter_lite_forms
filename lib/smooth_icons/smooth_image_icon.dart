import 'package:flutter/material.dart';

import 'smooth_icon_base.dart';

class SmoothImageIcon extends StatelessWidget {
  const SmoothImageIcon({
    Key? key,
    this.size = 24.0,
    required this.iconPath,
    this.color,
    this.iconPadding,
    this.backgroundColor,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  }) : super(key: key);

  final double size;
  final String iconPath;
  final Color? color;
  final Color? backgroundColor;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final EdgeInsets? iconPadding;

  @override
  Widget build(BuildContext context) {
    Widget icon;
    if (iconPath.startsWith('http')) {
      icon = Image.network(
        iconPath,
        width: size,
        color: color,
      );
    } else {
      icon = Image.asset(
        iconPath,
        width: size,
        color: color,
      );
    }

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
