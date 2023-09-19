import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/utils/value_serializer.dart';
import 'package:lite_forms/utils/value_validator.dart';
import 'package:lite_state/lite_state.dart';

import 'lite_form_group.dart';

enum LiteSwitchType {
  cupertino,
  material,
}

enum SwitchPosition {
  left,
  right,
}

class LiteSwitch extends StatefulWidget {
  const LiteSwitch({
    super.key,
    required this.name,
    this.switchPosition = SwitchPosition.left,
    this.onChanged,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.serializer = nonConvertingValueConvertor,
    this.initialValueDeserializer,
    this.validator,
    this.initialValue,
    this.autovalidateMode,
    this.type = LiteSwitchType.cupertino,
    this.activeColor,
    this.activeThumbImage,
    this.activeTrackColor,
    this.autofocus = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusColor,
    this.focusNode,
    this.hoverColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.onActiveThumbImageError,
    this.onFocusChange,
    this.overlayColor,
    this.splashRadius,
    this.thumbColor,
    this.thumbIcon,
    this.trackColor,
    this.child,
    this.text,
    this.onInactiveThumbImageError,
  }) : assert(
          (child == null || text == null),
          'You cannot pass both `text` and `child` at the same time',
        );

  /// The position of the switch relative to a [child] or a [text]
  final SwitchPosition switchPosition;
  final Widget? child;
  final String? text;
  final ImageErrorListener? onInactiveThumbImageError;
  final String name;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final ValueChanged<bool>? onChanged;
  final LiteSwitchType type;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? activeThumbImage;
  final ImageErrorListener? onActiveThumbImageError;
  final MaterialStateProperty<Color?>? thumbColor;
  final MaterialStateProperty<Color?>? trackColor;
  final MaterialStateProperty<Icon?>? thumbIcon;
  final MaterialTapTargetSize? materialTapTargetSize;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;

  /// Allows you to prepare the data for some general usage like sending it
  /// to an api endpoint. E.g. you have a Date Picker which returns a DateTime object
  /// but you need to send it to a backend in a iso8601 string format.
  /// Just pass the serializer like this: serializer: (value) => value.toIso8601String()
  /// And it will always store this date as a string in a form map which you can easily send
  /// wherever you need
  final LiteFormValueConvertor serializer;

  /// Allows you to convert initial value to a proper data type or
  /// format before using it. E.g. you have a iso8601 format but you need
  /// to have a DateTime object to work with in a date picker.
  /// Use [initialValueDeserializer] to convert iso8601 value to a DateTime
  /// like so: initialValueDeserializer: (value) => DateTime.parse(value);
  /// and you will get a DateTime as an initial value. You can use any custom
  /// conversions you want
  final LiteFormValueConvertor? initialValueDeserializer;
  final LiteFormFieldValidator<bool>? validator;

  /// even though the type here is specified as Object?
  /// it is assumed that the default value type is [bool]
  /// If you pass something other than [bool], make sure you also
  /// provide [initialValueDeserializer] which will convert initialValue
  /// to [bool]
  final Object? initialValue;
  final AutovalidateMode? autovalidateMode;

  @override
  State<LiteSwitch> createState() => _LiteSwitchState();
}

class _LiteSwitchState extends State<LiteSwitch> {
  bool _hasSetInitialValue = false;

  @override
  void initState() {
    super.initState();
  }

  bool? _tryGetValue({
    required String formName,
    required String fieldName,
  }) {
    final storedValue = liteFormController.tryGetValueForField(
      formName: formName,
      fieldName: fieldName,
    ) as bool?;

    /// If a form was stored before, then the initial value passed from the
    /// constructor will have no effect and the previous value will be used instead
    return storedValue ??
        widget.initialValueDeserializer?.call(widget.initialValue) as bool? ??
        widget.initialValue as bool?;
  }

  Widget _buildToggle({
    required String formName,
  }) {
    bool value = _tryGetValue(
          fieldName: widget.name,
          formName: formName,
        ) ==
        true;
    if (widget.type == LiteSwitchType.material) {
      return Switch(
        value: value,
        activeColor: widget.activeColor,
        activeThumbImage: widget.activeThumbImage,
        activeTrackColor: widget.activeTrackColor,
        autofocus: widget.autofocus,
        dragStartBehavior: widget.dragStartBehavior,
        focusColor: widget.focusColor,
        focusNode: widget.focusNode,
        hoverColor: widget.hoverColor,
        inactiveThumbColor: widget.inactiveThumbColor,
        inactiveThumbImage: widget.activeThumbImage,
        inactiveTrackColor: widget.inactiveTrackColor,
        materialTapTargetSize: widget.materialTapTargetSize,
        mouseCursor: widget.mouseCursor,
        onActiveThumbImageError: widget.onActiveThumbImageError,
        onFocusChange: widget.onFocusChange,
        onInactiveThumbImageError: widget.onInactiveThumbImageError,
        overlayColor: widget.overlayColor,
        splashRadius: widget.splashRadius,
        thumbColor: widget.thumbColor,
        thumbIcon: widget.thumbIcon,
        trackColor: widget.trackColor,
        onChanged: (value) {
          _onChanged(value, formName);
        },
      );
    }
    return CupertinoSwitch(
      value: value,
      dragStartBehavior: widget.dragStartBehavior,
      activeColor: widget.activeColor,
      thumbColor: value ? widget.activeColor : widget.inactiveThumbColor,
      trackColor: value ? widget.activeTrackColor : widget.inactiveTrackColor,
      onChanged: (value) {
        _onChanged(value, formName);
      },
    );
  }

  void _onChanged(
    bool value,
    String formName,
  ) {
    liteFormController.onValueChanged(
      formName: formName,
      fieldName: widget.name,
      value: value,
    );
    widget.onChanged?.call(value);
    liteFormRebuildController.rebuild();
  }

  Widget _buildChild() {
    Widget child = const SizedBox.shrink();
    return Expanded(child: child);
  }

  @override
  Widget build(BuildContext context) {
    final group = LiteFormGroup.of(context);
    liteFormController.registerFormField<bool>(
      fieldName: widget.name,
      formName: group!.name,
      serializer: widget.serializer,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
    );

    if (!_hasSetInitialValue) {
      _hasSetInitialValue = true;
      bool? value = _tryGetValue(
        fieldName: widget.name,
        formName: group.name,
      );
      liteFormController.onValueChanged(
        fieldName: widget.name,
        formName: group.name,
        value: value,
        isInitialValue: true,
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: widget.paddingLeft,
        right: widget.paddingRight,
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
      ),
      child: LiteState<LiteFormRebuildController>(
        builder: (BuildContext c, LiteFormRebuildController controller) {
          final hasChild = widget.child != null || widget.text != null;
          List<Widget>? children;

          if (hasChild) {
            if (widget.switchPosition == SwitchPosition.right) {
              children = [
                _buildChild(),
                _buildToggle(
                  formName: group.name,
                ),
              ];
            } else {
              children = [
                _buildToggle(
                  formName: group.name,
                ),
                _buildChild(),
              ];
            }
          } else {
            children = [
              _buildToggle(
                formName: group.name,
              ),
            ];
          }
          return Row(
            children: children,
          );
        },
      ),
    );
  }
}
