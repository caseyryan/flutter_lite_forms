import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/intl_local/lib/intl.dart' as local_intl;
import 'package:lite_forms/lite_forms.dart';
import 'package:lite_forms/utils/string_extensions.dart';
import 'package:lite_forms/utils/value_validator.dart';

enum LiteDatePickerType {
  iOS,
  material,
  adaptive,
}

class LiteDatePicker extends StatefulWidget {
  const LiteDatePicker({
    super.key,
    required this.name,
    this.serializer = nonConvertingValueConvertor,
    this.initialValueDeserializer,
    this.validator,
    this.initialValue,
    this.maxDate,
    this.minDate,
    this.format,
    this.pickerBackgroundColor,
    this.autovalidateMode,
    this.hintText,
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
    this.restorationId,
    this.textAlignVertical,
    this.use24HourFormat = true,
    this.textAlign = TextAlign.start,
    this.pickerType = LiteDatePickerType.adaptive,
    this.initialEntryMode = TimePickerEntryMode.dial,
  });

  /// The look and feel of the picker
  /// [LiteDatePickerType.adaptive] is selected by default
  /// this means the picker will be automatically
  /// set up according to the selected operating system
  final LiteDatePickerType pickerType;
  final String name;
  final bool use24HourFormat;
  final DateTime? initialValue;
  final DateTime? maxDate;
  final DateTime? minDate;
  final local_intl.DateFormat? format;
  final DateInputType dateInputType;
  final Color? pickerBackgroundColor;
  final AutovalidateMode? autovalidateMode;
  final String? hintText;
  final InputDecoration? decoration;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final String? restorationId;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  /// initial mode for a material picker. Makes sense only if
  /// [pickerType] is [LiteDatePickerType.material]
  final TimePickerEntryMode initialEntryMode;

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
  final LiteFormFieldValidator<DateTime>? validator;

  @override
  State<LiteDatePicker> createState() => _LiteDatePickerState();
}

class _LiteDatePickerState extends State<LiteDatePicker> {
  LiteFormGroup? _group;
  bool _hasSetInitialValue = false;

  /// used only for a material time / date time picker
  DateTime? _selectedDateTime;

  @override
  void didUpdateWidget(covariant LiteDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dateInputType != oldWidget.dateInputType) {
      _hasSetInitialValue = false;
    }
  }

  LiteDatePickerType get _type {
    if (kIsWeb) {
      return LiteDatePickerType.material;
    } else {
      if (widget.pickerType == LiteDatePickerType.adaptive) {
        if (Platform.isIOS) {
          return LiteDatePickerType.iOS;
        }
      } else if (widget.pickerType == LiteDatePickerType.iOS) {
        return LiteDatePickerType.iOS;
      }
    }
    return LiteDatePickerType.material;
  }

  bool get _isIos {
    return _type == LiteDatePickerType.iOS;
  }

  Future<DateTime?> _onShowPickerPressed({
    required BuildContext context,
    DateTime? currentValue,
  }) async {
    final theme = Theme.of(context);
    currentValue ??= (liteFormController.tryGetValueForField(
          formName: _group!.name,
          fieldName: widget.name,
        ) as DateTime? ??
        widget.initialValue);
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
          pickerBackgroundColor:
              widget.pickerBackgroundColor ?? theme.scaffoldBackgroundColor,
          initialDate: currentValue,
          minimumDate: minDate,
          maximumDate: maxDate,
        );
        break;
      case DateInputType.time:
        newValue = await _showTimePicker(
          context: context,
          pickerBackgroundColor:
              widget.pickerBackgroundColor ?? theme.scaffoldBackgroundColor,
          initialDate: currentValue,
          minimumDate: maxDate,
          maximumDate: minDate,
          use24HourFormat: widget.use24HourFormat,
        );
        break;
      case DateInputType.both:
        newValue = await _showDateTimePicker(
          context: context,
          pickerBackgroundColor:
              widget.pickerBackgroundColor ?? theme.scaffoldBackgroundColor,
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
      return widget.format ??
          liteFormController.config?.defaultDatePickerFormat ??
          local_intl.DateFormat('dd MMMM, yyyy');
    }

    if (widget.dateInputType == DateInputType.time) {
      return widget.format ??
          liteFormController.config?.defaultTimePickerFormat ??
          local_intl.DateFormat('hh:mm');
    }

    if (widget.dateInputType == DateInputType.both) {
      return widget.format ??
          liteFormController.config?.defaultDateTimePickerFormat ??
          local_intl.DateFormat('dd MMMM, yyyy | hh:mm');
    }

    return local_intl.DateFormat('dd MMMM, yyyy');
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
                            style:
                                CupertinoTheme.of(context).textTheme.textStyle.copyWith(
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
                          child: const Text('Done'),
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
    _selectedDateTime = DateTime.now().clamp(minimumDate, maximumDate);

    if (mode == CupertinoDatePickerMode.time) {
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
      return _selectedDateTime!.copyWith(
        hour: timeOfDay.hour,
        minute: timeOfDay.minute,
      );
    }

    return showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: minimumDate,
      lastDate: maximumDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    _group = LiteFormGroup.of(context);
    final field = liteFormController.registerFormField<DateTime>(
      fieldName: widget.name,
      formName: _group!.name,
      serializer: widget.serializer,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
    );
    DateTime? value =
        widget.initialValueDeserializer?.call(widget.initialValue) as DateTime? ??
            widget.initialValue;

    final dateFormat = _dateFormat;
    if (value != null) {
      if (!_hasSetInitialValue) {
        _hasSetInitialValue = true;
        liteFormController.onValueChanged(
          formName: _group!.name,
          fieldName: widget.name,
          value: value,
          view: dateFormat.format(value),
          isInitialValue: true,
        );
      }
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
    final textEditingController = field.getOrCreateTextEditingController();

    return GestureDetector(
      onTap: () async {
        final dateTime = await _onShowPickerPressed(
          context: context,
        );
        liteFormController.onValueChanged(
          formName: _group!.name,
          fieldName: widget.name,
          value: dateTime,
          view: dateTime != null ? dateFormat.format(dateTime) : null,
        );
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
            child: TextFormField(
              restorationId: widget.restorationId,
              validator: widget.validator != null
                  ? (value) {
                      return field.error;
                    }
                  : null,
              autovalidateMode: null,
              controller: textEditingController,
              decoration: decoration,
              strutStyle: widget.strutStyle,
              style: widget.style,
              textAlign: widget.textAlign,
              textAlignVertical: widget.textAlignVertical,
              textCapitalization: widget.textCapitalization,
              textDirection: widget.textDirection,
              textInputAction: widget.textInputAction,
            ),
          ),
        ),
      ),
    );
  }
}
