import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/intl_local/lib/intl.dart' as local_intl;
import 'package:lite_forms/lite_forms.dart';
import 'package:lite_forms/utils/extended_platform/extended_platform.dart';

import 'error_line.dart';
import 'mixins/form_field_mixin.dart';

enum LiteDatePickerType {
  cupertino,
  material,
  adaptive,
}

class LiteDatePicker extends StatefulWidget {
  LiteDatePicker({
    Key? key,
    required this.name,
    this.serializer = nonConvertingValueConvertor,
    this.initialValueDeserializer,
    this.validators,
    this.errorStyle,
    this.onChanged,
    this.initialValue,
    this.maxDate,
    this.minDate,
    this.format,
    this.pickerBackgroundColor,
    this.autovalidateMode,
    this.hintText,
    this.label,
    this.decoration,
    this.dateInputType = DateInputType.date,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.focusNode,
    this.restorationId,
    this.textAlignVertical,
    this.use24HourFormat = true,
    this.textAlign = TextAlign.start,
    this.pickerType = LiteDatePickerType.adaptive,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.smoothErrorPadding = const EdgeInsets.only(
      top: 6.0,
    ),
    this.useSmoothError = true,
    this.allowErrorTexts = true,
    this.readOnly = false,
  }) : super(key: key ?? Key(name));

  /// The look and feel of the picker
  /// [LiteDatePickerType.adaptive] is selected by default
  /// this means the picker will be automatically
  /// set up according to the selected operating system
  final LiteDatePickerType pickerType;
  final String name;
  final bool readOnly;
  final bool use24HourFormat;

  /// It is assumed that the initial value is DateTime? but you might
  /// also pass something else, for example a iso8601 String, and the
  /// form field must be ok with it as long as you also pass an [initialValueDeserializer]
  /// which will convert initial value into a DateTime object or else you will get an
  /// exception
  final Object? initialValue;
  final DateTime? maxDate;
  final DateTime? minDate;
  final local_intl.DateFormat? format;
  final DateInputType dateInputType;
  final Color? pickerBackgroundColor;
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final String? label;
  final InputDecoration? decoration;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final String? restorationId;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final ValueChanged<DateTime?>? onChanged;
  final FocusNode? focusNode;

  /// initial mode for a material picker. Makes sense only if
  /// [pickerType] is [LiteDatePickerType.material]
  final TimePickerEntryMode initialEntryMode;

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
  State<LiteDatePicker> createState() => _LiteDatePickerState();
}

class _LiteDatePickerState extends State<LiteDatePicker> with FormFieldMixin {
  LiteDatePickerType get _type {
    if (widget.pickerType == LiteDatePickerType.adaptive) {
      if (ExtendedPlatform.isIOS) {
        return LiteDatePickerType.cupertino;
      }
    } else if (widget.pickerType == LiteDatePickerType.cupertino) {
      return LiteDatePickerType.cupertino;
    }
    return LiteDatePickerType.material;
  }

  bool get _isIos {
    return _type == LiteDatePickerType.cupertino;
  }

  bool get _useErrorDecoration {
    return !widget.useSmoothError && widget.allowErrorTexts;
  }

