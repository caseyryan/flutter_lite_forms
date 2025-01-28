import 'dart:async';

import 'package:lite_forms/lite_forms.dart';

/// used to write custom value serializers / deserializers
typedef LiteFormValueSerializer = FutureOr<Object?> Function(dynamic value);
typedef LiteFormValueDeserializer = Object? Function(dynamic value);

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

  static Future<List<List<int>>> liteFilesToBytes(
    Object? value,
  ) async {
    if (value is LiteFile) {
      final bytes = await value.getBytesAsync as List<int>;
      return [bytes];
    } else if (value is List) {
      final tempList = <List<int>>[];
      for (var file in value) {
        if (file is LiteFile) {
          final wrapper = await liteFilesToBytes(file);
          tempList.addAll(wrapper);
        }
      }
      return tempList;
    }
    return const [];
  }

  static FutureOr<Object?> filesToMapList(Object? value) async {
    if (value is LiteFile) {
      return await value.toMapAsync();
    } else if (value is List) {
      final tempList = <Map>[];
      for (var file in value) {
        if (file is LiteFile) {
          final wrapper = await filesToMapList(file);
          tempList.add(wrapper as Map);
        }
      }
      return tempList;
    }
    return null;
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

  static Map? fullPhoneDataWithCountry(Object? value) {
    if (value is String) {
      return {
        'phone': value,
      };
    } else if (value is PhoneData) {
      return {
        'phone': value.fullUnformattedPhone,
        'country': value.countryData?.toMap(),
      };
    }

    return {
      'phone': value?.toString(),
    };
  }
}
