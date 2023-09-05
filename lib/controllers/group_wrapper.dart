part of 'lite_form_controller.dart';

class _FormGroupWrapper {
  final Map<String, FormGroupField> _fields = {};

  /// required to call native validators
  FormState? _formState;

  FormGroupField<T> tryRegisterField<T>({
    required String name,
    required LiteFormValueSerializer serializer,
  }) {
    if (!_fields.containsKey(name)) {
      _fields[name] = FormGroupField<T>(
        name: name,
      );
    }
    _fields[name]?._serializer = serializer;
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

  bool validate() {
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
  LiteFormValueSerializer? _serializer;

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

  void updateValue(Object? value) {
    _value = value;
  }

  Object? get serializedValue {
    return _serializer?.call(_value) ?? _value;
  }

  FormGroupField({
    required this.name,
  });
}
