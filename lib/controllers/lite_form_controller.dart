import 'package:flutter/material.dart';
import 'package:lite_forms/utils/controller_initializer.dart';
import 'package:lite_forms/utils/value_serializer.dart';
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

bool validateLiteForm(String formName) {
  return liteFormController.validateForm(
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
  final Map<String, _FormGroupWrapper> _groups = {};

  LiteFormsConfiguration? _config;
  LiteFormsConfiguration? get config => _config;

  /// this method allows you to configure the look and feel 
  /// for all of your form fields by default. 
  /// Doing this you won't have to set decorations, paddings
  /// and other common stuff for your forms everywhere. Just 
  /// call this method somewhere in the beginning and you're all set
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
    if (!_groups.containsKey(formName)) {
      _groups[formName] = _FormGroupWrapper();
    }
    if (formState != null) {
      _groups[formName]?._formState = formState;
    }
  }

  
  Object? tryGetValueForField({
    required String formName,
    required String fieldName,
  }) {
    return _groups[formName]?.tryFindField(fieldName)?._value;
  }

  bool validateForm({
    required String formName,
  }) {
    return _groups[formName]?.validate() ?? true;
  }

  Map<String, dynamic> getFormData(String formName) {
    return _groups[formName]?.getFormData() ?? {};
  }

  void onFormDisposed({
    required String formName,
    required bool autoDispose,
  }) {
    if (_groups.containsKey(formName)) {
      final wrapper = _groups[formName];
      wrapper?.clearDependencies();
      if (autoDispose) {
        clearForm(formName);
      }
    }
  }

  void clearForm(String formName) {
    _groups.remove(formName);
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
    _FormGroupWrapper? group = _groups[formName];
    if (group != null) {
      group.tryFindField(fieldName)?.updateValue(
            value,
            isInitialValue,
            view,
          );
    }
  }

  /// Registers a form field for a specified form. If the 
  /// form field is already registered, it does nothing
  FormGroupField<T> registerFormField<T>({
    required String formName,
    required String fieldName,
    required LiteFormValueConvertor serializer,
  }) {
    createFormIfNull(formName: formName);
    final groupWrapper = _groups[formName]!;
    return groupWrapper.tryRegisterField(
      name: fieldName,
      serializer: serializer,
    );
  }

  @override
  void reset() {}
  @override
  void onLocalStorageInitialized() {}
}
