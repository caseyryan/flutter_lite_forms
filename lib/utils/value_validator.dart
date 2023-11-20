import 'dart:async';

import 'package:lite_forms/base_form_fields/lite_file_picker.dart';
import 'package:lite_forms/base_form_fields/lite_phone_input_field.dart';
import 'package:lite_forms/utils/age_difference.dart';
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

  static LiteValidator dateOfBirth({
    int? minAgeYears,
    int? maxAgeYears,
    int? minAgeMonths,
    int? maxAgeMonths,
    String? errorText,
  }) {
    return DateOfBirthValidator(
      errorText: errorText,
      maxAgeMonths: maxAgeMonths,
      minAgeMonths: minAgeMonths,
      minAgeYears: minAgeYears,
      maxAgeYears: maxAgeYears,
    );
  }

  static LiteValidator required({
    String? errorText,
  }) {
    return RequiredFieldValidator(
      errorText: errorText,
    );
  }

  static LiteValidator alwaysComplaining() {
    return AlwaysComplainingTestValidator();
  }
}

/// This validator can be used if you want to test errors in your form
/// I will always return an error
class AlwaysComplainingTestValidator extends LiteValidator {
  static int _index = 0;

  static const List<String> _reasons = [
    'Something is wrong with this field',
    'I don\'t like this',
    'Invalid value',
    'I still don\'t like this',
    'Try another one',
    'I\'m afraid this won\'t do',
    'Are you kidding?',
    'Nah, this one is not good',
  ];

  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    final error = _reasons[_index];
    _index++;
    if (_index >= _reasons.length) {
      _index = 0;
    }
    return error;
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

class DateOfBirthValidator extends LiteValidator {
  DateOfBirthValidator({
    this.minAgeYears,
    this.maxAgeYears,
    this.minAgeMonths,
    this.maxAgeMonths,
    this.errorText,
  });

  final int? minAgeYears;
  final int? maxAgeYears;
  final int? minAgeMonths;
  final int? maxAgeMonths;
  final String? errorText;

  bool get _isRequired {
    return minAgeMonths != null ||
        minAgeYears != null ||
        maxAgeMonths != null ||
        minAgeMonths != null;
  }

  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    if (!_isRequired) {
      return null;
    }
    if (value == null) {
      return errorText ?? '$fieldName is required';
    }
    if (value is DateTime) {
      final difference = AgeDifference.fromNow(value);
      final diffMonth = difference.months;
      final diffYears = difference.years;
      if (maxAgeYears != null) {
        if (diffYears > maxAgeYears!) {
          return errorText ?? 'You must not be older than $maxAgeYears years';
        }
      }
      if (minAgeYears != null) {
        if (diffYears < minAgeYears!) {
          return errorText ?? 'You must be at least $minAgeYears years old';
        }
      }

      if (maxAgeMonths != null) {
        if (diffMonth > maxAgeMonths!) {
          return errorText ?? 'You must not be older than $maxAgeMonths months';
        }
      }
      if (minAgeMonths != null) {
        if (diffMonth < minAgeMonths!) {
          return errorText ?? 'You must be at least $minAgeMonths months old';
        }
      }
    }
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
  }) : assert(megaBytes >= 0 &&
            kiloBytes >= 0 &&
            (kiloBytes > 0 || megaBytes > 0));

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
  RequiredFieldValidator({
    this.errorText,
  });
  final String? errorText;

  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    if (value == null || (value is bool && value == false)) {
      return errorText ?? '$fieldName is required';
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
