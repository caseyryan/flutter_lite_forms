import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lite_forms/base_form_fields/error_line.dart';
import 'package:lite_forms/base_form_fields/mixins/form_field_mixin.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/lite_forms.dart';

typedef CustomLiteToggleBuilder = Widget Function(
  BuildContext context,
  bool isSelected,
);

Widget simpleSquareToggleBuilder(
  BuildContext context,
  bool isSelected,
) {
  return Icon(
    isSelected ? Icons.check_box_outlined : Icons.check_box_outline_blank,
    color: Theme.of(context).iconTheme.color,
  );
}

enum SwitchStyle {
  cupertino,
  material,
  adaptive,
}

enum LiteSwitchPosition {
  left,
  right,
}

enum LiteSwitchReactionArea {
  full,
  toggleOnly,
}

class LiteSwitch extends StatefulWidget {
  LiteSwitch({
    Key? key,
    required this.name,
    this.switchPosition = LiteSwitchPosition.left,
    this.reactionArea = LiteSwitchReactionArea.full,
    this.onChanged,
    this.label,
    this.onTapLink,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.serializer = nonConvertingValueConvertor,
    this.initialValueDeserializer,
    this.validators,
    this.initialValue,
    this.autovalidateMode,
    this.type = SwitchStyle.adaptive,
    this.customLiteToggleBuilder,
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
    this.childPadding = const EdgeInsets.only(
      left: 8.0,
      right: 8.0,
      top: 8.0,
      bottom: 8.0,
    ),
    this.child,
    this.text,
    this.useMarkdown = false,
    this.readOnly = false,
    this.useSmoothError = true,
    this.markdownStyleSheet,
    this.style,
    this.onInactiveThumbImageError,
    this.smoothErrorPadding = const EdgeInsets.only(
      top: 8.0,
    ),
    this.errorStyle,
  })  : assert(
          (child == null || text == null),
          'You cannot pass both `text` and `child` at the same time',
        ),
        super(key: key ?? Key(name));

  /// The position of the switch relative to a [child] or a [text]
  final LiteSwitchPosition switchPosition;
  final Widget? child;
  final String? text;
  final TextStyle? errorStyle;

  /// If you need to use markdown in the text description, pass true here.
  final bool useMarkdown;
  final bool readOnly;

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback? onTapLink;

  /// You can use a custom markdown style sheet. It makes sense
  /// only if [useMarkdown] == true
  final MarkdownStyleSheet? markdownStyleSheet;

  /// A style for text. Makes sense only if [text] != null
  final TextStyle? style;
  final ImageErrorListener? onInactiveThumbImageError;
  final String name;
  final String? label;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final ValueChanged<bool>? onChanged;

  /// makes sense only of [useSmoothError] is true
  final EdgeInsets? smoothErrorPadding;

  /// if true, this will use a smoothly animated error
  /// that uses AnimateSize to display, unlike the standard
  /// Flutter's input error
  final bool useSmoothError;

  /// The look and feel of the switch.
  ///
  /// [SwitchStyle.adaptive] by default. It means it will use
  /// cupertino style on iOS and Material on Android
  final SwitchStyle type;

  /// If you don't want the toggle to look like Cupertino or Material
  /// you may provide you own toggle builder here
  final CustomLiteToggleBuilder? customLiteToggleBuilder;

  /// Determines the tap area which will activate / deactivate the switch
  /// [LiteSwitchReactionArea.full] by default. It means you can tap even on a
  /// text to control the switch. [LiteSwitchReactionArea.toggleOnly] means that
  /// only the toggle itself will be reactive
  final LiteSwitchReactionArea reactionArea;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? activeThumbImage;
  final ImageErrorListener? onActiveThumbImageError;
  final WidgetStateProperty<Color?>? thumbColor;
  final WidgetStateProperty<Color?>? trackColor;
  final WidgetStateProperty<Icon?>? thumbIcon;
  final MaterialTapTargetSize? materialTapTargetSize;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final EdgeInsets childPadding;

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
  final LiteFormValueDeserializer? initialValueDeserializer;
  final List<LiteValidator>? validators;

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

class _LiteSwitchState extends State<LiteSwitch> with FormFieldMixin {
  FutureOr<bool?> _tryGetValue({
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
    if (widget.customLiteToggleBuilder != null) {
      return GestureDetector(
        onTap: () {
          _onChanged(!value);
        },
        child: Container(
          color: Colors.transparent,
          child: IgnorePointer(
            child: widget.customLiteToggleBuilder!(
              context,
              value,
            ),
          ),
        ),
      );
    }

    bool isMaterial = false;
    if (widget.type == SwitchStyle.material) {
      isMaterial = true;
    } else if (widget.type == SwitchStyle.adaptive) {
      if (!ExtendedPlatform.isIOS) {
        isMaterial = true;
      }
    }

    if (isMaterial) {
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
          _onChanged(value);
        },
      );
    }
    return CupertinoSwitch(
      value: value,
      dragStartBehavior: widget.dragStartBehavior,
      activeColor: widget.activeColor ?? Theme.of(context).primaryColor,
      thumbColor: value ? widget.activeColor : widget.inactiveThumbColor,
      trackColor: value ? widget.activeTrackColor : widget.inactiveTrackColor,
      onChanged: (value) {
        _onChanged(value);
      },
    );
  }

