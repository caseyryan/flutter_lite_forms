import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/error_line.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/lite_drop_selector_button.dart';
import 'package:lite_forms/base_form_fields/lite_form.dart';
import 'package:lite_forms/base_form_fields/lite_search_field.dart';
import 'package:lite_forms/base_form_fields/mixins/form_field_mixin.dart';
import 'package:lite_forms/base_form_fields/mixins/post_frame_mixin.dart';
import 'package:lite_forms/base_form_fields/mixins/search_query_mixin.dart';
import 'package:lite_forms/constants.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/utils/exports.dart';
import 'package:lite_forms/utils/size_detector.dart';
import 'package:lite_forms/utils/swipe_detector.dart';
import 'package:lite_state/lite_state.dart';

import 'lite_drop_selector_multi_sheet.dart';

part '_lite_drop_selector_item.dart';
part 'drop_selector_view.dart';
part 'lite_drop_selector_enum.dart';
part 'lite_drop_selector_route.dart';

typedef DropSelectorItemBuilder = Widget Function(
  LiteDropSelectorItem item,
);

/// [selectedItems] a list of items that are currently selected
/// [error] a text of an error from validator or `null`
typedef LiteDropSelectorViewBuilder = Widget Function(
  BuildContext context,
  List<LiteDropSelectorItem> selectedItems,
  String? error,
);

class LiteDropSelector extends StatefulWidget {
  LiteDropSelector({
    Key? key,
    required this.name,
    required this.items,
    this.menuItemBuilder,
    this.selectorViewBuilder,
    this.settings,
    this.initialValueDeserializer,
    this.validators,
    this.serializer = nonConvertingValueConvertor,
    this.errorStyle,
    this.onChanged,
    this.initialValue,
    this.pickerBackgroundColor,
    this.autovalidateMode,
    this.hintText,
    this.label,
    this.decoration,
    this.width,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.multiselectorSpacing = 8.0,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.restorationId,
    this.textAlignVertical,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.smoothErrorPadding = const EdgeInsets.only(
      top: 6.0,
    ),
    this.useSmoothError = true,
    this.allowErrorTexts = true,
    this.sortBySelection = false,
    this.readOnly = false,
  }) : super(key: key ?? Key(name)) {
    assert(
      items.isNotEmpty &&
          (items.every((e) => e is String) ||
              items.every(
                (e) => e is LiteDropSelectorItem,
              )),
    );
  }

  final String name;
  final FocusNode? focusNode;
  final bool sortBySelection;
  final bool readOnly;
  final double? width;

  /// [selectorViewBuilder] allows you to build a custom view for
  /// this drop selector. You might want to display something else instead
  /// of a view with a hint and/or chips
  final LiteDropSelectorViewBuilder? selectorViewBuilder;

  /// [settings] for a sheet where all menu items are displayed
  final DropSelectorSettings? settings;

  /// It is assumed that the initial value is DateTime? but you might
  /// also pass something else, for example a iso8601 String, and the
  /// form field must be ok with it as long as you also pass an [initialValueDeserializer]
  /// which will convert initial value into a DateTime object or else you will get an
  /// exception
  final Object? initialValue;
  final Color? pickerBackgroundColor;
  final AutovalidateMode? autovalidateMode;

  /// [menuItemBuilder] if you want menu items to have a custom
  /// look and feel, just pass a builder for them
  final MenuItemBuilder? menuItemBuilder;

  /// [items] It can be a list of Strings or a list of [LiteDropSelectorItem]'s
  final List<Object?> items;
  final String? hintText;
  final String? label;
  final InputDecoration? decoration;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  /// [multiselectPaddingTop] specifies the distance between the form field and
  /// a multiselect chip container
  final double multiselectorSpacing;

  final String? restorationId;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final ValueChanged<Object?>? onChanged;

  /// makes sense only of [useSmoothError] is true
  final EdgeInsets? smoothErrorPadding;

  /// if true, this will use a smoothly animated error
  /// that uses AnimateSize to display, unlike the standard
  /// Flutter's input error
  final bool useSmoothError;

  /// Pass false here if you don't want to display errors on invalid fields at all
  ///
  /// Notice! In this case the form will silently get
  /// invalid and your users might not
  /// understand what happened. Use it in case you want to implement your own
  /// error processing
  final bool allowErrorTexts;

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

  @override
  State<LiteDropSelector> createState() => _LiteDropSelectorState();
}

class _LiteDropSelectorState extends State<LiteDropSelector> with FormFieldMixin {
  final _globalKey = GlobalKey<State<StatefulWidget>>();

  bool get _useErrorDecoration {
    return !widget.useSmoothError && widget.allowErrorTexts;
  }

  late List<LiteDropSelectorItem> _items;

  bool get _isStringItems {
    return widget.items.first is String;
  }

  List<LiteDropSelectorItem> get _selectedOptions {
    final value = form(formName).field(widget.name).get();
    return value ?? <LiteDropSelectorItem>[];
  }

