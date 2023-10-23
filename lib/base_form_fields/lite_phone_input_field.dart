import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/mixins/post_frame_mixin.dart';
import 'package:lite_forms/constants.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/lite_forms.dart';
import 'package:lite_state/lite_state.dart';

import 'error_line.dart';
import 'lite_drop_selector/lite_drop_selector_enum.dart';
import 'mixins/form_field_mixin.dart';

enum LitePhoneInputType {
  autodetectCode,
  manualCode,
}

class PhoneData {
  PhoneData({
    required this.countryData,
  });

  CountryData? countryData;

  String get fullPhone {
    if (_isManualCountry) {
      final phone = '+${_phoneCountryData?.phoneCode}$_phoneNumber';
      return formatAsPhoneNumber(phone) ?? '';
    }
    return _phoneNumber;
  }

  /// For some rare cases when you need more data about a phone number
  PhoneCountryData? _phoneCountryData;
  PhoneCountryData? get phoneCountryData => _phoneCountryData;

  bool _isManualCountry = false;
  String _phoneNumber = '';
}

class LitePhoneInputField extends StatefulWidget {
  const LitePhoneInputField({
    super.key,
    required this.name,
    this.initialValueDeserializer,
    this.phoneInputType = LitePhoneInputType.autodetectCode,
    this.initialValue,
    this.decoration,
    this.hintText,
    this.autovalidateMode,
    this.defaultCountry,
    this.focusNode,
    this.errorStyle,
    this.style,
    this.validators,
    this.serializer = nonConvertingValueConvertor,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.textCapitalization = TextCapitalization.none,
    this.strutStyle,
    this.textDirection,
    this.restorationId,
    this.textAlignVertical,
    this.countrySelectorSettings,
    this.menuItemBuilder,
    this.textAlign = TextAlign.start,
    this.smoothErrorPadding = const EdgeInsets.only(
      top: 6.0,
    ),
    this.useSmoothError = true,
    this.allowErrorTexts = true,
    this.allowEndlessPhone = false,
    this.countrySelectorViewType = LiteDropSelectorViewType.adaptive,
  });

  final String name;

  /// [countrySelectorViewType] specifies how the DropSelector sheet for
  /// the country code will look like. Makes sense only if [phoneInputType] is
  /// [LitePhoneInputType.manualCode]
  final LiteDropSelectorViewType countrySelectorViewType;

  /// [allowEndlessPhone] sometimes you might want to allow users to enter
  /// more numbers than a phone mask allows (very rare but potentially possible cases)
  /// this will allow you to do so
  final bool allowEndlessPhone;
  final LitePhoneInputType phoneInputType;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final AutovalidateMode? autovalidateMode;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final Object? initialValue;
  final LiteDropSelectorSettings? countrySelectorSettings;

  /// Pass false here if you don't want to display errors on invalid fields at all
  ///
  /// Notice! In this case the form will silently get
  /// invalid and your users might not
  /// understand what happened. Use it in case you want to implement your own
  /// error processing
  final bool allowErrorTexts;

  /// makes sense only of [useSmoothError] is true
  final EdgeInsets? smoothErrorPadding;

  /// if true, this will use a smoothly animated error
  /// that uses AnimateSize to display, unlike the standard
  /// Flutter's input error
  final bool useSmoothError;

  final String? restorationId;
  final TextCapitalization textCapitalization;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  /// [menuItemBuilder] if you need a custom view for country codes in a drop selector
  /// you can use this builder
  final MenuItemBuilder? menuItemBuilder;

  /// [defaultCountry] if you select [phoneInputType] = [LitePhoneInputType.manualCode]
  /// you can preset a default country for it. This field can accept a [String] or
  /// a [CountryData] object. If you decide to pass a [String] value it can be a ISO
  /// code for a country or a simple name. In case the country you provide is not found
  /// in the available list of countries it will use United States as a fallback option
  ///
  /// The fallback country
  final Object? defaultCountry;

  // Allows you to prepare the data for some general usage like sending it
  /// to an api endpoint. E.g. you have a Date Picker which returns a DateTime object
  /// but you need to send it to a backend in a iso8601 string format.
  /// Just pass the serializer like this: serializer: (value) => value.toIso8601String()
  /// And it will always store this date as a string in a form map which you can easily send
  /// wherever you need
  final LiteFormValueSerializer serializer;
  final String? hintText;
  final FocusNode? focusNode;
  final InputDecoration? decoration;

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
  State<LitePhoneInputField> createState() => _LitePhoneInputFieldState();
}

