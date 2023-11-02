import 'package:lite_forms/base_form_fields/lite_phone_input_field.dart';

/// Some form fields might require an initial data
/// that is used in a value preparation, e.g. a [LitePhoneInputField] 
/// might require country data, phone code etc. It utilizes a 
/// custom [IPreprocessor] to set all that data before changing a value
/// The preprocessor is connected to its field 
/// and does not depend on a widget's state
/// 
/// See an example in [LitePhoneInputField]
abstract class IPreprocessor {
  /// [preprocess] is called internally before setting a field value
  /// if the preprocessor is connected to the field
  Object? preprocess(Object? value);
  /// It's a value that is displayed on a field UI. 
  /// Some fields use complex data but use strings to display it
  /// e.g. [LitePhoneInputField] returns PhoneData but uses a String phone 
  /// on the UI
  String? get view;
}