  void _updateList(dynamic list) {
    if (list != null && list is List) {
      for (var item in _items) {
        item.isSelected = list.contains(item);
      }
      liteFormController.onValueChanged(
        formName: group.name,
        fieldName: widget.name,
        value: list,
        view: _getLabelView(list as dynamic),
      );
      if (_settings.dropSelectorActionType == DropSelectorActionType.singleSelect ||
          _settings.dropSelectorActionType == DropSelectorActionType.simple ||
          _settings.dropSelectorActionType == DropSelectorActionType.simpleWithNoSelection) {
        if (list.isNotEmpty) {
          if (list.first is LiteDropSelectorItem) {
            widget.onChanged?.call(list.first);
          }
        }
      } else {
        widget.onChanged?.call(list);
      }
      textEditingController?.text = _getLabelView(list as dynamic) ?? '';
      liteFormRebuildController.rebuild();
    }
  }

  @override
  Future onFocusChange() async {
    // print('DROP SELECTOR FOCUS CHANGE');
    if (field.hasFocus) {
      await _onTap();
    }
  }

  DropSelectorSettings get _settings {
    final defaultSettings = liteFormController.config?.dropSelectorSettings ??
        const DropSelectorSettings(
          dropSelectorActionType: null,
          dropSelectorType: null,
        );
    if (widget.settings != null) {
      return defaultSettings.copyWith(
        bottomLeftRadius: widget.settings!.bottomLeftRadius,
        chipContentPadding: widget.settings!.chipContentPadding,
        topLeftRadius: widget.settings!.topLeftRadius,
        buttonHeight: widget.settings!.buttonHeight,
        dropSelectorType: widget.settings!.dropSelectorType,
        bottomRightRadius: widget.settings!.bottomRightRadius,
        dropSelectorActionType: widget.settings!.dropSelectorActionType,
        maxVeilOpacity: widget.settings!.maxVeilOpacity,
        menuSearchConfiguration: widget.settings!.searchSettings,
        sheetPadding: widget.settings!.sheetPadding,
        topRightRadius: widget.settings!.topLeftRadius,
        veilColor: widget.settings!.veilColor,
        withScrollBar: widget.settings!.withScrollBar,
      );
    }
    return defaultSettings;
  }

  Future _onTap() async {
    if (widget.readOnly) {
      return;
    }
    final renderBox = _globalKey.currentContext?.findRenderObject();
    if (renderBox is RenderBox) {
      var size = renderBox.size;
      if (_settings.buttonHeight != null) {
        size = Size(
          size.width,
          _settings.buttonHeight!,
        );
      }
      final buttonLeftTopCorner = renderBox.localToGlobal(Offset.zero);

      final list = await showDropSelector(
        buttonDatas: _items,
        style: widget.style,
        group: group,
        decoration: decoration,
        tapPosition: buttonLeftTopCorner,
        context: context,
        buttonSize: size,
        settings: _settings,
        menuItemBuilder: widget.menuItemBuilder,
      );
      _updateList(list);
      _trySortItems();
    }
  }

  String? _getLabelView(
    List<LiteDropSelectorItem> value,
  ) {
    String? labelView;
    if (value.length == 1) {
      labelView = value.first.title;
    } else if (value.length > 1) {
      return group.translationBuilder('Multiple items selected');
    }
    return labelView;
  }

