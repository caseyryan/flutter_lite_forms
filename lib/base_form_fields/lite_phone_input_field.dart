import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/country_flag.dart';
import 'package:lite_forms/base_form_fields/mixins/post_frame_mixin.dart';
import 'package:lite_forms/constants.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/interfaces/preprocessor.dart';
import 'package:lite_forms/lite_forms.dart';

import 'error_line.dart';
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

  String get fullUnformattedPhone {
    final value = toNumericString(
      fullPhone,
      allowAllZeroes: true,
      allowHyphen: true,
    );
    return '+$value';
  }

  @override
  String toString() {
    return 'PhoneData(`$fullPhone`)';
  }

  /// Almost the same as [fullPhone] but this one
  /// will not return a country code if [_isManualCountry] == true
  String get formattedPhone {
    String? value;
    if (_isManualCountry) {
      value = formatAsPhoneNumber(
        defaultCountryCode: _phoneCountryData?.countryCode,
        _phoneNumber,
        invalidPhoneAction: InvalidPhoneAction.DoNothing,
      );
    } else {
      value = formatAsPhoneNumber(_phoneNumber);
    }
    _phoneNumber = value ?? _phoneNumber;
    return value ?? '';
  }

  bool get isValid {
    return isPhoneValid(fullPhone);
  }

  /// For some rare cases when you need more data about a phone number
  PhoneCountryData? _phoneCountryData;
  PhoneCountryData? get phoneCountryData => _phoneCountryData;

  bool _isManualCountry = false;
  String _phoneNumber = '';
}

class LitePhoneInputField extends StatefulWidget {
  LitePhoneInputField({
    Key? key,
    required this.name,
    this.initialValueDeserializer,
    this.phoneInputType = LitePhoneInputType.autodetectCode,
    this.initialValue,
    this.phoneCountries,
    this.decoration,
    this.readOnly = false,
    this.hintText,
    this.label,
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
    this.autofocus = false,
    this.textDirection,
    this.restorationId,
    this.locale = 'en',
    this.textAlignVertical,
    this.onChanged,
    this.countrySelectorSettings,
    this.menuItemBuilder,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.start,
    this.smoothErrorPadding = const EdgeInsets.only(
      top: 6.0,
    ),
    this.leadingWidth = 100.0,
    this.useSmoothError = true,
    this.allowErrorTexts = true,
    this.allowEndlessPhone = false,
    this.countrySelectorViewType = DropSelectorType.menu,
  }) : super(key: key ?? Key(name));

  final String name;
  final bool autofocus;
  final ValueChanged<Object?>? onChanged;

  /// [phoneCountries] you can pass a list of [CountryData] objects here
  /// or a list of String names. If you pass a list of Strings
  /// it will try to find countries by a provided names
  ///
  /// Notice: in case of Strings it is not guaranteed that all countries
  /// will be present on the list
  final List<Object>? phoneCountries;

  /// [locale] two-letter locale like "ru" or "en"
  final String locale;

  /// [countrySelectorViewType] specifies how the DropSelector sheet for
  /// the country code will look like. Makes sense only if [phoneInputType] is
  /// [LitePhoneInputType.manualCode]
  final DropSelectorType countrySelectorViewType;

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
  final ValueChanged<String>? onFieldSubmitted;

  /// [leadingWidth] the width of the drop selector for a country code
  /// it makes sense only if [phoneInputType] == [LitePhoneInputType.manualCode]
  final double leadingWidth;
  final DropSelectorSettings? countrySelectorSettings;

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
  final bool readOnly;

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
  final String? label;
  final FocusNode? focusNode;
  final InputDecoration? decoration;

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
  State<LitePhoneInputField> createState() => _LitePhoneInputFieldState();
}

class PhonePreprocessor implements IPreprocessor {
  PhonePreprocessor({
    required this.phoneInputType,
    required this.formName,
    required this.fieldName,
    required this.isManualSelector,
  });

  final LitePhoneInputType phoneInputType;
  final String formName;
  final String fieldName;
  final bool isManualSelector;

  CountryData? selectedCountry;
  PhoneData? phoneData;
  TextEditingController? textEditingController;
  FocusNode? focusNode;

  String _removeCountryCode(
    String phoneWithCountryCode,
  ) {
    return PhoneCodes.removeCountryCode(
      phoneWithCountryCode,
    );
  }

  void updateCountryData(CountryData? value) {
    if (value != null) {
      selectedCountry = value;
      _selectedPhone.countryData = value;
    }
  }