  void _onChanged(
    bool value,
  ) {
    if (widget.readOnly) {
      return;
    }
    liteFormController.onValueChanged(
      formName: group.name,
      fieldName: widget.name,
      value: value,
      view: null,
    );
    widget.onChanged?.call(value);
    liteFormRebuildController.rebuild();
    liteFormController.rebuild();
  }

  TextStyle? get _textStyle {
    return widget.style ?? liteFormController.config?.defaultTextStyle ?? Theme.of(context).textTheme.bodyMedium;
  }

  Widget _buildChild() {
    Widget child = const SizedBox.shrink();
    String? text = widget.text ?? widget.label;
    if (text != null) {
      if (widget.useMarkdown) {
        child = MarkdownBody(
          selectable: false,
          onTapLink: widget.onTapLink ??
              (text, href, title) {
                if (kDebugMode) {
                  print('Link tap: $href. Provide [widget.onTapLink] callback to process it');
                }
              },
          styleSheet: widget.markdownStyleSheet ??
              MarkdownStyleSheet.fromTheme(
                Theme.of(context),
              ).copyWith(
                p: _textStyle,
              ),
          softLineBreak: true,
          data: text,
          shrinkWrap: true,
          fitContent: true,
        );
      } else {
        child = Text(
          text,
          style: _textStyle,
        );
      }
    } else {
      child = widget.child!;
    }
    child = Container(
      color: Colors.transparent,
      child: Padding(
        padding: widget.childPadding,
        child: child,
      ),
    );
    if (widget.reactionArea == LiteSwitchReactionArea.full) {
      child = GestureDetector(
        onTap: () async {
          bool value = await _tryGetValue(
                fieldName: widget.name,
                formName: group.name,
              ) ==
              true;
          _onChanged(!value);
        },
        child: child,
      );
    }
    return Expanded(child: child);
  }

  @override
  Widget build(BuildContext context) {
    initializeFormField<bool>(
      fieldName: widget.name,
      autovalidateMode: widget.autovalidateMode,
      serializer: widget.serializer,
      initialValueDeserializer: widget.initialValueDeserializer,
      validators: widget.validators,
      label: widget.label,
      hintText: null,
      decoration: null,
      errorStyle: widget.errorStyle,
      focusNode: widget.focusNode,
      viewConverter: null,
      isReadOnly: widget.readOnly,
    );
    tryDeserializeInitialValueIfNecessary<bool>(
      initialValueDeserializer: widget.initialValueDeserializer,
      rawInitialValue: widget.initialValue,
    );

    setInitialValue(
      formName: widget.name,
      fieldName: group.name,
      setter: () async {
        bool? value = await _tryGetValue(
              fieldName: widget.name,
              formName: group.name,
            ) ==
            true;
        liteFormController.onValueChanged(
          fieldName: widget.name,
          formName: group.name,
          value: value,
          isInitialValue: true,
          view: null,
        );
      },
    );

    return Focus(
      canRequestFocus: true,
      focusNode: field.getOrCreateFocusNode(),
      child: Padding(
        padding: EdgeInsets.only(
          left: widget.paddingLeft,
          right: widget.paddingRight,
          top: widget.paddingTop,
          bottom: widget.paddingBottom,
        ),
        child: AnimatedOpacity(
          opacity: widget.readOnly ? 0.3 : 1,
          duration: kThemeAnimationDuration,
          child: LiteState<LiteFormRebuildController>(
            builder: (BuildContext c, LiteFormRebuildController controller) {
              final hasChild = widget.child != null || widget.text != null || widget.label != null;
              List<Widget>? children;
          
              if (hasChild) {
                if (widget.switchPosition == LiteSwitchPosition.right) {
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
          
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (widget.label != null)
                  //   Label(text: widget.label!, paddingBottom: 0.0,),
                  Row(
                    children: children,
                  ),
                  if (widget.useSmoothError)
                    LiteFormErrorLine(
                      fieldName: widget.name,
                      formName: group.name,
                      errorStyle: errorStyle,
                      paddingBottom: widget.smoothErrorPadding?.bottom,
                      paddingTop: widget.smoothErrorPadding?.top,
                      paddingLeft: widget.smoothErrorPadding?.left,
                      paddingRight: widget.smoothErrorPadding?.right,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