  void _trySortItems() {
    if (widget.sortBySelection) {
      final List<LiteDropSelectorItem> temp = [];
      for (var item in _items) {
        if (item.isSelected) {
          temp.add(item);
        }
      }
      for (var item in temp) {
        _items.remove(item);
      }
      _items.insertAll(0, temp);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isStringItems) {
      /// Items is the full list
      _items = widget.items
          .map((e) => LiteDropSelectorItem(
                title: e as String,
                payload: e,
              ))
          .toList();
    } else {
      _items = widget.items.cast<LiteDropSelectorItem>().toList();
    }
    dynamic preparedInitialValue = widget.initialValue;
    if (preparedInitialValue != null) {
      if (preparedInitialValue is String) {
        final contained = _items.firstWhereOrNull(
          (e) => e.payload == preparedInitialValue || e.title == preparedInitialValue,
        );
        if (contained != null) {
          preparedInitialValue = [contained];
        } else {
          preparedInitialValue = [
            LiteDropSelectorItem(
              title: preparedInitialValue,
              payload: preparedInitialValue,
            ),
          ];
        }
      } else if (preparedInitialValue is List) {
        preparedInitialValue = preparedInitialValue
            .map((e) {
              final byPayload =
                  widget.items.firstWhereOrNull((i) => i is LiteDropSelectorItem && i.payload == e.payload);
              if (byPayload != null) {
                return byPayload;
              }

              if (e is LiteDropSelectorItem) {
                return e;
              } else if (e is String) {
                return LiteDropSelectorItem(
                  title: e,
                  payload: e,
                );
              }
              return null;
            })
            .whereNotNull()
            .cast<LiteDropSelectorItem>()
            .toList();
      } else {
        final byPayload = widget.items.firstWhereOrNull(
          (dynamic i) {
            if (preparedInitialValue is LiteDropSelectorItem) {
              return preparedInitialValue.payload == i.payload;
            } else {
              return i is LiteDropSelectorItem && i.payload == preparedInitialValue;
            }
          },
        );
        if (byPayload != null) {
          preparedInitialValue = <LiteDropSelectorItem>[
            byPayload as LiteDropSelectorItem,
          ];
        }
      }
    }

    initializeFormField(
      fieldName: widget.name,
      autovalidateMode: widget.autovalidateMode,
      serializer: widget.serializer,
      initialValueDeserializer: widget.initialValueDeserializer,
      validators: widget.validators,
      hintText: widget.hintText,
      label: widget.label,
      decoration: widget.decoration,
      errorStyle: widget.errorStyle,
      focusNode: widget.focusNode,
    );

    tryDeserializeInitialValueIfNecessary(
      rawInitialValue: preparedInitialValue,
      initialValueDeserializer: widget.initialValueDeserializer,
    );

    /// The `isSelected` flag is important here because
    /// the field allows for a multi selection
    /// and all selected fields must be highlighted
    if (initialValue != null && initialValue is List) {
      /// It might be that the provided list does not contain
      /// the initial value. Here we need to drop it if that's the case
      for (var value in [...initialValue]) {
        if (!_items.contains(value)) {
          initialValue.remove(value);
        }
      }
      for (var item in _items) {
        item.isSelected = (initialValue as List).contains(item);
      }
      _trySortItems();
    }

    setInitialValue(
      fieldName: widget.name,
      formName: group.name,
      setter: () {
        if (initialValue is List) {
          liteFormController.onValueChanged(
            formName: formName,
            fieldName: widget.name,
            value: initialValue,
            isInitialValue: true,
            view: _getLabelView(initialValue),
          );
        }
      },
    );
    WidgetsBinding.instance.ensureVisualUpdate();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (initialValue is List) {
        textEditingController?.text = _getLabelView(_selectedOptions) ?? '';
      }
    });

    final node = field.getOrCreateFocusNode(
      focusNode: widget.focusNode,
    );

    if (widget.selectorViewBuilder != null) {
      final errorText = group.translationBuilder(field.error);
      return Focus(
        focusNode: node,
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.paddingTop,
            bottom: widget.paddingBottom,
            left: widget.paddingLeft,
            right: widget.paddingRight,
          ),
          child: GestureDetector(
            onTap: _onTap,
            onLongPress: _onTap,
            child: Container(
              color: Colors.transparent,
              key: _globalKey,
              child: IgnorePointer(
                child: widget.selectorViewBuilder!(
                  context,
                  _selectedOptions,
                  errorText,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Focus(
      focusNode: node,
      child: Container(
        width: widget.width,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.paddingTop,
            bottom: widget.paddingBottom,
            left: widget.paddingLeft,
            right: widget.paddingRight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _onTap,
                    onLongPress: _onTap,
                    child: Container(
                      color: Colors.transparent,
                      child: IgnorePointer(
                        child: TextFormField(
                          key: _globalKey,
                          restorationId: widget.restorationId,
                          validator: widget.validators != null
                              ? (value) {
                                  return group.translationBuilder(field.error);
                                }
                              : null,
                          autovalidateMode: null,
                          controller: textEditingController,
                          decoration: _useErrorDecoration
                              ? decoration
                              : decoration.copyWith(
                                  errorStyle: const TextStyle(
                                    fontSize: .01,
                                    color: Colors.transparent,
                                  ),
                                ),
                          strutStyle: widget.strutStyle,
                          style: liteFormController.config?.defaultTextStyle ?? widget.style,
                          textAlign: widget.textAlign,
                          textAlignVertical: widget.textAlignVertical,
                          textCapitalization: widget.textCapitalization,
                          textDirection: widget.textDirection,
                        ),
                      ),
                    ),
                  ),
                  LiteState<LiteFormRebuildController>(
                    builder: (BuildContext c, LiteFormRebuildController controller) {
                      return LiteDropSelectorMultipleSheet(
                        items: _selectedOptions,
                        paddingTop: widget.multiselectorSpacing,
                        settings: widget.settings,
                        onRemove: (LiteDropSelectorItem item) {
                          if (widget.readOnly) {
                            return;
                          }
                          item.isSelected = false;
                          _selectedOptions.remove(item);
                          _updateList(_selectedOptions);
                        },
                      );
                    },
                  ),
                ],
              ),
              if (widget.useSmoothError)
                LiteFormErrorLine(
                  fieldName: widget.name,
                  formName: group.name,
                  errorStyle: decoration.errorStyle,
                  paddingBottom: widget.smoothErrorPadding?.bottom,
                  paddingTop: widget.smoothErrorPadding?.top,
                  paddingLeft: widget.smoothErrorPadding?.left,
                  paddingRight: widget.smoothErrorPadding?.right,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
