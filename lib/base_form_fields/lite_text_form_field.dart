// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';

import '../lite_forms.dart';

class LiteTextFormField<T> extends StatelessWidget {
  LiteTextFormField({
    super.key,
    required this.name,
    this.serializer = nonConvertingSerializer,
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
  final LiteFormValueSerializer serializer;
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
  Widget build(BuildContext context) {
    final group = LiteFormGroup.of(context);
    final field = liteFormController.registerFormField(
      fieldName: name,
      formName: group!.name,
      serializer: serializer,
    );
    final textEditingController = field.getOrCreateTextEditingController(
      controller: controller,
    );
    return TextFormField(
      restorationId: restorationId,
      scrollController: scrollController,
      validator: validator,
      autocorrect: autocorrect,
      autofillHints: autofillHints,
      autofocus: autofocus,
      autovalidateMode: autovalidateMode,
      buildCounter: buildCounter,
      contextMenuBuilder: contextMenuBuilder,
      controller: textEditingController,
      cursorColor: cursorColor,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorWidth: cursorWidth,
      decoration: decoration,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      enableInteractiveSelection: enableInteractiveSelection,
      enableSuggestions: enableSuggestions,
      enabled: enabled,
      expands: expands,
      focusNode: focusNode,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      keyboardAppearance: keyboardAppearance,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      minLines: minLines,
      mouseCursor: mouseCursor,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      onChanged: (value) {
        liteFormController.onValueChanged(
          formName: group.name,
          fieldName: name,
          value: value,
        );
      },
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      onTapOutside: onTapOutside,
      scrollPadding: scrollPadding,
      readOnly: readOnly,
      scrollPhysics: scrollPhysics,
      selectionControls: selectionControls,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      showCursor: showCursor,
      strutStyle: strutStyle,
      style: style,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textCapitalization: textCapitalization,
      textDirection: textDirection,
      textInputAction: textInputAction,
    );
  }
}
