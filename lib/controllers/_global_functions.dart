// ignore_for_file: library_private_types_in_public_api

part of 'lite_form_controller.dart';

bool get isDarkTheme {
  return liteFormController._brightness == Brightness.dark;
}

/// call this function if you want to clear the values for
/// a form. Usually forms are cleared automatically when
/// their containing widget is disposed but this
/// behavior changes if you pass [autoDispose]: false
/// to LiteFormGroup
void clearLiteForm(String formName) {
  liteFormController.clearForm(formName);
}

/// It's just a shorthand for [getFieldValue]
/// path is a dot separated path where the first part is
/// form name and the second is field name
/// e.g. signup.lastName
T? getValue<T>(String path) {
  final split = path.split('.');
  return getFieldValue(
    formName: split[0],
    fieldName: split[1],
  );
}

/// Returns current value for any form field.
/// If the form is not disposed and the value was set
/// you can get it here
T? getFieldValue<T>({
  required String formName,
  required String fieldName,
  bool applySerializer = false,
}) {
  return liteFormController.tryGetValueForField(
    formName: formName,
    fieldName: fieldName,
    applySerializer: applySerializer,
  ) as T?;
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

LiteFormsConfiguration? get formConfig {
  return liteFormController.config;
}

/// Returns current data for a form
/// [formName] the name of the form you want to get the data for
///
/// [applySerializers] by default it calls a serializer on every field
/// before putting it to the form. Pass false if you need to get raw form data
Future<Map<String, dynamic>> getFormData({
  required String formName,
  bool applySerializers = true,
}) async {
  return liteFormController.getFormData(
    formName: formName,
    applySerializers: applySerializers,
  );
}

LiteFormController get liteFormController {
  return findController<LiteFormController>();
}
