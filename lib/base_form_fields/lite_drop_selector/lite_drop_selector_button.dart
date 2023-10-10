import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/lite_drop_selector.dart';
import 'package:lite_forms/smooth_icons/smooth_icondata_icon.dart';

class LiteDropSelectorButton extends StatefulWidget {
  const LiteDropSelectorButton({
    Key? key,
    required this.data,
    required this.onPressed,
    required this.buttonHeight,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  }) : super(key: key);

  final LiteDropSelectorItem data;
  final ValueChanged<LiteDropSelectorItem> onPressed;
  final double buttonHeight;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  @override
  State<LiteDropSelectorButton> createState() => _LiteDropSelectorButtonState();
}

class _LiteDropSelectorButtonState extends State<LiteDropSelectorButton> {
  Color get iconColor {
    return Colors.red;
    // if (widget.data.isSelected) {
    //   return themeColors.primaryColor;
    // }
    // return widget.data.iconColor ?? themeColors.primaryColor;
  }

  Color get iconBackgroundColor {
    return Colors.white;
  }

  Widget _buildIcon() {
    if (widget.data.iconData != null) {
      return SmoothIconDataIcon(
        iconData: widget.data.iconData!,
        color: iconColor,
        backgroundColor: iconBackgroundColor,
        size: widget.data.iconSize ?? 24.0,
      );
    }

    return const SizedBox.shrink();
  }

  Color get _selectedBorderColor {
    return Colors.red;
  }

  BoxDecoration? _buildDecoration() {
    return BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(
          color: widget.data.isSelected ? _selectedBorderColor : Colors.transparent,
          width: 1.0,
        ),
      ),
      color: widget.data.isSelected
          ? _selectedBorderColor.withOpacity(.03)
          : Colors.transparent,
      borderRadius: _borderRadius,
    );
  }

  Color get _textColor {
    return Colors.black;
  }

  BorderRadius? get _borderRadius {
    return const SmoothBorderRadius.all(
      SmoothRadius(
        cornerRadius: 16.0,
        cornerSmoothing: 1.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isSeparator) {
      return SizedBox(
        width: widget.data.menuWidth ?? 0.0,
        height: 20.0,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: widget.paddingLeft,
              right: widget.paddingRight,
            ),
            child: Container(
              height: .1,
              color: _textColor,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: widget.data.menuWidth,
      height: widget.buttonHeight,
      child: Padding(
        padding:  EdgeInsets.only(
          left: widget.paddingLeft,
          right: widget.paddingRight,
        ),
        child: InkWell(
          highlightColor: Colors.transparent,
          borderRadius: _borderRadius,
          onTap: () {
            widget.onPressed.call(widget.data);
          },
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            decoration: _buildDecoration(),
            child: Padding(
              padding: EdgeInsets.only(
                top: widget.paddingTop,
                bottom: widget.paddingBottom,
                left: widget.paddingLeft,
                right: widget.paddingRight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIcon(),
                  Flexible(
                    child: Text(
                      widget.data.title,
                      // style: widget.data.textStyle ?? textStyles.textStyle_normal,
                    ),
                  ),
                  // SizedBox(width: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
