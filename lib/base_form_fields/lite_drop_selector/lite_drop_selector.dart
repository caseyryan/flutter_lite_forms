import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lite_forms/base_form_fields/error_line.dart';
import 'package:lite_forms/base_form_fields/lite_search_field.dart';
import 'package:lite_forms/base_form_fields/mixins/form_field_mixin.dart';
import 'package:lite_forms/base_form_fields/mixins/post_frame_mixin.dart';
import 'package:lite_forms/base_form_fields/mixins/search_query_mixin.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/utils/value_serializer.dart';
import 'package:lite_forms/utils/value_validator.dart';
import 'package:lite_state/lite_state.dart';

import 'Lite_drop_selector_multiple_sheet.dart';
import 'lite_drop_selector_button.dart';

part 'lite_drop_selector_route.dart';

enum LiteDropSelectorViewType {
  /// [bottomsheet] means the the selector will appear from the
  /// bottom of the screen
  bottomsheet,

  /// [menu] the selector will appear right from the tap area
  menu,

  /// [adaptive] means it will become a floating menu on wide screens
  /// and [bottomsheet] on narrow ones
  adaptive,
}

enum LiteDropSelectorActionType {
  singleSelect,
  multiselect,
  simple,
}

class LiteDropSelectorItem<T> with SearchQueryMixin {
  final String title;
  final T payload;

  LiteDropSelectorItem({
    required this.title,
    required this.payload,
    this.onPressed,
    this.type,
    bool isSelected = false,
    this.isSeparator = false,
    this.isSingleAction = false,
  }) : _isSelected = isSelected {
    final list = [title];
    if (payload is String) {
      list.add(payload as String);
    }
    prepareSearch(list);
  }

  bool _isSelected;

  // ignore: unnecessary_getters_setters
  bool get isSelected {
    return _isSelected;
  }

  set isSelected(bool value) {
    _isSelected = value;
  }

  Color? normalIconColor;
  Color? selectedIconColor;

  ValueChanged<List<LiteDropSelectorItem>>? onPressed;

  /// [type] the type of each button can be set independently of
  /// the whole menu
  LiteDropSelectorViewType? type;
  ValueChanged<List<LiteDropSelectorItem>>? onMultiSelection;
  String? svgPath;
  IconData? iconData;

  /// [isSeparator] means the button won't have a view.
  /// Instead, a white space
  /// will be added
  bool isSeparator;
  double? iconSize;
  bool isSingleAction;

  double? _menuWidth;
  double? get menuWidth => _menuWidth;

  @override
  bool operator ==(covariant LiteDropSelectorItem other) {
    return other.title == title;
  }

  @override
  int get hashCode {
    return title.hashCode;
  }
}

typedef DropSelectorItemBuilder = Widget Function(LiteDropSelectorItem item);

class LiteDropSelector extends StatefulWidget {
  LiteDropSelector({
    required this.name,
    required this.items,
    super.key,
    this.menuItemBuilder,
    this.settings = const LiteDropSelectorSheetSettings(),
    this.itemBuilder,
    this.dropSelectorType = LiteDropSelectorViewType.adaptive,
    this.dropSelectorActionType = LiteDropSelectorActionType.simple,
    this.initialValueDeserializer,
    this.validators,
    this.serializer = nonConvertingValueConvertor,
    this.errorStyle,
    this.onChanged,
    this.initialValue,
    this.pickerBackgroundColor,
    this.autovalidateMode,
    this.hintText,
    this.decoration,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.restorationId,
    this.textAlignVertical,
    this.textAlign = TextAlign.start,
    this.smoothErrorPadding = const EdgeInsets.only(
      top: 6.0,
    ),
    this.useSmoothError = true,
    this.allowErrorTexts = true,
  }) {
    assert(items.isNotEmpty &&
        (items.every((e) => e is String) ||
            items.every((e) => e is LiteDropSelectorItem)));
  }

  final String name;

  /// [settings] for a sheet where all menu items are displayed
  final LiteDropSelectorSheetSettings settings;

  final LiteDropSelectorActionType dropSelectorActionType;

  /// It is assumed that the initial value is DateTime? but you might
  /// also pass something else, for example a iso8601 String, and the
  /// form field must be ok with it as long as you also pass an [initialValueDeserializer]
  /// which will convert initial value into a DateTime object or else you will get an
  /// exception
  final Object? initialValue;
  final Color? pickerBackgroundColor;
  final AutovalidateMode? autovalidateMode;
  final LiteDropSelectorViewType dropSelectorType;

  /// [menuItemBuilder] if you want menu items to have a custom
  /// look and feel, just pass a builder for them
  final MenuItemBuilder? menuItemBuilder;

