import 'dart:async';

import 'package:flutter/foundation.dart';
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

  static LiteValidator name() {
    return NameValidator();
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

  static LiteValidator youtube({
    String? errorText,
    bool allowEmpty = false,
  }) {
    return YoutubeUrlValidator(
      errorText: errorText,
      allowEmpty: allowEmpty,
    );
  }

  static LiteValidator email({
    String? errorText,
  }) {
    return EmailValidator();
  }

  static LiteValidator alwaysComplaining({
    int delayMilliseconds = 0,
  }) {
    return AlwaysComplainingTestValidator(
      delayMilliseconds: delayMilliseconds,
    );
  }
}

/// This validator can be used if you want to test errors in your form
/// I will always return an error
class AlwaysComplainingTestValidator extends LiteValidator {
  static int _index = 0;
  AlwaysComplainingTestValidator({
    this.delayMilliseconds = 0,
  });

  /// [delayMilliseconds] if value is greater than zero
  /// the validator
  /// will be asynchronous
  final int delayMilliseconds;

  static const List<String> _reasons = [
    '[TEST] Something is wrong with this field',
    '[TEST] I don\'t like this',
    '[TEST] Invalid value',
    '[TEST] I still don\'t like this',
    '[TEST] Try another one',
    '[TEST] I\'m afraid this won\'t do',
    '[TEST] Are you kidding?',
    '[TEST] Nah, this one is not good',
  ];

  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) async {
    if (delayMilliseconds > 0) {
      await Future.delayed(Duration(milliseconds: delayMilliseconds));
    }
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
    return minAgeMonths != null || minAgeYears != null || maxAgeMonths != null || minAgeMonths != null;
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
      return errorText ?? '${fieldName?.firstToUpper()} is required';
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
    debugPrint('VALIDATING PHONE: $value');
    if (value == null || value is! PhoneData) {
      return 'A phone is required';
    }
    if (value.isValid != true) {
      return 'A phone is invalid';
    }
    return null;
  }
}

final RegExp _emailRegex = RegExp(
    r"^[\w!#$%&'*+\-/=?\^_`{|}~]+(\.[\w!#$%&'*+\-/=?\^_`{|}~]+)*@((([\-\w]+\.)+[a-zA-Z]{2,12})|(([0-9]{1,12}\.){12}[0-9]{1,12}))$");

bool isEmailValid(String value) {
  if (value.isEmpty) return false;
  return _emailRegex.stringMatch(value) != null;
}

class EmailValidator extends LiteValidator {
  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    if (value == null) {
      return '${fieldName?.firstToUpper()} is required';
    }
    if (!isEmailValid(value.toString())) {
      return '${fieldName?.firstToUpper()} is invalid';
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
  RequiredFieldValidator({
    this.errorText,
  });
  final String? errorText;

  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    if (value == null || (value is bool && value == false) || (value is String && value.isEmpty)) {
      return errorText ?? '${fieldName?.firstToUpper()} is required';
    }
    return null;
  }
}

class NameValidator extends LiteValidator {
  final RegExp _nameValidatorRegExp = RegExp(r'^(?!\s)([А-Яа-яA-Za-z- ])+$');
  final RegExp _doubleSpaceRegExp = RegExp(r'\s{2}');
  final RegExp _dashKillerRegExp = RegExp(r'(-{2})|(-[\s]+)|(\s[-]+)');
  final RegExp _lettersRegExp = RegExp(r'[А-Яа-яA-Za-z]+');

  String _lastCharacter(String value) {
    if (value.isEmpty) return '';
    return value[value.length - 1];
  }

  String? _validateName(String? value) {
    if (value?.isNotEmpty != true) {
      return null;
    }
    if (!value!.startsWith(_lettersRegExp)) {
      return 'This field must start with a letter';
    }
    if (!_lettersRegExp.hasMatch(_lastCharacter(value))) {
      return 'This field must end with a letter';
    }

    if (!_nameValidatorRegExp.hasMatch(value.trim())) {
      return 'This field must contain only letters, dashes, or spaces in the middle';
    }

    if (_doubleSpaceRegExp.hasMatch(value)) {
      return 'Only a single space is allowed between words';
    }

    if (_dashKillerRegExp.hasMatch(value)) {
      return 'Only a single dash is allowed between words';
    }

    return null;
  }

  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    if (value is String) {
      if (value.isNotEmpty != true) {
        return '${fieldName?.firstToUpper()} is required';
      }
      final error = _validateName(value.toString());
      if (error?.isNotEmpty == true) {
        return '${fieldName?.firstToUpper()} is required';
      }
    }

    return null;
  }
}

class YoutubeUrlValidator extends LiteValidator {
  static final RegExp _youtubeRegexp = RegExp(r'^https:\/\/www\.youtube\.com\/watch\?v=[a-zA-Z0-9_]+');

  YoutubeUrlValidator({
    this.errorText,
    this.allowEmpty = false,
  });
  final String? errorText;
  final bool allowEmpty;

  @override
  FutureOr<String?> validate(
    Object? value, {
    String? fieldName,
  }) {
    if (value is String && value.isNotEmpty == true) {
      if (!_youtubeRegexp.hasMatch(value)) {
        return errorText ?? '$fieldName must contain a valid YouTube url';
      }
    }
    if (!allowEmpty) {
      return errorText ?? '$fieldName must contain a valid YouTube url';
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


extension _ValidatorStringExtension on String {
  String firstToUpper() {
    if (isEmpty) {
      return this;
    }
    if (length == 1) {
      return toUpperCase();
    }
    final firstPart = substring(0, 1);
    final secondPart = substring(1, length);
    return '${firstPart.toUpperCase()}$secondPart';
  }
} 