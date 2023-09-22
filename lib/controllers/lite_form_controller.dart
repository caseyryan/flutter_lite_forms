import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lite_forms/utils/controller_initializer.dart';
import 'package:lite_forms/utils/value_serializer.dart';
import 'package:lite_forms/utils/value_validator.dart';
import 'package:lite_state/lite_state.dart';

part 'group_wrapper.dart';

/// call this function if you want to clear the values for
/// a form. Usually forms are cleared automatically when
/// their containing widget is disposed but this
/// behavior changes if you pass [autoDispose]: false
/// to LiteFormGroup
void clearLiteForm(String formName) {
  liteFormController.clearForm(formName);
}

/// Allows to check if a form is in the process of being validated
bool isFormBeingValidated(String formName) {
  return liteFormController._isFormBeingValidated(formName);
}

/// This method is made asynchronous because
/// validators in LiteForms can be asynchronous unlike
/// many in other form packages
Future<bool> validateLiteForm(String formName) async {
  return await liteFormController.validateForm(
    formName: formName,
  );
}

Map<String, dynamic> getFormData(String formName) {
  return liteFormController.getFormData(
    formName,
  );
}

LiteFormController get liteFormController {
  return findController<LiteFormController>();
}

class LiteFormController extends LiteStateController<LiteFormController> {
  final Map<String, _FormGroupWrapper> _formGroups = {};

  LiteFormsConfiguration? _config;
  LiteFormsConfiguration? get config => _config;

  void configureLiteFormUI({
    LiteFormsConfiguration? config,
  }) {
    _config = config;
    rebuild();
  }

  /// this method registers a new form if it
  /// was not created previously
  void createFormIfNull({
    required String formName,
    FormState? formState,
  }) {
    if (!_formGroups.containsKey(formName)) {
      _formGroups[formName] = _FormGroupWrapper();
    }
    if (formState != null) {
      _formGroups[formName]?._formState = formState;
    }
  }

  void checkAlwaysValidatingFields({
    required String formName,
  }) {
    if (_formGroups[formName]?._fields.isNotEmpty == true) {
      for (var element in _formGroups[formName]!._fields.values) {
        element._validateOnlyAlwaysValidating();
      }
    }
  }

  Object? tryGetValueForField({
    required String formName,
    required String fieldName,
  }) {
    return tryGetField(
      formName: formName,
      fieldName: fieldName,
    )?._value;
  }

  FormGroupField? tryGetField({
    required String formName,
    required String fieldName,
  }) {
    return _formGroups[formName]?.tryFindField(fieldName);
  }

  Future<bool> validateForm({
    required String formName,
  }) async {
    startLoading();
    final result = await _formGroups[formName]?.validate() ?? true;
    stopLoading();
    return result;
  }

  Map<String, dynamic> getFormData(String formName) {
    return _formGroups[formName]?.getFormData() ?? {};
  }

  void onFormDisposed({
    required String formName,
    required bool autoDispose,
  }) {
    if (_formGroups.containsKey(formName)) {
      final wrapper = _formGroups[formName];
      wrapper?.clearDependencies();
      if (autoDispose) {
        clearForm(formName);
      }
    }
  }

  void clearForm(String formName) {
    _formGroups.remove(formName);
  }

  /// [view] is a String that will be displayed
  /// to a user. This must be null for text inputs
  /// since they are updated on user input but for
  /// other inputs e.g. a LiteDatePicker this must be a
  /// formatted date representation
  void onValueChanged({
    required String formName,
    required String fieldName,
    required Object? value,
    String? view,
    bool isInitialValue = false,
  }) {
    _FormGroupWrapper? group = _formGroups[formName];
    if (group != null) {
      group.tryFindField(fieldName)?.onChange(
            value,
            isInitialValue,
            view,
          );
    }
  }

  bool _isFormBeingValidated(String formName) {
    return _formGroups[formName]?.isBeingValidated == true;
  }

  /// Registers a form field for a specified form. If the
  /// form field is already registered, it does nothing
  FormGroupField<T> registerFormFieldIfNone<T>({
    required String formName,
    required String fieldName,
    required LiteFormValueConvertor serializer,
    required LiteFormFieldValidator<T>? validator,
    required AutovalidateMode? autovalidateMode,
  }) {
    createFormIfNull(formName: formName);
    final groupWrapper = _formGroups[formName]!;
    return groupWrapper.tryRegisterField(
      name: fieldName,
      serializer: serializer,
      validator: validator,
      autovalidateMode: autovalidateMode,
    );
  }

  @override
  void reset() {}
  @override
  void onLocalStorageInitialized() {}
}
