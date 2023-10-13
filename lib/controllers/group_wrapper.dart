// ignore_for_file: empty_catches
/*
(c) Copyright 2020 Serov Konstantin.

Licensed under the MIT license:

    http://www.opensource.org/licenses/mit-license.php

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
part of 'lite_form_controller.dart';

class _FormGroupWrapper {
  final Map<String, FormGroupField> _fields = {};

  /// required to call native validators
  FormState? _formState;

  bool get isBeingValidated {
    return _fields.values.any((e) => e._isBeingValidated);
  }

  bool isFieldInitiallySet(String fieldName) {
    final FormGroupField? field = _fields[fieldName];
    return field?.isInitiallySet == true;
  }

  FormGroupField<T> tryRegisterField<T>({
    required String name,
    required LiteFormValueConvertor serializer,
    required List<LiteFormFieldValidator<Object?>>? validators,
    required AutovalidateMode? autovalidateMode,
    required InputDecoration? decoration,
  }) {
    if (kDebugMode) {
      print('TRY REGISTER FIELD: $name');
    }
    if (!isFieldInitiallySet(name)) {
      _fields[name] = FormGroupField<T>(
        name: name,
      );
    }
    final field = _fields[name]! as FormGroupField<T>;
    field._serializer = serializer;
    field._validators = validators;
    field._autovalidateMode = autovalidateMode;
    field._parent = this;
    field._decoration = decoration;
    field._updatedAt = DateTime.now();
    return _fields[name] as FormGroupField<T>;
  }

  void unregisterField({
    required String fieldName,
  }) {
    _fields.remove(fieldName);
  }

  void unregisterFieldIfOutdated({
    required FormGroupField field,
  }) {
    if (field._isOutdated() == true) {
      unregisterField(fieldName: field.name);
    }
  }

  void unregisterAllOutdatedFields() {
    final tempFields = [..._fields.values];
    for (var field in tempFields) {
      unregisterFieldIfOutdated(field: field);
    }
  }

  FormGroupField? tryFindField(String fieldName) {
    return _fields[fieldName];
  }

  Map<String, dynamic> getFormData(
    bool applySerializers,
  ) {
    final map = <String, dynamic>{};
    for (var kv in _fields.entries) {
      if (applySerializers) {
        map[kv.key] = kv.value.serializedValue;
      } else {
        map[kv.key] = kv.value;
      }
    }
    return map;
  }

  Future<bool> validate() async {
    for (var field in _fields.values) {
      /// casting field to a dynamic is a required hack to
      /// disable flutter runtime type check for its validator
      /// which will never pass
      await field._checkError();
    }

    /// This call will trigger inner form validators
    /// that will catch the possible errors from asynchronous validators
    return _validateNativeForm();
  }

  bool _validateNativeForm() {
    /// native form might be valid but custom fields
    /// (that are not based on Flutter's form fields) might still
    /// contain errors
    final result = _formState?.validate();
    for (var field in _fields.values) {
      if (field._error?.isNotEmpty == true) {
        return false;
      }
    }
    return result ?? true;
  }

  void clearDependencies() {
    for (var f in _fields.values) {
      f.clearDependencies();
    }
    _formState = null;
  }
}

class FormGroupField<T> {
  final String name;
  LiteFormValueConvertor? _serializer;
  List<LiteFormFieldValidator<Object?>>? _validators;
  AutovalidateMode? _autovalidateMode;
  InputDecoration? _decoration;
  _FormGroupWrapper? _parent;

  /// This allows us to unregister the fields that were not
  /// registered during this build stage. E.e. you removed
  /// a field by some condition. This filed might be automatically removed from
  /// form
  DateTime? _updatedAt;

  bool _isOutdated() {
    if (_updatedAt == null) {
      return false;
    }
    return DateTime.now().difference(_updatedAt!).inMilliseconds > 60;
  }

  TextEditingController? _textEditingController;
  TextEditingController? get textEditingController => _textEditingController;
  bool _canDisposeController = true;

  TextEditingController? getOrCreateTextEditingController({
    TextEditingController? controller,
  }) {
    if (_textEditingController != null) {
      return _textEditingController;
    }
    if (controller != null) {
      _canDisposeController = false;
      _textEditingController = controller;
    } else {
      _textEditingController = TextEditingController();
    }
    return _textEditingController;
  }

  void clearDependencies() {
    if (_canDisposeController) {
      _textEditingController?.dispose();
    }
    _textEditingController = null;
  }

  bool _isInitiallySet = false;

  bool get isInitiallySet {
    return _isInitiallySet;
  }

  Object? _value;
  Object? get value {
    return _value;
  }

  /// [view] is a String that will be displayed
  /// to a user. This must be null for text inputs
  /// since they are updated on user input but for
  /// other inputs e.g. a LiteDatePicker this must be a
  /// formatted date representation
  void onChange(
    Object? value, [
    bool isInitialValue = false,
    String? view,
  ]) {
    _value = value;
    if (value != null) {
      if (isInitialValue) {
        _isInitiallySet = true;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          try {
            textEditingController?.text = view ?? _value.toString();
          } catch (e) {}
        });
      } else {
        if (view != null) {
          textEditingController?.text = view;
        }
      }
    }
    if (_isSelfValidating && !isInitialValue) {
      _checkError().then((value) {
        return _parent?._validateNativeForm();
      });
    }
  }

  void _validateOnlyAlwaysValidating() {
    if (_autovalidateMode == AutovalidateMode.always) {
      _checkError().then((value) {
        return _parent?._validateNativeForm();
      });
    }
  }

  int _numValidations = 0;

  bool get _isBeingValidated => _numValidations > 0;

  bool get _isSelfValidating {
    switch (_autovalidateMode) {
      case AutovalidateMode.disabled:
      case null:
        return false;
      case AutovalidateMode.always:
      case AutovalidateMode.onUserInteraction:
        return true;
    }
  }

  Future _checkError() async {
    _numValidations++;
    dynamic fieldAsDynamic = this as dynamic;
    final lastError = _error;
    String? error;
    List? validators = fieldAsDynamic._validators as List? ?? const [];
    for (var validator in validators) {
      error = await validator.call(_value);
      if (error != null) {
        break;
      }
    }
    _setError(error?.toString());
    _numValidations--;
    if (error != lastError) {
      liteFormController.rebuild();
    }
  }

  String? _error;
  String? get error => _error;
  void _setError(String? error) {
    _error = error;
  }

  Object? get serializedValue {
    return _serializer?.call(_value) ?? _value;
  }

  FormGroupField({
    required this.name,
  });
}
