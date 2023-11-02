// ignore_for_file: library_private_types_in_public_api

part of 'lite_form_controller.dart';

/// example of usage form('signup.firstName').field.get();
_FormShorthand form(String path) {
  return _FormShorthand.fromPath(path);
}

class _FormShorthand {
  final String formName;
  final String fieldName;

  _FormShorthand._({
    required this.formName,
    required this.fieldName,
  });

  factory _FormShorthand.fromPath(String path) {
    final split = path.split('.');
    return _FormShorthand._(
      formName: split[0],
      fieldName: split[1],
    );
  }

  /// General field expects the exact data type
  /// which it stores
  _GeneralFieldShorthand get field {
    final formField = liteFormController.tryGetField(
      formName: formName,
      fieldName: fieldName,
    );
    return _GeneralFieldShorthand().._formField = formField;
  }

  _PhoneFieldShorthand get phone {
    final formField = liteFormController.tryGetField(
      formName: formName,
      fieldName: fieldName,
    );
    return _PhoneFieldShorthand().._formField = formField;
  }
}

class _PhoneFieldShorthand {
  FormGroupField? _formField;

  T? get<T>([
    bool serialize = false,
  ]) {
    return _formField?.getValue(serialize) as T?;
  }

  /// Usage example
  /// form('signupForm.phone').phone.set('(999) 444 66-77', country: CountryData.find('RU'));
  void set(
    Object? value, {
    CountryData? country,
  }) {
    if (_formField == null) {
      return;
    }
    if (country != null) {
      /// We can be sure that preprocessor here is available
      /// because it is always created for a phone field
      final preprocessor = _formField!.preprocessor as PhonePreprocessor;
      final countryDropSelectorName = _formField!.name.toFormIgnoreName();
      preprocessor.updateCountryData(country);
      final countryField = liteFormController.tryGetField(
        formName: _formField!.formName,
        fieldName: countryDropSelectorName,
      );
      if (countryField != null) {
        liteFormController.onValueChanged(
          formName: _formField!.formName,
          fieldName: countryDropSelectorName,
          value: [country],
          view: null,
          isInitialValue: true,
        );
        
      }
    }

    liteFormController.onValueChanged(
      formName: _formField!.formName,
      fieldName: _formField!.name,
      value: value,
      view: null,
      isInitialValue: true,
    );
  }
}

class _GeneralFieldShorthand {
  FormGroupField? _formField;

  T? get<T>([
    bool serialize = false,
  ]) {
    return _formField?.getValue(serialize) as T?;
  }

  void set(Object? value) {
    if (_formField == null) {
      return;
    }
    liteFormController.onValueChanged(
      formName: _formField!.formName,
      fieldName: _formField!.name,
      value: value,
      view: null,
      isInitialValue: true,
    );
  }
}
