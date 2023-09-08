// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/utils/string_extensions.dart';
import 'package:lite_forms/utils/value_validator.dart';

import '../lite_forms.dart';

class LiteTextFormField extends StatefulWidget {
  LiteTextFormField({
    super.key,
    required this.name,
    this.hintText,
    this.serializer = nonConvertingValueConvertor,
    this.initialValueDeserializer,
    this.validator,
    this.controller,
    this.restorationId,
    this.initialValue,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  });

  final String name;
  final String? hintText;
  final TextEditingController? controller;

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
  final LiteFormFieldValidator<String>? validator;
  final String? restorationId;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  TextCapitalization textCapitalization = TextCapitalization.none;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  TextAlign textAlign = TextAlign.start;
  final TextAlignVertical? textAlignVertical;
  bool autofocus = false;
  bool readOnly = false;
  final bool? showCursor;
  String obscuringCharacter = '•';
  bool obscureText = false;
  bool autocorrect = true;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  bool enableSuggestions = true;
  final MaxLengthEnforcement? maxLengthEnforcement;
  int? maxLines = 1;
  final int? minLines;
  bool expands = false;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  double cursorWidth = 2.0;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  EdgeInsets scrollPadding = const EdgeInsets.all(20.0);
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  bool enableIMEPersonalizedLearning = true;
  final MouseCursor? mouseCursor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  @override
  State<LiteTextFormField> createState() => _LiteTextFormFieldState();
}

class _LiteTextFormFieldState<T> extends State<LiteTextFormField> {
  bool _hasSetInitialValue = false;

  @override
  Widget build(BuildContext context) {
    final group = LiteFormGroup.of(context);
    final field = liteFormController.registerFormField(
      fieldName: widget.name,
      formName: group!.name,
      serializer: widget.serializer,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
    );
    final textEditingController = field.getOrCreateTextEditingController(
      controller: widget.controller,
    );

    final value =
        widget.initialValueDeserializer?.call(widget.initialValue)?.toString() ??
            widget.initialValue;

    if (!_hasSetInitialValue) {
      _hasSetInitialValue = true;
      liteFormController.onValueChanged(
        fieldName: widget.name,
        formName: group.name,
        value: value,
        isInitialValue: true,
      );
    }

    String? hintText = widget.hintText;
    if (hintText?.isNotEmpty != true) {
      if (liteFormController.config?.useAutogeneratedHints == true) {
        hintText = widget.name.splitByCamelCase();
      }
    }
    var decoration = widget.decoration ?? liteFormController.config?.inputDecoration ?? const InputDecoration();
    if (hintText?.isNotEmpty == true) {
      decoration = decoration.copyWith(
        hintText: hintText,
      );
    }
    
    return Padding(
      padding: EdgeInsets.only(
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
        left: widget.paddingLeft,
        right: widget.paddingRight,
      ),
      child: TextFormField(
        restorationId: widget.restorationId,
        scrollController: widget.scrollController,
        validator: widget.validator != null ? (value) {
          return field.error;
        } : null,
        autocorrect: widget.autocorrect,
        autofillHints: widget.autofillHints,
        autofocus: widget.autofocus,
        autovalidateMode: null,
        buildCounter: widget.buildCounter,
        contextMenuBuilder: widget.contextMenuBuilder,
        controller: textEditingController,
        cursorColor: widget.cursorColor,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorWidth: widget.cursorWidth,
        decoration: decoration,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        enableSuggestions: widget.enableSuggestions,
        enabled: widget.enabled,
        expands: widget.expands,
        focusNode: widget.focusNode,
        inputFormatters: widget.inputFormatters,
        keyboardAppearance: widget.keyboardAppearance,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        maxLines: widget.maxLength,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        minLines: widget.minLines,
        mouseCursor: widget.mouseCursor,
        obscureText: widget.obscureText,
        obscuringCharacter: widget.obscuringCharacter,
        onChanged: (value) {
          liteFormController.onValueChanged(
            formName: group.name,
            fieldName: widget.name,
            value: value,
          );
        },
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTap: widget.onTap,
        onTapOutside: widget.onTapOutside,
        scrollPadding: widget.scrollPadding,
        readOnly: widget.readOnly,
        scrollPhysics: widget.scrollPhysics,
        selectionControls: widget.selectionControls,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        showCursor: widget.showCursor,
        strutStyle: widget.strutStyle,
        style: widget.style,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        textCapitalization: widget.textCapitalization,
        textDirection: widget.textDirection,
        textInputAction: widget.textInputAction,
      ),
    );
  }
}