  Future<DateTime?> _onShowPickerPressed({
    required BuildContext context,
    DateTime? currentValue,
  }) async {
    final theme = Theme.of(context);

    currentValue ??= (liteFormController.tryGetValueForField(
          formName: group.name,
          fieldName: widget.name,
        ) as DateTime? ??
        widget.initialValue as dynamic);
    DateTime? minDate = widget.minDate;
    DateTime? maxDate = widget.maxDate;
    if (currentValue != null) {
      if (maxDate != null) {
        if (currentValue.isAfter(maxDate)) {
          currentValue = maxDate.subtract(const Duration(seconds: 1));
        }
      }
      if (minDate != null) {
        if (currentValue.isBefore(minDate)) {
          currentValue = minDate.add(const Duration(seconds: 1));
        }
      }
    }
    DateTime? newValue;
    switch (widget.dateInputType) {
      case DateInputType.date:
        newValue = await _showDatePicker(
          context: context,
          pickerBackgroundColor: widget.pickerBackgroundColor ?? theme.scaffoldBackgroundColor,
          initialDate: currentValue,
          minimumDate: minDate,
          maximumDate: maxDate,
        );
        break;
      case DateInputType.time:
        newValue = await _showTimePicker(
          context: context,
          pickerBackgroundColor: widget.pickerBackgroundColor ?? theme.scaffoldBackgroundColor,
          initialDate: currentValue,
          minimumDate: maxDate,
          maximumDate: minDate,
          use24HourFormat: widget.use24HourFormat,
        );
        break;
      case DateInputType.both:
        newValue = await _showDateTimePicker(
          context: context,
          pickerBackgroundColor: widget.pickerBackgroundColor ?? theme.scaffoldBackgroundColor,
          initialDate: currentValue,
          minimumDate: minDate,
          maximumDate: maxDate,
          use24HourFormat: widget.use24HourFormat,
        );
        break;
      default:
        throw 'Unexpected input type ${widget.dateInputType}';
    }
    final DateTime? finalValue = newValue ?? currentValue;
    return finalValue;
  }

  local_intl.DateFormat get _dateFormat {
    if (widget.dateInputType == DateInputType.date) {
      return widget.format ?? local_intl.DateFormat(liteFormController.config?.defaultDateFormat ?? 'dd MMMM, yyyy');
    }

    if (widget.dateInputType == DateInputType.time) {
      return widget.format ?? local_intl.DateFormat(liteFormController.config?.defaultTimeFormat ?? _timeFormat);
    }

    if (widget.dateInputType == DateInputType.both) {
      if (widget.format != null) {
        return widget.format!;
      }
      final timeFormatPattern = liteFormController.config?.defaultTimeFormat ?? _timeFormat;
      final dateFormatPattern = liteFormController.config?.defaultDateFormat ?? 'dd MMMM, yyyy';

      return local_intl.DateFormat('$dateFormatPattern | $timeFormatPattern');
    }

    return local_intl.DateFormat('dd MMMM, yyyy');
  }

  String get _timeFormat {
    if (widget.use24HourFormat) {
      return 'HH:mm';
    }
    return 'hh:mm';
  }

  Future<DateTime?> _showDatePicker({
    required BuildContext context,
    required Color pickerBackgroundColor,
    DateTime? initialDate,
    String? header,
    DateTime? minimumDate,
    DateTime? maximumDate,
  }) async {
    return await _showPicker(
      context: context,
      pickerBackgroundColor: pickerBackgroundColor,
      mode: CupertinoDatePickerMode.date,
      header: header,
      initialDate: initialDate,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
    );
  }

  Future<DateTime?> _showDateTimePicker({
    required BuildContext context,
    required Color pickerBackgroundColor,
    DateTime? initialDate,
    String? header,
    DateTime? minimumDate,
    DateTime? maximumDate,
    bool use24HourFormat = true,
  }) async {
    return await _showPicker(
      context: context,
      pickerBackgroundColor: pickerBackgroundColor,
      mode: CupertinoDatePickerMode.dateAndTime,
      initialDate: initialDate,
      header: header,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      use24HourFormat: use24HourFormat,
    );
  }

  Future<DateTime?> _showTimePicker({
    required BuildContext context,
    required Color pickerBackgroundColor,
    DateTime? initialDate,
    String? header,
    DateTime? minimumDate,
    DateTime? maximumDate,
    bool use24HourFormat = true,
  }) async {
    return await _showPicker(
      context: context,
      mode: CupertinoDatePickerMode.time,
      pickerBackgroundColor: pickerBackgroundColor,
      header: header,
      initialDate: initialDate,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      use24HourFormat: use24HourFormat,
    );
  }

