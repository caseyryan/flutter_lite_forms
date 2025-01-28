import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/lite_drop_selector.dart';
import 'package:lite_forms/base_form_fields/lite_text_form_field.dart';
import 'package:lite_forms/constants.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';

part 'config_presets/_thin_fields.dart';
part 'config_presets/_vanila.dart';

class LiteFormsConfiguration {
  final AutovalidateMode? autovalidateMode;

  final String? defaultDateFormat;
  final String? defaultTimeFormat;

  /// if this is true and you don't pass hintText to a
  /// form field, it will automatically generate it based on the field's name
  /// value, using splitByCamelCase method()
  final bool useAutogeneratedHints;

  /// a default settings for text entry using [TextEntryType.onModalRoute]
  final TextEntryModalRouteSettings? defaultTextEntryModalRouteSettings;

  /// Will automatically hide the keyboard if you tap outside
  /// of the focused text input. This can also be set individually for
  /// each form via a [LiteFormGroup] constructor
  /// Has no effect on web
  final bool? allowUnfocusOnTapOutside;

  final DropSelectorSettings dropSelectorSettings;

  final LiteFormsTheme? lightTheme;
  final LiteFormsTheme? darkTheme;

  TextStyle? get defaultTextStyle {
    return activeTheme?.defaultTextStyle;
  }

  InputDecoration? get inputDecoration {
    return activeTheme?.inputDecoration;
  }

  BoxDecoration? get filePickerDecoration {
    return activeTheme?.filePickerDecoration;
  }

  Color? get shadowColor {
    return activeTheme?.shadowColor;
  }

  Color? get destructiveColor {
    return activeTheme?.destructiveColor;
  }

  Color? get dropSelectorChipColor {
    return activeTheme?.dropSelectorChipColor;
  }

  LiteFormsTheme? get activeTheme {
    return isDarkTheme ? darkTheme : lightTheme;
  }

  /// [LiteFormsConfiguration.vanilla] is a default preset which you can
  /// use as a starting point
  factory LiteFormsConfiguration.vanilla(
    BuildContext context,
  ) {
    return _vanilla(context);
  }

  factory LiteFormsConfiguration.thinFields(
    BuildContext context,
  ) {
    return _thinFields(context);
  }

  LiteFormsConfiguration({
    this.lightTheme,
    this.darkTheme,
    this.autovalidateMode,
    this.dropSelectorSettings = const DropSelectorSettings(
      topLeftRadius: kDefaultFormSmoothRadius,
      topRightRadius: kDefaultFormSmoothRadius,
      bottomLeftRadius: kDefaultFormSmoothRadius,
      bottomRightRadius: kDefaultFormSmoothRadius,
      dropSelectorActionType: DropSelectorActionType.simple,
      dropSelectorType: DropSelectorType.adaptive,
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
    required this.defaultTextStyle,
    this.inputDecoration,
    this.shadowColor,
    this.dropSelectorChipColor,
    this.filePickerDecoration,
    this.destructiveColor,
  });

  final TextStyle defaultTextStyle;
  final Color? destructiveColor;
  final InputDecoration? inputDecoration;
  final BoxDecoration? filePickerDecoration;
  final Color? shadowColor;
  final Color? dropSelectorChipColor;
}