  PhoneData get _selectedPhone {
    PhoneData? phoneData = getFieldValue(
      formName: formName,
      fieldName: fieldName,
    );
    if (phoneData == null) {
      phoneData = PhoneData(
        countryData: null,
      )
        .._isManualCountry = isManualSelector
        .._phoneCountryData = _phoneCountryData
        .._phoneNumber = textEditingController!.text;
      textEditingController!.setSelectionToEnd(
        focusNode,
      );
      liteFormController.onValueChanged(
        isInitialValue: true,
        formName: formName,
        fieldName: fieldName,
        value: phoneData,
        view: phoneData.formattedPhone,
      );
    }
    return phoneData;
  }

  PhoneCountryData? get _phoneCountryData {
    if (selectedCountry != null) {
      return PhoneCodes.getPhoneCountryDataByCountryCode(
        selectedCountry!.isoCode,
      );
    }
    return null;
  }

  @override
  Object? preprocess(Object? value) {
    phoneData = _preprocess(value);
    return phoneData;
  }

  @override
  String? get view => phoneData?._phoneNumber;

  String? get _countryCode {
    if (isManualSelector && selectedCountry != null) {
      return selectedCountry!.isoCode;
    }
    return null;
  }

  PhoneData? _preprocess(
    Object? value,
  ) {
    if (value == null) {
      return null;
    }
    PhoneData? phoneData;
    if (value is String) {
      if (phoneInputType == LitePhoneInputType.autodetectCode) {
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
          phoneData = PhoneData(
            countryData: countryData,
          )
            .._phoneCountryData = phoneCountryData
            .._isManualCountry = false
            .._phoneNumber = formattedPhone;
          return phoneData;
        }
      } else if (phoneInputType == LitePhoneInputType.manualCode) {
        if (selectedCountry != null) {
          if (value.startsWith('+')) {
            value = _removeCountryCode(value);
          }
          final formattedPhone = formatAsPhoneNumber(
            value,
            defaultCountryCode: selectedCountry!.isoCode,
          );
          if (formattedPhone != null) {
            final phoneCountryData = _phoneCountryData;
            if (phoneCountryData != null) {
              phoneData = PhoneData(
                countryData: selectedCountry,
              )
                .._phoneNumber = formattedPhone
                .._isManualCountry = true
                .._phoneCountryData = phoneCountryData;
              return phoneData;
            }
          }
        }
      }
    } else if (value is PhoneData) {
      return value;
    }
    return phoneData;
  }
}

class _LitePhoneInputFieldState extends State<LitePhoneInputField> with FormFieldMixin, PostFrameMixin {
  double _dropSelectorHeight = 0.0;
  final _globalKey = GlobalKey<State<StatefulWidget>>();

  CountryData? _tryGetCountryFromDropSelector() {
    final value = getFieldValue(
      formName: formName,
      fieldName: _dropSelectorName,
    );
    if (value is List) {
      return value.firstOrNull.payload;
    }
    return null;
  }

  @override
  void didFirstLayoutFinished(BuildContext context) {
    _dropSelectorHeight = _globalKey.currentContext!.size!.height;
    liteFormRebuildController.rebuild();
  }

  bool get _useErrorDecoration {
    return !widget.useSmoothError && widget.allowErrorTexts;
  }

  bool get _isManualSelector {
    return widget.phoneInputType == LitePhoneInputType.manualCode;
  }

  String get _dropSelectorName {
    return widget.name.toFormIgnoreName();
  }

  CountryData? get _selectedCountry {
    return _preprocessor.selectedCountry;
  }

  set _selectedCountry(CountryData? value) {
    _preprocessor.selectedCountry = value;
  }

  PhoneData? get _selectedPhone {
    return _preprocessor._selectedPhone;
  }

