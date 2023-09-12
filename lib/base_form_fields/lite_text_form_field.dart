// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/utils/string_extensions.dart';
import 'package:lite_forms/utils/value_validator.dart';

import '../lite_forms.dart';
import 'error_line.dart';

enum LiteTextEntryType {
  normal,
  onModalRoute,
}

class TextEntryModalRouteSettings {
  final double backgroundOpacity;
  final TextCapitalization textCapitalization;
  TextEntryModalRouteSettings({
    this.textCapitalization = TextCapitalization.sentences,
    this.backgroundOpacity = 0.95,
  });
}

class LiteTextFormField extends StatefulWidget {
  LiteTextFormField({
    super.key,
    required this.name,
    this.textEntryType = LiteTextEntryType.normal,
    this.useSmoothError = false,
    this.smoothErrorPadding = const EdgeInsets.only(
      top: 6.0,
    ),
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
    this.modalRouteSettings,
  });

  final String name;
  final String? hintText;
  final TextEditingController? controller;

  /// makes sense only if [textEntryType] is [LiteTextEntryType.onModalRoute]
  final TextEntryModalRouteSettings? modalRouteSettings;

  /// makes sense only of [useSmoothError] is true
  final EdgeInsets? smoothErrorPadding;

  /// if you pass [LiteTextEntryType.onModalRoute]
  /// then when you tap a text field a separate full screen
  /// route will be opened to enter a text
  final LiteTextEntryType textEntryType;

  /// if true, this will use a smoothly animated error
  /// that uses AnimateSize to display, unlike the standard
  /// Flutter's input error
  final bool useSmoothError;

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

class _LiteTextFormFieldState extends State<LiteTextFormField> {
  bool _hasSetInitialValue = false;
  late FormGroupField<String> _field;
  late String _formName;

  VoidCallback? _getTapMethod() {
    if (widget.textEntryType == LiteTextEntryType.onModalRoute) {
      return _openTextEntryRoute;
    }
    return null;
  }

  Future _openTextEntryRoute() async {
    if (mounted) {
      final result = await Navigator.of(context).push(
        _TextEntryRoute(
          modalRouteSettings: widget.modalRouteSettings,
          hintText: widget.hintText,
          selection: _field.textEditingController?.selection,
          text: _field.textEditingController?.text ?? '',
        ),
      );
      if (result is String) {
        liteFormController.onValueChanged(
          formName: _formName,
          fieldName: widget.name,
          value: result,
          isInitialValue: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = LiteFormGroup.of(context);
    _formName = group!.name;
    _field = liteFormController.registerFormField(
      fieldName: widget.name,
      formName: _formName,
      serializer: widget.serializer,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
    );
    final textEditingController = _field.getOrCreateTextEditingController(
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
    var decoration = widget.decoration ??
        liteFormController.config?.inputDecoration ??
        const InputDecoration();
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
      child: Column(
        children: [
          TextFormField(
            restorationId: widget.restorationId,
            scrollController: widget.scrollController,
            validator: widget.validator != null
                ? (value) {
                    return _field.error;
                  }
                : null,
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
            decoration: widget.useSmoothError
                ? decoration.copyWith(
                    errorStyle: const TextStyle(
                      fontSize: .01,
                      color: Colors.transparent,
                    ),
                  )
                : decoration,
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
            onTap: _getTapMethod(),
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
          if (widget.useSmoothError)
            LiteFormErrorLine(
              fieldName: widget.name,
              formName: group.name,
              decoration: decoration,
              paddingBottom: widget.smoothErrorPadding?.bottom,
              paddingTop: widget.smoothErrorPadding?.top,
              paddingLeft: widget.smoothErrorPadding?.left,
              paddingRight: widget.smoothErrorPadding?.right,
            ),
        ],
      ),
    );
  }
}

class _TextEntryRoute extends ModalRoute {
  _TextEntryRoute({
    required this.selection,
    required this.text,
    this.modalRouteSettings,
    this.hintText,
  });

  final TextEntryModalRouteSettings? modalRouteSettings;
  final String? hintText;
  final String text;
  final TextSelection? selection;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _TextEntryPage(
      animation: animation,
      modalRouteSettings: modalRouteSettings,
      hintText: hintText,
      selection: selection,
      text: text,
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => kThemeAnimationDuration;
}

class _TextEntryPage extends StatefulWidget {
  const _TextEntryPage({
    required this.animation,
    required this.selection,
    required this.text,
    this.modalRouteSettings,
    this.hintText,
  });

  final TextEntryModalRouteSettings? modalRouteSettings;
  final Animation<double> animation;
  final String? hintText;
  final TextSelection? selection;
  final String text;

  @override
  State<_TextEntryPage> createState() => __TextEntryPageState();
}

class __TextEntryPageState extends State<_TextEntryPage> {
  late TextEditingController _textEditingController;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEntryModalRouteSettings? routeSettings = widget.modalRouteSettings ??
        liteFormController.config?.defaultTextEntryModalRouteSettings;
    _textEditingController = TextEditingController(
      text: widget.text,
    );
    if (widget.selection != null) {
      _textEditingController.selection = widget.selection!;
    }
    final brightness = Theme.of(context).brightness;
    final moveAnimation = Tween<double>(
      begin: 10.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        curve: Curves.easeInOutExpo,
        parent: widget.animation,
      ),
    );
    final opacityAnimation = Tween<double>(
      begin: 0.0,
      end: routeSettings?.backgroundOpacity ?? 1.0,
    ).animate(
      CurvedAnimation(
        curve: Curves.easeInOutExpo,
        parent: widget.animation,
      ),
    );
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, moveAnimation.value),
          child: Opacity(
            opacity: opacityAnimation.value,
            child: Scaffold(
              appBar: CupertinoNavigationBar(
                backgroundColor: Colors.transparent,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    Icons.close,
                    color: CupertinoColors.label,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(Icons.check),
                  onPressed: () {
                    Navigator.of(context).pop(
                      _textEditingController.text,
                    );
                  },
                ),
                brightness: brightness,
                padding: const EdgeInsetsDirectional.all(
                  8.0,
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: TextFormField(
                        textCapitalization:
                            routeSettings?.textCapitalization ?? TextCapitalization.sentences,
                        decoration: InputDecoration.collapsed(
                          hintText: widget.hintText,
                        ),
                        controller: _textEditingController,
                        autofocus: true,
                        maxLines: 1000000,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
