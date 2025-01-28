import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final Color? color;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final bool useOfferStyle;
  final bool isSliver;

  const Label({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.paddingTop = 10.0,
    this.paddingBottom = 10.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.textStyle,
    this.color,
    this.useOfferStyle = false,
    this.isSliver = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle? style;
    if (textStyle != null) {
      style = textStyle;
    }
    if (color != null) {
      style = style!.copyWith(
        color: color,
      );
    }

    final child = Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        right: paddingRight,
        left: paddingLeft,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: style,
              textAlign: textAlign,
            ),
          ),
        ],
      ),
    );
    if (isSliver) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
  }
}