  Future _focusField() async {
    field
        .getOrCreateFocusNode(
          focusNode: widget.focusNode,
        )
        ?.requestFocus();
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
          countries: widget.phoneCountries,
          readOnly: widget.readOnly,
          locale: widget.locale,
          menuItemBuilder: widget.menuItemBuilder,
          name: _dropSelectorName,
          style: _textStyle,

          // dropSelectorType: widget.countrySelectorViewType,
          initialValue: _selectedCountry,
          onChanged: (value) {
            setState(() {
              _selectedCountry = (value as List).first.payload as CountryData;
              final phoneCountryData = PhoneCodes.getPhoneCountryDataByCountryCode(
                _selectedCountry!.isoCode,
              );
              _selectedPhone?.countryData = _selectedCountry;
              _selectedPhone?._phoneCountryData = phoneCountryData!;
              liteFormController.onValueChanged(
                isInitialValue: false,
                formName: formName,
                fieldName: widget.name,
                value: _selectedPhone,
                view: _selectedPhone?.formattedPhone,
              );
              _focusField();
            });
          },
          settings: widget.countrySelectorSettings ??
              DropSelectorSettings(
                searchSettings: const MenuSearchConfiguration(
                  autofocusSearchField: true,
                ),
                dropSelectorActionType: DropSelectorActionType.simple,
                dropSelectorType: widget.countrySelectorViewType,
                maxMenuWidth: 330.0,
              ),
          selectorViewBuilder: (context, List<LiteDropSelectorItem> selectedItems, String? error) {
            final countyData = selectedItems.first.payload as CountryData;
            final padding = (decoration.contentPadding as EdgeInsets?)?.left ?? kDefaultPadding;
            return Padding(
              padding: EdgeInsets.only(
                right: padding,
              ),
              child: Container(
                width: widget.leadingWidth,
                height: _dropSelectorHeight,
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: padding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CountryFlag(
                        countryId: countyData.isoCode,
                        onFlagError: () {},
                        isCircle: false,
                        height: 25.0,
                        width: 35.0,
                      ),
                      Expanded(
                        child: Text(
                          countyData.phoneCode,
                          textAlign: TextAlign.center,
                          style: _textStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  TextStyle? get _textStyle {
    return liteFormController.config?.defaultTextStyle ?? widget.style ?? Theme.of(context).textTheme.bodyMedium;
  }

  PhonePreprocessor get _preprocessor {
    if (field.preprocessor == null) {
      field.preprocessor = PhonePreprocessor(
        phoneInputType: widget.phoneInputType,
        formName: formName,
        fieldName: widget.name,
        isManualSelector: _isManualSelector,
      );
      if (_selectedCountry == null) {
        if (_isManualSelector) {
          _selectedCountry = _tryGetCountryFromDropSelector();
          if (_selectedCountry == null) {
            if (widget.defaultCountry != null) {
              if (widget.defaultCountry is String) {
                _selectedCountry = tryFindCountries(
                  widget.defaultCountry as String,
                ).firstOrNull;
              } else if (widget.defaultCountry is CountryData) {
                _selectedCountry = widget.defaultCountry as CountryData;
              }
            }
          }
          _selectedCountry ??= tryFindCountries('US').first;
        }
      }
    }
    (field.preprocessor as PhonePreprocessor).textEditingController = textEditingController;

    return field.preprocessor! as PhonePreprocessor;
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
      label: widget.label,
      decoration: widget.decoration,
      errorStyle: widget.errorStyle,
      focusNode: widget.focusNode,
      viewConverter: null,
      isReadOnly: widget.readOnly,
    );

    tryDeserializeInitialValueIfNecessary(
      rawInitialValue: widget.initialValue,
      initialValueDeserializer: widget.initialValueDeserializer,
    );

    // final PhoneData? postProcessedValue = _postProcessInitialValue(
    //   initialValue,
    // );

    /// just to initialize a preprocessor be cause it will be
    /// necessary to set an initial value
    _preprocessor;
    setInitialValue(
      fieldName: widget.name,
      formName: group.name,
      setter: () {
        liteFormController.onValueChanged(
          fieldName: widget.name,
          formName: group.name,
          // value: postProcessedValue,
          /// we don't need to process the value before setting it here
          /// we also don't need a view. All of this will be extracted from a
          /// preprocessor inside
          value: initialValue,
          isInitialValue: true,
          // view: postProcessedValue?._phoneNumber,
          view: null,
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
                  autofocus: widget.autofocus,
                  readOnly: widget.readOnly,
                  restorationId: widget.restorationId,
                  validator: widget.validators != null
                      ? (value) {
                          final error = group.translationBuilder(field.error);
                          if (error?.isNotEmpty != true) {
                            return null;
                          }
                          return error;
                        }
                      : null,
                  autovalidateMode: null,
                  focusNode: field.getOrCreateFocusNode(
                    focusNode: widget.focusNode,
                  ),
                  onFieldSubmitted: (value) {
                    if (widget.onFieldSubmitted == null) {
                      form(group.name).focusNextField();
                    } else {
                      widget.onFieldSubmitted!.call(value);
                    }
                  },
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
                      defaultCountryCode: _preprocessor._countryCode,
                      allowEndlessPhone: widget.allowEndlessPhone,
                      onCountrySelected: (value) {
                        if (value is PhoneCountryData && _selectedCountry == null) {}
                      },
                    ),
                  ],
                  onChanged: (value) {
                    _selectedPhone?._phoneNumber = value;
                    liteFormController.onValueChanged(
                      isInitialValue: false,
                      formName: group.name,
                      fieldName: widget.name,
                      value: _selectedPhone,
                      view: null,
                    );
                    widget.onChanged?.call(_selectedPhone);
                  },
                  style: _textStyle,
                  textAlign: widget.textAlign,
                  textAlignVertical: widget.textAlignVertical,
                  textCapitalization: widget.textCapitalization,
                  textDirection: widget.textDirection,
                  keyboardType: TextInputType.phone,
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
