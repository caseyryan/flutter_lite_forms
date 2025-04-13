import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/utils/extended_platform/extended_platform.dart';

/// https://www.johndcook.com/blog/2018/02/13/squircle-curvature/
class SmoothIconBase extends StatelessWidget {
  final double size;
  final Color? iconColor;
  final double defaultBackgroundOpacity;
  final Widget child;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final Color? backgroundColor;

  const SmoothIconBase({
    super.key,
    required this.child,
    this.size = 200.0,
    this.iconColor,
    this.defaultBackgroundOpacity = .1,
    this.paddingTop = 0.0,
    this.backgroundColor,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: LayoutBuilder(
            builder: (c, BoxConstraints constraints) {
              final biggestSide = constraints.maxWidth;
              return Container(
                decoration: ShapeDecoration(
                  color: backgroundColor ??
                      (iconColor ?? Theme.of(context).iconTheme.color)!.withValues(
                        alpha: defaultBackgroundOpacity,
                      ),
                  shape: ExtendedPlatform.isWebHtmlRenderer
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            biggestSide / 3.75,
                          ),
                        )
                      : SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: biggestSide / 3.75,
                            cornerSmoothing: 1.0,
                          ),
                        ),
                ),
                child: Center(
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