  Future<DateTime?> _showPicker({
    required BuildContext context,
    required CupertinoDatePickerMode mode,
    required Color pickerBackgroundColor,
    String? header,
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    bool use24HourFormat = true,
  }) async {
    var dateTime = initialDate ?? DateTime.now();
    dateTime = dateTime.clamp(
      minimumDate,
      maximumDate,
    );
    if (_isIos) {
      return await showCupertinoModalPopup(
        context: context,
        builder: (c) {
          return StatefulBuilder(
            builder: (c2, setState) {
              return Container(
                color: pickerBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CupertinoButton(
                          child: Text(
                            'Cancel',
                            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                  color: CupertinoDynamicColor.resolve(
                                    CupertinoColors.placeholderText,
                                    context,
                                  ),
                                ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(null);
                          },
                        ),
                        const Spacer(),
                        CupertinoButton(
                          key: const Key('picker_done_button'),
                          onPressed: () {
                            Navigator.of(context).pop(dateTime);
                          },
                          child: const Text(
                            'Done',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 280,
                      child: CupertinoDatePicker(
                        use24hFormat: use24HourFormat,
                        key: const Key('cupertino_picker'),
                        mode: mode,
                        initialDateTime: dateTime,
                        minimumDate: minimumDate,
                        maximumDate: maximumDate,
                        onDateTimeChanged: (DateTime value) {
                          dateTime = value.clamp(minimumDate, maximumDate);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
    minimumDate ??= DateTime(0);
    maximumDate ??= DateTime(2100);

    if (mode == CupertinoDatePickerMode.date) {
      return await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: minimumDate,
        lastDate: maximumDate,
      );
    }
    DateTime? dateOnly;
    if (mode == CupertinoDatePickerMode.dateAndTime) {
      dateOnly = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: minimumDate,
        lastDate: maximumDate,
      );
      if (dateOnly == null || !mounted) {
        return null;
      }
    }
    if (!mounted) {
      return null;
    }
    final timeOfDay = await showTimePicker(
      context: context,
      initialEntryMode: widget.initialEntryMode,
      initialTime: TimeOfDay.fromDateTime(dateTime),
      builder: widget.use24HourFormat
          ? (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: true,
                ),
                child: child!,
              );
            }
          : null,
    );
    if (timeOfDay == null) {
      return null;
    }
    if (dateOnly != null) {
      return dateOnly.copyWith(
        hour: timeOfDay.hour,
        minute: timeOfDay.minute,
      );
    }
    return dateTime.copyWith(
      hour: timeOfDay.hour,
      minute: timeOfDay.minute,
    );
  }

  Future _onTap() async {
    if (widget.readOnly) {
      return;
    }
    final dateTime = await _onShowPickerPressed(
      context: context,
    );
    liteFormController.onValueChanged(
      formName: group.name,
      fieldName: widget.name,
      value: dateTime,
      view: dateTime != null ? _dateFormat.format(dateTime) : null,
    );
    widget.onChanged?.call(dateTime);
  }

  @override
  Future onFocusChange() async {
    if (field.hasFocus) {
      // final focusIndex = field.focusIndex;
      await _onTap();
      // form(group.name).focusNextField(focusIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeFormField<DateTime>(
      fieldName: widget.name,
      label: widget.label,
      autovalidateMode: widget.autovalidateMode,
      serializer: widget.serializer,
      initialValueDeserializer: widget.initialValueDeserializer,
      validators: widget.validators,
      hintText: widget.hintText,
      decoration: widget.decoration,
      errorStyle: widget.errorStyle,
      focusNode: widget.focusNode,
    );

    tryDeserializeInitialValueIfNecessary<DateTime>(
      initialValueDeserializer: widget.initialValueDeserializer,
      rawInitialValue: widget.initialValue,
    );
    if (initialValue != null) {
      setInitialValue(
        fieldName: widget.name,
        formName: group.name,
        setter: () {
          liteFormController.onValueChanged(
            formName: group.name,
            fieldName: widget.name,
            value: initialValue,
            view: _dateFormat.format(initialValue),
            isInitialValue: true,
          );
        },
      );
    }

    return Focus(
      focusNode: field.getOrCreateFocusNode(
        focusNode: widget.focusNode,
      ),
      child: GestureDetector(
        onTap: _onTap,
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
                    restorationId: widget.restorationId,
                    validator: widget.validators != null
                        ? (value) {
                            final error = group.translationBuilder(field.error);
                            if (error?.isEmpty == true) {
                              return null;
                            }
                            return error;
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
                    textInputAction: widget.textInputAction,
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
      ),
    );
  }
}