  /// [itemBuilder] pass a builder function here if you want
  /// to build custom views for your list items
  final DropSelectorItemBuilder? itemBuilder;

  /// [items] It can be a list of Strings or a list of [LiteDropSelectorItem]'s
  final List<Object?> items;
  final String? hintText;
  final InputDecoration? decoration;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final String? restorationId;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final ValueChanged<DateTime?>? onChanged;

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
  final LiteFormValueConvertor serializer;

  /// Allows you to convert initial value to a proper data type or
  /// format before using it. E.g. you have a iso8601 format but you need
  /// to have a DateTime object to work with in a date picker.
  /// Use [initialValueDeserializer] to convert iso8601 value to a DateTime
  /// like so: initialValueDeserializer: (value) => DateTime.parse(value);
  /// and you will get a DateTime as an initial value. You can use any custom
  /// conversions you want
  final LiteFormValueConvertor? initialValueDeserializer;
  final List<LiteFormFieldValidator<Object?>>? validators;

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
    final value = getFormFieldValue<List<LiteDropSelectorItem>>(
      formName: formName,
      fieldName: widget.name,
    );
    return value ?? <LiteDropSelectorItem>[];
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

  @override
  Widget build(BuildContext context) {
    dynamic preparedInitialValue = widget.initialValue;
    if (preparedInitialValue != null) {
      if (preparedInitialValue is String) {
        preparedInitialValue = [
          LiteDropSelectorItem(
            title: preparedInitialValue,
            payload: preparedInitialValue,
          ),
        ];
      } else if (preparedInitialValue is List) {
        preparedInitialValue = preparedInitialValue
            .map((e) {
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
      }
    }
    if (_isStringItems) {
      /// Items is the full list
      _items = widget.items
          .map((e) => LiteDropSelectorItem(
                title: e as String,
                payload: e,
              ))
          .toList();
    } else {
      _items = widget.items as List<LiteDropSelectorItem>;
    }

    initializeFormField(
      fieldName: widget.name,
      autovalidateMode: widget.autovalidateMode,
      serializer: widget.serializer,
      initialValueDeserializer: widget.initialValueDeserializer,
      validators: widget.validators,
      hintText: widget.hintText,
      decoration: widget.decoration,
      errorStyle: widget.errorStyle,
    );

    tryDeserializeInitialValueIfNecessary(
      rawInitialValue: preparedInitialValue,
      initialValueDeserializer: widget.initialValueDeserializer,
    );

    for (var item in _items) {
      item.isSelected = (initialValue as List).contains(item);
    }

    /// The `isSelected` flag is important here because
    /// the field allows for a multi selection
    /// and all selected fields must be highlighted
    // final List<LiteDropSelectorItem> initialItems = getFormFieldValue(
    //       formName: formName,
    //       fieldName: widget.name,
    //     ) ??
    //     preparedInitialValue;
    // for (var item in _items) {
    //   item.isSelected = initialItems.contains(item);
    // }

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

    return Listener(
      onPointerDown: (details) async {
        final renderBox = _globalKey.currentContext?.findRenderObject();
        if (renderBox is RenderBox) {
          var size = renderBox.size;
          if (widget.settings.buttonHeight != null) {
            size = Size(
              size.width,
              widget.settings.buttonHeight!,
            );
          }
          final buttonLeftTopCorner = renderBox.localToGlobal(Offset.zero);
          final list = await showDropSelector(
            buttonDatas: _items,
            style: widget.style,
            parentFieldName: widget.name,
            parentFormName: group.name,
            decoration: decoration,
            tapPosition: buttonLeftTopCorner,
            context: context,
            dropSelectorType: widget.dropSelectorType,
            dropSelectorActionType: widget.dropSelectorActionType,
            buttonSize: size,
            settings: widget.settings,
            menuItemBuilder: widget.menuItemBuilder,
          );
          if (list != null && list is List) {
            for (var item in _items) {
              item.isSelected = list.contains(item);
            }
          }
          liteFormController.onValueChanged(
            formName: group.name,
            fieldName: widget.name,
            value: list,
            view: _getLabelView(list),
          );
          widget.onChanged?.call(list);
          textEditingController?.text = _getLabelView(list) ?? '';
          liteFormRebuildController.rebuild();
        }
      },
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
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
                TextFormField(
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
                // if (_selectedOptions.length > 1)
                LiteState<LiteFormRebuildController>(
                  builder: (BuildContext c, LiteFormRebuildController controller) {
                    return LiteDropSelectorMultipleSheet(
                      items: _selectedOptions,
                    );
                  },
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
      ),
    );
  }
}
