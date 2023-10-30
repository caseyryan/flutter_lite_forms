import 'dart:async';

import 'package:lite_forms/base_form_fields/lite_file_picker.dart';
import 'package:lite_forms/base_form_fields/lite_phone_input_field.dart';
import 'package:lite_forms/utils/exports.dart';
import 'package:lite_forms/utils/number_extension.dart';

abstract class LiteValidator {
  /// This validator type supports asynchronous validation
  /// It might come useful e.g. if you need to make some backend validation of
  /// the data entered into your form. With this validator
  /// you don't have to invent a custom approach to validate anything. Just
  /// do all of your asynchronous work inside the validator's body and
  /// then return the result.
  /// [returns] Returns an error text if the validation fails.
  /// If it returns null then the validation is successful
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  });

  /// A shorthand method. You can also use [PhoneValidator] directly
  static LiteValidator phone() {
    return PhoneValidator();
  }

  static LiteValidator required() {
    return RequiredFieldValidator();
  }
}

class NonValidatingValidator extends LiteValidator {
  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    return null;
  }
}

class PositiveNumberValidator extends LiteValidator {
  final String? errorText;
  PositiveNumberValidator({
    this.errorText,
  });

  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    final doubleValue = value.toString().toDoubleAmount();
    if (doubleValue <= 0.0) {
      return errorText ?? 'Amount must be positive';
    }
    return null;
  }
}

class PhoneValidator extends LiteValidator {
  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    if (value == null || value is! PhoneData) {
      return 'A phone is required';
    }
    if (value.isValid != true) {
      return 'A phone is invalid';
    }
    return null;
  }
}

class FileSize {
  final int megaBytes;
  final int kiloBytes;
  FileSize({
    this.megaBytes = 5,
    this.kiloBytes = 0,
  }) : assert(megaBytes >= 0 && kiloBytes >= 0 && (kiloBytes > 0 || megaBytes > 0));

  int get totalKilobytes {
    return megaBytes * 1024 + kiloBytes;
  }

  @override
  String toString() {
    if (megaBytes > 0 && kiloBytes > 0) {
      return '${megaBytes}Mb, ${kiloBytes}Kb';
    } else if (megaBytes > 0) {
      return '${megaBytes}Mb';
    } else if (kiloBytes > 0) {
      return '${kiloBytes}Kb';
    }
    return super.toString();
  }
}

class RequiredFieldValidator extends LiteValidator {
  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    if (value == null) {
      return '$fieldName is required';
    }
    return null;
  }
}

class FileSizeValidator extends LiteValidator {
  FileSizeValidator({
    required this.maxSize,
  });
  final FileSize maxSize;

  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) async {
    if (value is List) {
      for (var file in value) {
        if (file is LiteFile) {
          final LiteFile liteFile = file;
          final kb = await liteFile.kiloBytes;
          if (kb > maxSize.totalKilobytes) {
            return 'Some file exceeds the maximum size of ${maxSize.toString()}, actual size is ${kb.kilobytesToLabel()}';
          }
        }
      }
    } else if (value is LiteFile) {
      final LiteFile liteFile = value;
      final kb = await liteFile.kiloBytes;
      if (kb > maxSize.totalKilobytes) {
        return 'Some file exceeds the maximum size of ${maxSize.toString()}, actual size is ${kb.kilobytesToLabel()}';
      }
    }
    return null;
  }
}
