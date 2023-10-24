import 'package:lite_forms/lite_forms.dart';

/// used to write custom value serializers / deserializers
typedef LiteFormValueSerializer = Object? Function(dynamic value);

/// The default for all fields. This means that the values is
/// supposed to be accepted as is. If you need to convert the
/// value somehow, write your custom serializer for a particular field
Object? nonConvertingValueConvertor(Object? value) {
  return value;
}

/// [LiteSerializers] is a set of built-in serializers
/// that can be used to simplify a work with some types of values
class LiteSerializers {
  /// [toDouble] assumes that the input is numeric or
  /// it is a string that has a numeric format and tries to convert it
  /// to a [double] value
  static double toDouble(Object? value) {
    if (value is double) {
      return value;
    } else if (value is String) {
      return value.toString().toDoubleAmount();
    }
    return 0.0;
  }

  static int toInt(Object? value) {
    return toDouble(value).toInt();
  }

  static String? phoneDataToFormattedString(Object? value) {
    if (value is String) {
      return value;
    } else if (value is PhoneData) {
      return value.fullPhone;
    }

    return value?.toString();
  }
  static String? phoneDataToUnformattedString(Object? value) {
    if (value is String) {
      return value;
    } else if (value is PhoneData) {
      return value.fullUnformattedPhone;
    }

    return value?.toString();
  }
}
