import 'dart:async';

import 'package:lite_forms/utils/exports.dart';

/// This validator type supports asynchronous validation
/// It might come useful e.g. if you need to make some backend validation of
/// the data entered into your form. With this validator
/// you don't have to invent a custom approach to validate anything. Just
/// do all of your asynchronous work inside the validator's body and
/// then return the result.
/// [returns] Returns an error text if the validation fails.
/// If it returns null then the validation is successful
typedef LiteFormFieldValidator<T> = FutureOr<String?> Function(T? value);

String? nonValidatingValidator(Object? value) {
  return null;
}

class LiteValidators {
  static String? positiveNumber(Object? value) {
    final doubleValue = value.toString().toDoubleAmount();
    if (doubleValue <= 0.0) {
      return 'Amount must be positive';
    }
    return null;
  }
}
