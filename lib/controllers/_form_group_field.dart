// ignore_for_file: unused_field, empty_catches, prefer_final_fields

part of 'lite_form_controller.dart';

class FormGroupField<T> {
  final String name;
  String? label;
  LiteFormValueSerializer? _serializer;
  List<LiteValidator>? _validators;
  AutovalidateMode? _autovalidateMode;
  InputDecoration? _decoration;
  _FormGroupWrapper? _parent;

  void updateValidatorsAndSerializer({
    required List<LiteValidator>? validators,
    required LiteFormValueSerializer? serializer,
  }) {
    _serializer = serializer;
    _validators = validators;
  }

  IPreprocessor? preprocessor;
  String? _formName;
  String get formName => _formName ?? '';

  /// it is set and unset automatically
  /// The context is required to be able to scroll to
  /// the first invalid field
  BuildContext? _context;

  bool get hasContext {
    return _context != null;
  }

  bool _isMounted = false;
  bool get isMounted => _isMounted;

  /// This is used to automatically exclude
  /// unregistered fields from
  /// the final form data
  bool _isRemoved = false;
  bool get isRemoved => _isRemoved;

  ValueChanged<TextSelection?>? onSelectionChange;

  void unmount() {
    _isMounted = false;
    _context = null;
  }

  void mount([
    BuildContext? context,
  ]) {
    _context = context;
    _isMounted = true;
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
    _onSelectionChange(_textEditingController?.selection);
  }

  void _onSelectionChange(TextSelection? value) {
    if (value != _selection) {
      _selection = value;
      onSelectionChange?.call(value);
    }
  }

  TextSelection? _selection;
  TextSelection? get selection => _selection;
  String _lastTextValue = '';
  FocusNode? _focusNode;
  FocusNode? get focusNode => _focusNode;
  bool _canDisposeFocusNode = true;

  void requestFocus() {
    if (_focusNode != null) {
      _focusNode!.requestFocus();
    } else {
      final ignoredName = name.toFormIgnoreName();
      final ignoredMirrorField = liteFormController.tryGetField(
        formName: formName,
        fieldName: ignoredName,
      );
      ignoredMirrorField?.requestFocus();
    }
  }

  void unfocus({
    UnfocusDisposition disposition = UnfocusDisposition.scope,
  }) {
    _focusNode?.unfocus(
      disposition: disposition,
    );
  }

  bool get hasFocus {
    if (!isMounted) {
      return false;
    }
    return _focusNode?.hasFocus == true;
  }

  /// Sometimes it's necessary to know current field index
  /// to be able to focus next one, in case a field might lose
  /// focus for some time.
  ///
  /// e.g. [LiteDatePicker] uses this
  int get focusIndex {
    final allFields = liteFormController
        .getAllFieldsOfForm(
          formName: _formName!,
          mountedOnly: true,
        )
        .toList();
    return allFields.indexOf(this);
  }

  FocusNode? getOrCreateFocusNode({
    FocusNode? focusNode,
  }) {
    if (_focusNode != null) {
      return _focusNode;
    }
    if (_focusNode != null) {
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

  Object? getValue([
    bool applySerializer = false,
  ]) {
    final rawValue = _value;
    if (applySerializer) {
      return getSerializedValue();
    }
    return rawValue;
  }

  /// [view] is a String that will be displayed
  /// to a user. This must be null for text inputs
  /// since they are updated on user input but for
  /// other inputs e.g. a LiteDatePicker this must be a
  /// formatted date representation
  void onChange(
    dynamic value, [
    bool isInitialValue = false,
    String? view,
  ]) {
    _value = value;
    if (value != null) {
      _isInitiallySet = true;
      if (isInitialValue) {
        /// Some fields might have a preprocessor
        /// e.g. [LitePhoneInputField]
        if (preprocessor != null) {
          try {
            _value = preprocessor!.preprocess(value);
          } catch (e) {}
          view = preprocessor?.view;
        }

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          try {
            textEditingController?.text = view ?? _value.toString();
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
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
      case AutovalidateMode.onUnfocus:
        break;
    }
    return false;
  }

  Future _checkError() async {
    if (isRemoved) {
      _error = null;
      return;
    }
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
    return _error;
  }

  bool get hasError {
    return _error?.isNotEmpty == true;
  }

  void _setError(String? error) {
    _error = error;
  }

  Future<Object?> getSerializedValue() async {
    return await _serializer?.call(_value) ?? _value;
  }

  FormGroupField({
    required this.name,
    required this.label,
  });
}
