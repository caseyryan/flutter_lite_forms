import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/lite_drop_selector.dart';
import 'package:lite_forms/base_form_fields/lite_text_form_field.dart';
import 'package:lite_forms/constants.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';

class LiteFormsConfiguration {
  final AutovalidateMode? autovalidateMode;

  final String? defaultDateFormat;
  final String? defaultTimeFormat;

  /// if this is true and you don't pass hintText to a
  /// form field, it will automatically generate it based on the field's name
  /// value, using splitByCamelCase method()
  final bool useAutogeneratedHints;

  /// a default settings for text entry using [LiteTextEntryType.onModalRoute]
  final TextEntryModalRouteSettings? defaultTextEntryModalRouteSettings;

  /// Will automatically hide the keyboard if you tap outside
  /// of the focused text input. This can also be set individually for
  /// each form via a [LiteFormGroup] constructor
  /// Has no effect on web
  final bool? allowUnfocusOnTapOutside;

  final LiteDropSelectorSettings dropSelectorSettings;

  final LiteFormsTheme? lightTheme;
  final LiteFormsTheme? darkTheme;

  TextStyle? get defaultTextStyle {
    return _activeTheme?.defaultTextStyle;
  }

  InputDecoration? get inputDecoration {
    return _activeTheme?.inputDecoration;
  }

  Color? get shadowColor {
    return _activeTheme?.shadowColor;
  }

  Color? get dropSelectorChipColor {
    return _activeTheme?.dropSelectorChipColor;
  }

  LiteFormsTheme? get _activeTheme {
    return isDarkTheme ? darkTheme : lightTheme;
  }

  LiteFormsConfiguration({
    this.lightTheme,
    this.darkTheme,
    this.autovalidateMode,
    this.dropSelectorSettings = const LiteDropSelectorSettings(
      topLeftRadius: kDefaultFormSmoothRadius,
      topRightRadius: kDefaultFormSmoothRadius,
      bottomLeftRadius: kDefaultFormSmoothRadius,
      bottomRightRadius: kDefaultFormSmoothRadius,
    ),

    /// [defaultDateFormat] is a string pattern acceptable by [DateFormat]
    /// for example 'yyyy-MM-dd'
    this.defaultDateFormat,
    this.defaultTextEntryModalRouteSettings,

    /// [defaultTimeFormat] is a string pattern acceptable by [DateFormat]
    /// for example 'HH:mm' for a 24 hour format and 'hh:mm a' for 12
    this.defaultTimeFormat,
    this.allowUnfocusOnTapOutside,
    this.useAutogeneratedHints = false,
  });
}

class LiteFormsTheme {
  const LiteFormsTheme({
    this.defaultTextStyle,
    this.inputDecoration,
    this.shadowColor,
    this.dropSelectorChipColor,
  });

  final TextStyle? defaultTextStyle;
  final InputDecoration? inputDecoration;
  final Color? shadowColor;
  final Color? dropSelectorChipColor;
}
