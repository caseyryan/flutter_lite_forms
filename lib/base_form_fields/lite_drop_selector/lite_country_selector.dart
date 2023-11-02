import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/widgets/country_flag.dart';
import 'package:lite_forms/base_form_fields/exports.dart';
import 'package:lite_forms/base_form_fields/mixins/search_query_mixin.dart';
import 'package:lite_forms/interfaces/preprocessor.dart';
import 'package:lite_forms/utils/value_serializer.dart';
import 'package:lite_forms/utils/value_validator.dart';

import '../mixins/form_field_mixin.dart';

part '_country_collection.dart';

class LiteCountrySelector extends StatefulWidget {
  LiteCountrySelector({
    Key? key,
    required this.name,
    this.menuItemBuilder,
    this.selectorViewBuilder,
    this.settings = const LiteDropSelectorSettings(),
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
    this.label,
    this.decoration,
    this.locale = 'en',
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
    this.sortBySelection = true,
    this.readOnly = false,
    this.countries,
  }) : super(key: key ?? Key(name));

  final String name;
  final bool readOnly;

  /// [locale] two-letter locale like "ru" or "en"
  final String locale;

  /// [countries] you can pass a list of [CountryData] objects here
  /// or a list of String names. If you pass a list of Strings
  /// it will try to find countries by a provided names
  ///
  /// Notice: in case of Strings it is not guaranteed that all countries
  /// will be present on the list
  final List<Object>? countries;

  /// [selectorViewBuilder] allows you to build a custom view for
  /// this drop selector. You might want to display something else instead
  /// of a view with a hint and/or chips
  final LiteDropSelectorViewBuilder? selectorViewBuilder;

  /// [settings] for a sheet where all menu items are displayed
  final LiteDropSelectorSettings settings;

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
  final bool sortBySelection;

  /// [menuItemBuilder] if you want menu items to have a custom
  /// look and feel, just pass a builder for them
  final MenuItemBuilder? menuItemBuilder;

  final String? hintText;
  final String? label;
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
  final LiteFormValueSerializer? initialValueDeserializer;
  final List<LiteValidator>? validators;

  @override
  State<LiteCountrySelector> createState() => _LiteCountrySelectorState();
}

class CountryPreprocessor implements IPreprocessor {
  @override
  List<LiteDropSelectorItem<CountryData>>? preprocess(Object? value) {
    return _prepareInitialValue(value);
  }

  List<LiteDropSelectorItem<CountryData>>? _prepareInitialValue(
    dynamic initialValue,
  ) {
    if (initialValue == null) {
      return null;
    }
    if (initialValue is List<LiteDropSelectorItem>) {
      return initialValue as dynamic;
    }

    if (initialValue is String) {
      CountryData? initialCountry;
      initialCountry = tryFindCountries(initialValue).firstOrNull;
      if (initialCountry != null) {
        initialValue = [
          LiteDropSelectorItem<CountryData>(
            title: initialCountry.name,
            payload: initialCountry,
          )
        ];
      } else {
        initialValue = null;
      }
    } else if (initialValue is CountryData) {
      initialValue = [
        LiteDropSelectorItem<CountryData>(
          title: initialValue.name,
          payload: initialValue,
        )
      ];
    } else if (initialValue is List) {
      final tempList = <LiteDropSelectorItem<CountryData>>[];
      for (var v in initialValue) {
        final list = _prepareInitialValue(v)?.toList() ?? [];
        tempList.addAll(list);
      }
      return tempList.whereNotNull().toList();
    }

    return initialValue;
  }

  @override
  String? get view => null;
}

class _LiteCountrySelectorState extends State<LiteCountrySelector> with FormFieldMixin {
  Widget _iconBuilder(
    BuildContext context,
    LiteDropSelectorItem item,
    bool isSelected,
  ) {
    final country = item.payload as CountryData;
    return CountryFlag(
      countryId: country.countryId,
    );
  }

  CountryPreprocessor get _preprocessor {
    field.preprocessor ??= CountryPreprocessor();
    return field.preprocessor! as CountryPreprocessor;
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
      label: widget.label,
      decoration: widget.decoration,
      errorStyle: widget.errorStyle,
    );

    List<LiteDropSelectorItem> items = [];
    if (widget.countries?.isNotEmpty == true) {
      final tempDatas = widget.countries!.map((e) {
        return widget.initialValueDeserializer?.call(e) ?? e;
      }).toList();
      for (var data in tempDatas) {
        if (data is String) {
          final country = tryFindCountries(data).firstOrNull;
          if (country != null) {
            items.add(
              LiteDropSelectorItem(
                title: country.name,
                payload: country,
                iconBuilder: _iconBuilder,
              ),
            );
          }
        } else if (data is CountryData) {
          items.add(
            LiteDropSelectorItem(
              title: data.name,
              payload: data,
              iconBuilder: _iconBuilder,
            ),
          );
        } else if (data is LiteDropSelectorItem) {
          data.iconBuilder = _iconBuilder;
          items.add(data);
        }
      }
    } else {
      items = allCountries.map(
        (country) {
          return LiteDropSelectorItem(
            title: country.name,
            payload: country,
            iconBuilder: _iconBuilder,
          );
        },
      ).toList();
    }

    Object? initialValue = _preprocessor.preprocess(
      widget.initialValue,
    );

    return LiteDropSelector(
      key: Key(widget.name),
      name: widget.name,
      items: items,
      readOnly: widget.readOnly,
      textCapitalization: widget.textCapitalization,
      initialValueDeserializer: widget.initialValueDeserializer,
      dropSelectorActionType: widget.dropSelectorActionType,
      selectorViewBuilder: widget.selectorViewBuilder,
      menuItemBuilder: widget.menuItemBuilder,
      settings: widget.settings,
      dropSelectorType: widget.dropSelectorType,
      paddingRight: widget.paddingRight,
      paddingLeft: widget.paddingLeft,
      paddingBottom: widget.paddingBottom,
      autovalidateMode: widget.autovalidateMode,
      pickerBackgroundColor: widget.pickerBackgroundColor,
      onChanged: widget.onChanged,
      validators: widget.validators,
      initialValue: initialValue as dynamic,
      serializer: widget.serializer,
      errorStyle: widget.errorStyle,
      decoration: widget.decoration,
      hintText: widget.hintText,
      paddingTop: widget.paddingTop,
      allowErrorTexts: widget.allowErrorTexts,
      useSmoothError: widget.useSmoothError,
      smoothErrorPadding: widget.smoothErrorPadding,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      restorationId: widget.restorationId,
      textDirection: widget.textDirection,
      strutStyle: widget.strutStyle,
      style: widget.style,
      sortBySelection: widget.sortBySelection,
    );
  }
}
