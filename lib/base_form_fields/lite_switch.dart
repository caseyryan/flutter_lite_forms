import 'package:flutter/cupertino.dart';
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

class LiteSwitch extends StatefulWidget {
  const LiteSwitch({
    super.key,
    required this.name,
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
  });

  final String name;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final ValueChanged<bool>? onChanged;
  final LiteSwitchType type;

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
    bool? value = _tryGetValue(
      fieldName: widget.name,
      formName: formName,
    );
    if (widget.type == LiteSwitchType.material) {
      
    }
    return CupertinoSwitch(
      value: value == true,
      onChanged: (value) {
        liteFormController.onValueChanged(
          formName: formName,
          fieldName: widget.name,
          value: value,
        );
        widget.onChanged?.call(value);
        liteFormRebuildController.rebuild();
      },
    );
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
          return Row(
            children: [
              _buildToggle(
                formName: group.name,
              ),
            ],
          );
        },
      ),
    );
  }
}
