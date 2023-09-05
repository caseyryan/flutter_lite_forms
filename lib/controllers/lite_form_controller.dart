import 'package:flutter/material.dart';
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

  void onValueChanged({
    required String formName,
    required String fieldName,
    required Object? value,
  }) {
    _FormGroupWrapper? group = _groups[formName];
    if (group != null) {
      group.tryFindField(fieldName)?._value = value;
    }
  }

  FormGroupField<T> registerFormField<T>({
    required String formName,
    required String fieldName,
    required LiteFormValueSerializer serializer,
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
