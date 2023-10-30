// ignore_for_file: unused_field, empty_catches

part of 'lite_form_controller.dart';

class FormGroupField<T> {
  final String name;
  String? label;
  LiteFormValueSerializer? _serializer;
  List<LiteValidator>? _validators;
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
      _textEditingController?.safeSetText(_lastTextValue);
    } else {
      _textEditingController = TextEditingController(
        text: _lastTextValue,
      );
    }
    _textEditingController?.addListener(_onTextUpdate);
    return _textEditingController;
  }

  void _onTextUpdate() {
    _lastTextValue = _textEditingController?.text ?? '';
  }

  String _lastTextValue = '';
  FocusNode? _focusNode;
  FocusNode? get focusNode => _focusNode;
  bool _canDisposeFocusNode = true;

  FocusNode? getOrCreateFocusNode({
    FocusNode? focusNode,
  }) {
    if (_textEditingController != null) {
      return _focusNode;
    }
    if (focusNode != null) {
      _canDisposeFocusNode = false;
      _focusNode = focusNode;
    } else {
      _focusNode = FocusNode();
    }
    return _focusNode;
  }

  void clearDependencies() {
    _textEditingController?.removeListener(
      _onTextUpdate,
    );
    if (_canDisposeController) {
      _textEditingController?.dispose();
    }
    _textEditingController = null;
    if (_canDisposeFocusNode) {
      _focusNode?.dispose();
    }
    _focusNode = null;
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
      _isInitiallySet = true;
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
      error = await validator.validate(
        _value,
        fieldName: label ?? name,
      );
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
  String? get error {
    print('$name, ERROR: $_error');
    return _error;
  }
  void _setError(String? error) {
    _error = error;
    print('SETTING ERROR $_error');
  }

  Future<Object?> getSerializedValue() async {
    return await _serializer?.call(_value) ?? _value;
  }

  FormGroupField({
    required this.name,
    required this.label,
  });
}
