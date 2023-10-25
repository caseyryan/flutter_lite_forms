import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/exports.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/utils/exports.dart';

import 'mixins/form_field_mixin.dart';

class LiteImagePicker extends StatefulWidget {
  const LiteImagePicker({
    required this.name,
    super.key,
    this.autovalidateMode,
    this.initialValueDeserializer,
    this.initialValue,
    this.serializer = nonConvertingValueConvertor,
    this.validators,
    this.hintText,
    this.dropSelectorType = LiteDropSelectorViewType.adaptive,
    this.errorStyle,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.aspectRatio,
    this.constraints,
    this.width = 110.0,
    this.height = 70.0,
  });

  final String name;
  final LiteDropSelectorViewType dropSelectorType;
  final double paddingTop;
  final BoxConstraints? constraints;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final Object? initialValue;
  final String? hintText;
  final AutovalidateMode? autovalidateMode;
  final TextStyle? errorStyle;
  final double? aspectRatio;
  final double width;
  final double height;

  /// Allows you to prepare the data for some general usage like sending it
  /// to an api endpoint. E.g. you have a Date Picker which returns a DateTime object
  /// but you need to send it to a backend in a iso8601 string format.
  /// Just pass the serializer like this: serializer: (value) => value.toIso8601String()
  /// And it will always store this date as a string in a form map which you can easily send
  /// wherever you need
  final LiteFormValueSerializer serializer;

  /// Allows you to convert initial value to a proper data type or
  /// format before using it. E.g. you have a iso8601 format but you need
  /// to have a DateTime object to work with in a date picker.
  /// Use [initialValueDeserializer] to convert iso8601 value to a DateTime
  /// like so: initialValueDeserializer: (value) => DateTime.parse(value);
  /// and you will get a DateTime as an initial value. You can use any custom
  /// conversions you want
  final LiteFormValueSerializer? initialValueDeserializer;
  final List<LiteFormFieldValidator<Object?>>? validators;

  @override
  State<LiteImagePicker> createState() => _LiteImagePickerState();
}

class _LiteImagePickerState extends State<LiteImagePicker> with FormFieldMixin {
  Widget _tryWrapWithAspectRatio({
    required Widget child,
  }) {
    if (widget.aspectRatio != null) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: child,
      );
    }
    return child;
  }

  Widget _tryWrapWithConstraints({
    required Widget child,
  }) {
    if (widget.constraints != null) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            constraints: widget.constraints,
            child: child,
          ),
        ],
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    initializeFormField(
      fieldName: widget.name,
      autovalidateMode: widget.autovalidateMode,
      serializer: widget.serializer,
      initialValueDeserializer: widget.initialValueDeserializer,
      validators: widget.validators,
      hintText: widget.hintText,
      decoration: null,
      errorStyle: widget.errorStyle,
    );

    tryDeserializeInitialValueIfNecessary(
      rawInitialValue: widget.initialValue,
      initialValueDeserializer: widget.initialValueDeserializer,
    );

    setInitialValue(
      fieldName: widget.name,
      formName: group.name,
      setter: () {
        liteFormController.onValueChanged(
          fieldName: widget.name,
          formName: group.name,
          value: initialValue,
          isInitialValue: true,
          view: null,
        );
      },
    );
    return Padding(
      padding: EdgeInsets.only(
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
        left: widget.paddingLeft,
        right: widget.paddingRight,
      ),
      child: _tryWrapWithConstraints(
        child: _tryWrapWithAspectRatio(
          child: LiteDropSelector(
            dropSelectorType: widget.dropSelectorType,
            dropSelectorActionType: LiteDropSelectorActionType.simpleWithNoSelection,
            selectorViewBuilder: (context, selectedItems) {
              return Container(
                width: widget.width,
                height: widget.height,
                color: Colors.blue,
              );
            },
            name: widget.name.toFormIgnoreName(),
            items: const ['Take a Photo', 'Pick an Image from Gallery'],
          ),
          // child: Container(
          //   width: widget.width,
          //   height: widget.height,
          //   color: Colors.blue,
          // ),
        ),
      ),
    );
  }
}
