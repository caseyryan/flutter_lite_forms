// ignore_for_file: empty_catches

part of 'lite_form_controller.dart';

class _FormGroupWrapper {
  final Map<String, FormGroupField> _fields = {};

  /// required to call native validators
  FormState? _formState;

  bool get isBeingValidated {
    return _fields.values.any((e) => e._isBeingValidated);
  }

  FormGroupField<T> tryRegisterField<T>({
    required String name,
    required LiteFormValueConvertor serializer,
    required LiteFormFieldValidator<T>? validator,
    required AutovalidateMode? autovalidateMode,
  }) {
    if (!_fields.containsKey(name)) {
      _fields[name] = FormGroupField<T>(
        name: name,
      );
    }
    final field = _fields[name]! as FormGroupField<T>;
    field._serializer = serializer;
    field._validator = validator;
    field._autovalidateMode = autovalidateMode;
    field._parent = this;
    return _fields[name] as FormGroupField<T>;
  }

  FormGroupField? tryFindField(String fieldName) {
    return _fields[fieldName];
  }

  Map<String, dynamic> getFormData() {
    final map = <String, dynamic>{};
    for (var kv in _fields.entries) {
      map[kv.key] = kv.value.serializedValue;
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
    return _formState?.validate() ?? true;
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
  LiteFormFieldValidator<T>? _validator;
  AutovalidateMode? _autovalidateMode;
  _FormGroupWrapper? _parent;

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

  Object? _value;

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
    if (_isSelfValidating) {
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
    final error = await fieldAsDynamic._validator?.call(_value);
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
