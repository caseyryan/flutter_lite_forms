import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/lite_drop_selector.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';

class LiteDropSelectorButton extends StatefulWidget {
  const LiteDropSelectorButton({
    Key? key,
    required this.data,
    required this.buttonHeight,
    required this.decoration,
    required this.style,
    required this.sheetSettings,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  }) : super(key: key);

  final LiteDropSelectorItem data;
  final double buttonHeight;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final TextStyle? style;
  final InputDecoration? decoration;
  final LiteDropSelectorSheetSettings sheetSettings;

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
    if (widget.data.iconBuilder != null) {
      return Padding(
        padding:  EdgeInsets.only(
          right: widget.paddingRight,
        ),
        child: SizedBox(
          height: widget.buttonHeight,
          child: Center(
            child: widget.data.iconBuilder!(
              context,
              widget.data,
              widget.data.isSelected,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Color get _selectedBorderColor {
    final primaryColor = Theme.of(context).primaryColor;
    if (widget.decoration != null) {
      return widget.decoration?.focusedBorder?.borderSide.color ?? primaryColor;
    }
    return primaryColor;
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
    return _textStyle?.color ??
        Theme.of(context).textTheme.titleMedium?.color ??
        Colors.black;
  }

  TextStyle? get _textStyle {
    return liteFormController.config?.defaultTextStyle ??
        widget.style ??
        Theme.of(context).textTheme.titleMedium;
  }

  BorderRadius? get _borderRadius {
    return SmoothBorderRadius.only(
      topLeft: SmoothRadius(
        cornerRadius: widget.sheetSettings.topLeftRadius,
        cornerSmoothing: 1.0,
      ),
      topRight: SmoothRadius(
        cornerRadius: widget.sheetSettings.topRightRadius,
        cornerSmoothing: 1.0,
      ),
      bottomLeft: SmoothRadius(
        cornerRadius: widget.sheetSettings.bottomLeftRadius,
        cornerSmoothing: 1.0,
      ),
      bottomRight: SmoothRadius(
        cornerRadius: widget.sheetSettings.bottomRightRadius,
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
        padding: EdgeInsets.only(
          left: widget.paddingLeft,
          right: widget.paddingRight,
        ),
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
                    style: _textStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
