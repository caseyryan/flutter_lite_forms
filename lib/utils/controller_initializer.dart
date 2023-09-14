import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_text_form_field.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/intl_local/lib/intl.dart';
import 'package:lite_state/lite_state.dart';

/// Call it somewhere in the beginning of your app code
/// [config] allows you to configure the look and feel
/// for all of your form fields by default.
/// Doing this you won't have to set decorations, paddings
/// and other common stuff for your forms everywhere
void initializeLiteForms({
  LiteFormsConfiguration? config,
}) {
  initControllersLazy({
    LiteFormController: () => LiteFormController(),
    /// this controller is used as a helper to rebuild some parts of the UI
    /// related to the inners parts of the form fields
    LiteFormRebuildController: () => LiteFormRebuildController(),
  });
  if (config != null) {
    liteFormController.configureLiteFormUI(
      config: config,
    );
  }
}

class LiteFormsConfiguration {
  final InputDecoration? inputDecoration;
  final AutovalidateMode? autovalidateMode;
  final DateFormat? defaultDatePickerFormat;
  final DateFormat? defaultDateTimePickerFormat;
  final DateFormat? defaultTimePickerFormat;
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

  LiteFormsConfiguration({
    this.inputDecoration,
    this.autovalidateMode,
    this.defaultDatePickerFormat,
    this.defaultTextEntryModalRouteSettings,
    this.defaultDateTimePickerFormat,
    this.defaultTimePickerFormat,
    this.allowUnfocusOnTapOutside,
    this.useAutogeneratedHints = false,
  });
}
