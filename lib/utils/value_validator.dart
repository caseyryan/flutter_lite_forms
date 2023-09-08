import 'dart:async';

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