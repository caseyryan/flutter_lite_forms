// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';

import '../lite_forms.dart';

class LiteTextFormField<T> extends StatefulWidget {
  LiteTextFormField({
    super.key,
    required this.name,
    this.serializer = nonConvertingValueConvertor,
    this.initialValueDeserializer,
    this.validator,
    this.controller,
    this.restorationId,
    this.initialValue,
    this.focusNode,
    this.decoration = const InputDecoration(),
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
  });

  final String name;
  final TextEditingController? controller;
  final LiteFormValueConvertor serializer;
  final LiteFormValueConvertor? initialValueDeserializer;
  final FormFieldValidator<String>? validator;
  final String? restorationId;
  final String? initialValue;
  final FocusNode? focusNode;
  InputDecoration? decoration = const InputDecoration();
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

  @override
  State<LiteTextFormField<T>> createState() => _LiteTextFormFieldState<T>();
}

class _LiteTextFormFieldState<T> extends State<LiteTextFormField<T>> {
  bool _hasSetInitialValue = false;

  @override
  Widget build(BuildContext context) {
    final group = LiteFormGroup.of(context);
    final field = liteFormController.registerFormField(
      fieldName: widget.name,
      formName: group!.name,
      serializer: widget.serializer,
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

    return TextFormField(
      restorationId: widget.restorationId,
      scrollController: widget.scrollController,
      validator: widget.validator,
      autocorrect: widget.autocorrect,
      autofillHints: widget.autofillHints,
      autofocus: widget.autofocus,
      autovalidateMode: widget.autovalidateMode,
      buildCounter: widget.buildCounter,
      contextMenuBuilder: widget.contextMenuBuilder,
      controller: textEditingController,
      cursorColor: widget.cursorColor,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorWidth: widget.cursorWidth,
      decoration: widget.decoration,
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
    );
  }
}