class _LitePhoneInputFieldState extends State<LitePhoneInputField>
    with FormFieldMixin, PostFrameMixin {
  PhoneData? _initialData;
  double _dropSelectorHeight = 0.0;
  final _globalKey = GlobalKey<State<StatefulWidget>>();
  CountryData? _selectedCountry;

  @override
  void initState() {
    if (_isManualSelector) {
      if (widget.defaultCountry != null) {
        if (widget.defaultCountry is String) {
          _selectedCountry = tryFindCountries(
            widget.defaultCountry as String,
          ).firstOrNull;
        } else if (widget.defaultCountry is CountryData) {
          _selectedCountry = widget.defaultCountry as CountryData;
        }
      }
      _selectedCountry ??= tryFindCountries('US').first;
    }
    super.initState();
  }

  @override
  void didFirstLayoutFinished(BuildContext context) {
    _dropSelectorHeight = _globalKey.currentContext!.size!.height;
    liteFormRebuildController.rebuild();
  }

  String _removeCountryCode(
    String phoneWithCountryCode,
  ) {
    return PhoneCodes.removeCountryCode(
      phoneWithCountryCode,
    );
  }

  PhoneData? _postProcessInitialValue(
    Object? value,
  ) {
    if (_initialData != null) {
      return _initialData!;
    }
    if (value == null) {
      return null;
    }
    if (value is String) {
      if (widget.phoneInputType == LitePhoneInputType.autodetectCode) {
        assert(
          value.startsWith('+'),
          'If you use ${LitePhoneInputType.autodetectCode} initial value must start with a `plus` (+) sign',
        );
        final phoneCountryDatas = getCountryDatasByPhone(value);
        if (phoneCountryDatas.isEmpty) {
          return null;
        }
        final formattedPhone = formatAsPhoneNumber(value);
        if (formattedPhone != null) {
          final phoneCountryData = phoneCountryDatas.first;
          final countryData = findCountryById(
            phoneCountryData.countryCode!,
          );
          _initialData = PhoneData(
            countryData: countryData,
          )
            .._phoneCountryData = phoneCountryData
            .._isManualCountry = false
            .._phoneNumber = formattedPhone;
          return _initialData;
        }
      } else if (widget.phoneInputType == LitePhoneInputType.manualCode) {
        if (_selectedCountry != null) {
          if (value.startsWith('+')) {
            value = _removeCountryCode(value);
          }
          final formattedPhone = formatAsPhoneNumber(
            value,
            defaultCountryCode: _selectedCountry!.isoCode,
          );
          if (formattedPhone != null) {
            final phoneCountryData = PhoneCodes.getPhoneCountryDataByCountryCode(
              _selectedCountry!.isoCode,
            );
            if (phoneCountryData != null) {
              _initialData = PhoneData(
                countryData: _selectedCountry,
              )
                .._phoneNumber = formattedPhone
                .._isManualCountry = true
                .._phoneCountryData = phoneCountryData;
              return _initialData;
            }
          }
        }
      }
    } else if (value is PhoneData) {
      return value;
    }
    return _initialData;
  }

  bool get _useErrorDecoration {
    return !widget.useSmoothError && widget.allowErrorTexts;
  }

  String? get _defaultCountryCode {
    if (_isManualSelector && _selectedCountry != null) {
      return _selectedCountry!.isoCode;
    }
    return null;
  }

  bool get _isManualSelector {
    return widget.phoneInputType == LitePhoneInputType.manualCode;
  }

  Widget _buildCountryDropSelector() {
    if (widget.phoneInputType == LitePhoneInputType.autodetectCode) {
      return const SizedBox.shrink();
    }
    return LiteState<LiteFormRebuildController>(
      builder: (BuildContext c, LiteFormRebuildController controller) {
        if (_dropSelectorHeight == 0.0) {
          return const SizedBox.shrink();
        }
        return LiteCountrySelector(
          menuItemBuilder: widget.menuItemBuilder,
          name: '${widget.name}_country_selector'.toFormIgnoreName(),
          dropSelectorType: widget.countrySelectorViewType,
          initialValue: _selectedCountry,
          settings: widget.countrySelectorSettings ?? const LiteDropSelectorSettings(),
          selectorViewBuilder: (context, selectedItems) {
            return Padding(
              padding: EdgeInsets.only(
                right:
                    (decoration.contentPadding as EdgeInsets?)?.left ?? kDefaultPadding,
              ),
              child: Container(
                width: 80.0,
                height: _dropSelectorHeight,
                color: Colors.red,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeFormField<String>(
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
      rawInitialValue: widget.initialValue,
      initialValueDeserializer: widget.initialValueDeserializer,
    );

    final PhoneData? postProcessedValue = _postProcessInitialValue(
      initialValue,
    );

    setInitialValue(
      fieldName: widget.name,
      formName: group.name,
      setter: () {
        liteFormController.onValueChanged(
          fieldName: widget.name,
          formName: group.name,
          value: postProcessedValue,
          isInitialValue: true,
          view: postProcessedValue?._phoneNumber,
        );
      },
    );
    InputDecoration newDecoration = decoration;
    if (_isManualSelector) {
      newDecoration = decoration.copyWith(
        prefixIcon: _buildCountryDropSelector(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                key: _globalKey,
                child: TextFormField(
                  restorationId: widget.restorationId,
                  validator: widget.validators != null
                      ? (value) {
                          return group.translationBuilder(field.error);
                        }
                      : null,
                  autovalidateMode: null,
                  controller: textEditingController,
                  decoration: _useErrorDecoration
                      ? newDecoration
                      : newDecoration.copyWith(
                          errorStyle: const TextStyle(
                            fontSize: .01,
                            color: Colors.transparent,
                          ),
                        ),
                  strutStyle: widget.strutStyle,
                  inputFormatters: [
                    PhoneInputFormatter(
                      defaultCountryCode: _defaultCountryCode,
                      allowEndlessPhone: widget.allowEndlessPhone,
                    ),
                  ],
                  style: liteFormController.config?.defaultTextStyle ?? widget.style,
                  textAlign: widget.textAlign,
                  textAlignVertical: widget.textAlignVertical,
                  textCapitalization: widget.textCapitalization,
                  textDirection: widget.textDirection,
                ),
              ),
              _buildCountryDropSelector(),
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
    );
  }
}
