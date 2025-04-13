import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/lite_drop_selector.dart';
import 'package:lite_forms/constants.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/utils/extended_platform/extended_platform.dart';

class LiteDropSelectorButton extends StatefulWidget {
  const LiteDropSelectorButton({
    super.key,
    required this.data,
    required this.buttonHeight,
    required this.decoration,
    required this.style,
    required this.showSelection,
    required this.sheetSettings,
    required this.onPressed,
    this.destructiveItemColor,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  });

  final LiteDropSelectorItem data;
  final double buttonHeight;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final TextStyle? style;
  final Color? destructiveItemColor;
  final InputDecoration? decoration;
  final DropSelectorSettings sheetSettings;
  final bool showSelection;
  final ValueChanged<LiteDropSelectorItem> onPressed;

  @override
  State<LiteDropSelectorButton> createState() => _LiteDropSelectorButtonState();
}

class _LiteDropSelectorButtonState extends State<LiteDropSelectorButton> {
  Widget _buildIcon() {
    if (widget.data.iconBuilder != null) {
      final theme = Theme.of(context);
      return Padding(
        padding: EdgeInsets.only(
          right: widget.paddingRight,
        ),
        child: Theme(
          data: ThemeData(
            iconTheme: IconThemeData(
              color: widget.data.isDestructive ? widget.destructiveItemColor ?? _errorColor : theme.iconTheme.color,
            ),
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

  double get _selectedBorderWidth {
    if (widget.decoration != null) {
      return widget.decoration?.focusedBorder?.borderSide.width ?? kDefaultSelectedBorderWidth;
    }
    return kDefaultSelectedBorderWidth;
  }

  BoxDecoration? _buildDecoration() {
    return widget.showSelection
        ? BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(
                color: widget.data.isSelected ? _selectedBorderColor : Colors.transparent,
                width: widget.data.selectedBorderWidth ?? _selectedBorderWidth,
              ),
            ),
            color: widget.data.isSelected ? _selectedBorderColor.withValues(alpha: .03) : Colors.transparent,
            borderRadius: _borderRadius,
          )
        : null;
  }

  BorderRadius? get _defaultRadius {
    if (widget.decoration?.border is OutlineInputBorder) {
      final outlineBorder = widget.decoration!.border! as OutlineInputBorder;
      return outlineBorder.borderRadius;
    }
    return null;
  }

  Color get _textColor {
    return _textStyle?.color ?? Theme.of(context).textTheme.titleMedium?.color ?? Colors.black;
  }

  TextStyle? get _textStyle {
    final style = widget.style ?? formConfig?.defaultTextStyle ?? Theme.of(context).textTheme.titleMedium;
    if (widget.data.isDestructive) {
      return style?.copyWith(
        color: widget.destructiveItemColor ?? _errorColor,
      );
    }
    return style;
  }

  Color? get _errorColor {
    return formConfig?.destructiveColor ??
        formConfig?.inputDecoration?.errorStyle?.color ??
        Theme.of(context).colorScheme.error;
  }

  BorderRadius? get _borderRadius {
    if (ExtendedPlatform.isWebHtmlRenderer) {
      return BorderRadius.only(
        topLeft: Radius.circular(
          widget.sheetSettings.topLeftRadius ??
              formConfig?.dropSelectorSettings.topLeftRadius ??
              _defaultRadius?.topLeft.x ??
              kDefaultFormSmoothRadius,
        ),
        topRight: Radius.circular(
          widget.sheetSettings.topRightRadius ??
              formConfig?.dropSelectorSettings.topRightRadius ??
              _defaultRadius?.topRight.x ??
              kDefaultFormSmoothRadius,
        ),
        bottomLeft: Radius.circular(
          widget.sheetSettings.bottomLeftRadius ??
              formConfig?.dropSelectorSettings.bottomLeftRadius ??
              _defaultRadius?.bottomLeft.x ??
              kDefaultFormSmoothRadius,
        ),
        bottomRight: Radius.circular(
          widget.sheetSettings.bottomRightRadius ??
              formConfig?.dropSelectorSettings.bottomRightRadius ??
              _defaultRadius?.bottomRight.x ??
              kDefaultFormSmoothRadius,
        ),
      );
    }
    return SmoothBorderRadius.only(
      topLeft: SmoothRadius(
        cornerRadius: widget.sheetSettings.topLeftRadius ??
            formConfig?.dropSelectorSettings.topLeftRadius ??
            _defaultRadius?.topLeft.x ??
            kDefaultFormSmoothRadius,
        cornerSmoothing: 1.0,
      ),
      topRight: SmoothRadius(
        cornerRadius: widget.sheetSettings.topRightRadius ??
            formConfig?.dropSelectorSettings.topRightRadius ??
            _defaultRadius?.topRight.x ??
            kDefaultFormSmoothRadius,
        cornerSmoothing: 1.0,
      ),
      bottomLeft: SmoothRadius(
        cornerRadius: widget.sheetSettings.bottomLeftRadius ??
            formConfig?.dropSelectorSettings.bottomLeftRadius ??
            _defaultRadius?.bottomLeft.x ??
            kDefaultFormSmoothRadius,
        cornerSmoothing: 1.0,
      ),
      bottomRight: SmoothRadius(
        cornerRadius: widget.sheetSettings.bottomRightRadius ??
            formConfig?.dropSelectorSettings.bottomRightRadius ??
            _defaultRadius?.bottomRight.x ??
            kDefaultFormSmoothRadius,
        cornerSmoothing: 1.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isSeparator) {
      final title = widget.data.title;
      return SizedBox(
        width: widget.data.menuWidth ?? 0.0,
        height: 15.0,
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: widget.paddingLeft,
                    right: title.isNotEmpty ? widget.paddingRight : 0.0,
                  ),
                  child: Container(
                    height: .1,
                    color: _textColor,
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 11.0,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: title.isNotEmpty ? widget.paddingLeft : 0.0,
                    right: widget.paddingRight,
                  ),
                  child: Container(
                    height: .1,
                    color: _textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      color: Colors.transparent,
      width: widget.data.menuWidth,
      height: widget.buttonHeight,
      child: Padding(
        padding: EdgeInsets.only(
          left: widget.paddingLeft,
          right: widget.paddingRight,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: _borderRadius,
            onTap: () {
              widget.onPressed(widget.data);
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
                        style: _textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
