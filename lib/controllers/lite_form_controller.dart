import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/controllers/lite_timer_controller.dart';
import 'package:lite_forms/interfaces/preprocessor.dart';
import 'package:lite_forms/utils/exports.dart';
import 'package:lite_forms/utils/lite_forms_configuration.dart';
import 'package:lite_state/lite_state.dart';

import '../base_form_fields/exports.dart';

part '_form_group_field.dart';
part '_global_functions.dart';
part '_shorthands.dart';
part 'group_wrapper.dart';

class LiteFormController extends LiteStateController<LiteFormController> {
  final Map<String, _FormGroupWrapper> _formGroups = {};

  LiteFormsConfiguration? _config;
  LiteFormsConfiguration? get config => _config;

  Brightness _brightness = Brightness.light;
  void updateBrightness(Brightness value) {
    if (_brightness == value) {
      return;
    }
    _brightness = value;
    rebuild();
    liteFormRebuildController.rebuild();
  }

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
    required bool autoRemoveUnregisteredFields,
    FormState? formState,
  }) {
    if (!_formGroups.containsKey(formName)) {
      _formGroups[formName] = _FormGroupWrapper(
        autoRemoveUnregisteredFields: autoRemoveUnregisteredFields,
      );
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

  /// This is required to be able to keep form up to date
  /// For example you might have remove some fields
  /// from a form because of some user's actions
  /// then we don't have to validate them any more
  /// A real use case: User selects a `MALE` gender but
  /// you had `Pregnancy status` drop selector and you want to
  /// remove it for a male. There is not need to validate it but
  /// the form has this field already registered
  ///
  /// This method will remove this sort of inputs and unregister them
  // void removeUnregisteredFields({
  //   required String formName,
  // }) {
  //   final form = _formGroups[formName];
  //   if (form != null) {
  //     form.unregisterAllOutdatedFields();
  //   }
  // }

  FutureOr<Object?> tryGetValueForField({
    required String formName,
    required String fieldName,
    bool applySerializer = false,
  }) {
    final field = tryGetField(
      formName: formName,
      fieldName: fieldName,
    );
    return field?.getValue(applySerializer);
  }

  FormGroupField? tryGetField({
    required String formName,
    required String fieldName,
  }) {
    return _formGroups[formName]?.tryFindField(fieldName);
  }

  _FormGroupWrapper? _tryGetFormGroupWrapper(String formName) {
    return _formGroups[formName];
  }

  void tryUnregisterField(String formName, String fieldName) {
    _tryGetFormGroupWrapper(formName)?.unregisterField(
      fieldName: fieldName,
    );
  }

  Future<bool> validateForm({
    required String formName,
  }) async {
    startLoading();
    final result = await _formGroups[formName]?.validate() ?? true;
    stopLoading();
    return result;
  }

  void changeRemoveState({
    required String formName,
    required String fieldName,
    required bool isRemoved,
  }) {
    final FormGroupField? field = tryGetField(
      fieldName: fieldName,
      formName: formName,
    );
    if (field != null) {
      field._isRemoved = isRemoved;
    }
  }

  /// [mountedOnly] if true, this will
  /// return only the fields that are
  /// currently mounted into a widget tree
  Iterable<FormGroupField> getAllFieldsOfForm({
    required String formName,
    bool mountedOnly = false,
    bool includeIgnored = false,
  }) {
    final list = _formGroups[formName]?._fields.values.where(
          (f) {
            if (includeIgnored) {
              return true;
            }
            return !f.name.isIgnoredInForm();
          },
        ).toList() ??
        <FormGroupField>[];
    if (mountedOnly) {
      return list.where((f) => f.isMounted).toList();
    }
    return list;
  }

  Future<Map<String, dynamic>> getFormData({
    required String formName,
    required bool applySerializers,
  }) async {
    return await _formGroups[formName]?.getFormData(applySerializers) ?? {};
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
    required String? view,
    bool isInitialValue = false,
  }) {
    _FormGroupWrapper? group = _formGroups[formName];
    if (group != null) {
      group.tryFindField(fieldName)?.onChange(
            value,
            isInitialValue,
            view,
          );
      liteFormRebuildController.rebuild();
    }
  }

  Future scrollToFirstInvalidField(String formName, [
    Duration? duration,
  ]) async {
    _FormGroupWrapper? group = _formGroups[formName];
    if (group != null) {
      await group.scrollToFirstInvalidField(duration);
    }
  }

  bool _isFormBeingValidated(String formName) {
    return _formGroups[formName]?.isBeingValidated == true;
  }

  bool isFieldInitiallySet({
    required String formName,
    required String fieldName,
  }) {
    return _formGroups[formName]?.isFieldInitiallySet(fieldName) == true;
  }

  /// Registers a form field for a specified form. If the
  /// form field is already registered, it does nothing
  FormGroupField<T> registerFormFieldIfNone<T>({
    required String formName,
    required String fieldName,
    required String? label,
    required LiteFormValueSerializer serializer,
    required List<LiteValidator>? validators,
    required AutovalidateMode? autovalidateMode,
    required InputDecoration? decoration,
    required ViewConverter? viewConverter,
  }) {
    // createFormIfNull(formName: formName);
    final groupWrapper = _formGroups[formName]!;
    return groupWrapper.tryRegisterField(
      name: fieldName,
      formName: formName,
      label: label,
      serializer: serializer,
      validators: validators,
      decoration: decoration,
      autovalidateMode: autovalidateMode,
      viewConverter: viewConverter
    );
  }

  @override
  void reset() {}
  @override
  void onLocalStorageInitialized() {}
}
