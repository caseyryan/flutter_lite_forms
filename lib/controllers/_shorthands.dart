// ignore_for_file: library_private_types_in_public_api

part of 'lite_form_controller.dart';

/// example of usage form('signup.firstName').field.get();
_FormShorthand form(String formGroupName) {
  return _FormShorthand.fromFormName(formGroupName);
}

class _FormShorthand {
  final String formName;
  // final String fieldName;

  _FormShorthand._({
    required this.formName,
    // required this.fieldName,
  });

  /// Just requests a focus on a field next to
  /// the current focused one. If non is focused
  /// it will request a focus on the first field
  void focusNextField([
    int? startFromIndex,
  ]) {
    final allFields = liteFormController
        .getAllFieldsOfForm(
          formName: formName,
          mountedOnly: true,
          includeIgnored: true,
        )
        .toList();
    if (allFields.isEmpty) {
      return;
    }
    int index = startFromIndex ??
        allFields.indexWhere(
          (e) => e.hasFocus,
        );
    if (index < 0) {
      if (allFields[0].value == null) {
        allFields[0].requestFocus();
      }
    } else {
      index++;
      if (index >= allFields.length) {
        index = 0;
      }
      final field = allFields[index];
      if (field.value == null) {
        field.requestFocus();
      }
    }
  }

  void unfocusAllFields({
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) {
    final allFields = liteFormController.getAllFieldsOfForm(
      formName: formName,
      mountedOnly: true,
    );
    for (var field in allFields) {
      field.unfocus(disposition: disposition);
    }
  }

  void focus(String fieldName) {
    liteFormController
        .tryGetField(
          formName: formName,
          fieldName: fieldName,
        )
        ?.requestFocus();
  }

  /// Returns the name of the field that is currently focused
  /// or null is none is focused
  String? get focusedFieldNameOrNull {
    final allFields = liteFormController
        .getAllFieldsOfForm(
          formName: formName,
          mountedOnly: true,
          includeIgnored: true,
        )
        .toList();
    return allFields.firstWhereOrNull((e) => e.hasFocus)?.name;
  }

  void unfocus(String fieldName) {
    liteFormController
        .tryGetField(
          formName: formName,
          fieldName: fieldName,
        )
        ?.unfocus(
          disposition: UnfocusDisposition.scope,
        );
  }

  factory _FormShorthand.fromFormName(String formGroupName) {
    return _FormShorthand._(
      formName: formGroupName,
    );
  }

  _TimerFieldShorthand timer(String fieldName) {
    return _TimerFieldShorthand(
      formName: formName,
      name: fieldName,
    );
  }

  /// General field expects the exact data type
  /// which it stores
  _GeneralFieldShorthand field(String fieldName) {
    final formField = liteFormController.tryGetField(
      formName: formName,
      fieldName: fieldName,
    );
    return _GeneralFieldShorthand().._formField = formField;
  }

  _PhoneFieldShorthand phone(String fieldName) {
    final formField = liteFormController.tryGetField(
      formName: formName,
      fieldName: fieldName,
    );
    return _PhoneFieldShorthand().._formField = formField;
  }
}

class _TimerFieldShorthand {
  _TimerFieldShorthand({
    required this.name,
    required this.formName,
  });
  final String name;
  final String formName;

  int get seconds {
    return liteTimerController.getNumSecondsLeftByName(
      groupName: formName,
      timerName: name,
    );
  }

  void start() {
    liteTimerController.startTimerByName(
      groupName: formName,
      timerName: name,
    );
  }

  bool get isActive {
    return liteTimerController.getIsActiveState(
      groupName: formName,
      timerName: name,
    );
  }

  void reset({
    int? numSeconds,
    bool forceStart = false,
  }) {
    liteTimerController.resetTimerByName(
      groupName: formName,
      timerName: name,
      forceStart: forceStart,
      numSeconds: numSeconds,
    );
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

  void selectText([
    int start = 0,
    int end = 999999999,
  ]) {
    Future.delayed(const Duration(milliseconds: 50)).then((value) {
      _formField?.textEditingController?.setSelection(
        start,
        end,
      );
    });
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
