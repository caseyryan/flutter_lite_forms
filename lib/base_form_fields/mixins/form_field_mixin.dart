import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/lite_form_group.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/utils/string_extensions.dart';
import 'package:lite_forms/utils/value_serializer.dart';
import 'package:lite_forms/utils/value_validator.dart';

typedef OnChanged = Function(Object? value);

mixin FormFieldMixin<T extends StatefulWidget> on State<T> {
  LiteFormGroup? _group;
  LiteFormGroup get group => _group!;

  late final FormGroupField field;
  late final String _fieldName;
  String? _label;

  dynamic _initialValue;
  dynamic get initialValue {
    return _initialValue;
  }

  String? hintText;
  TextStyle? _errorStyle;

  String get formName => group.name;

  InputDecoration? _decoration;
  InputDecoration get decoration => _decoration!;
  bool _isInitialized = false;

  TextEditingController? get textEditingController {
    return field.getOrCreateTextEditingController();
  }

  void onFocusChange() {
    print('FOCUS CHANGE ${field.name}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reactivate();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    _reactivate();
  }

  @override
  void activate() {
    super.activate();
    _reactivate();
  }

  @override
  void initState() {
    super.initState();
    _reactivate();
  }

  @override
  void reassemble() {
    super.reassemble();
    _reactivate();
  }

  void _reactivate() {
    if (_isInitialized) {
      field.mount(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_isInitialized) {
      field.unmount();
      if (field.focusNode != null) {
        field.focusNode?.removeListener(onFocusChange);
      }
    }
  }

  /// Checks if a field is initially set to not let it
  /// set initially again
  bool setInitialValue({
    required String formName,
    required String fieldName,
    required VoidCallback setter,
  }) {
    if (!liteFormController.isFieldInitiallySet(
      formName: formName,
      fieldName: fieldName,
    )) {
      setter();
      return true;
    }
    return false;
  }

  void tryDeserializeInitialValueIfNecessary<E>({
    required Object? rawInitialValue,
    required LiteFormValueSerializer? initialValueDeserializer,
  }) {
    final storedValue = liteFormController.tryGetValueForField(
      formName: group.name,
      fieldName: _fieldName,
    ) as E?;
    if (E == String) {
      _initialValue =
          storedValue ?? initialValueDeserializer?.call(rawInitialValue)?.toString() ?? rawInitialValue?.toString();
    } else {
      _initialValue = storedValue ?? initialValueDeserializer?.call(rawInitialValue) as E? ?? rawInitialValue as E?;
    }
  }

  void initializeFormField<E>({
    required String fieldName,
    required String? label,
    required AutovalidateMode? autovalidateMode,
    required LiteFormValueSerializer serializer,
    required LiteFormValueSerializer? initialValueDeserializer,
    required List<LiteValidator>? validators,
    required String? hintText,
    required InputDecoration? decoration,
    required TextStyle? errorStyle,
    required FocusNode? focusNode,

    /// [addFocusNodeListener] must be false your field contains more basic form fields inside
    /// to avoid focus interception. E.g. [LiteFilePicker]
    bool addFocusNodeListener = true,
  }) {
    assert(
      widget.key != null,
      'You must add a key to your Form Field widget',
    );

    _group = LiteFormGroup.of(context)!;
    _label = label;

    this._decoration = decoration ?? formConfig?.inputDecoration ?? const InputDecoration();
    this.hintText = group.translationBuilder(hintText);
    if (hintText?.isNotEmpty != true) {
      if (formConfig?.useAutogeneratedHints == true) {
        this.hintText = fieldName.splitByCamelCase();
      }
    }
    if (this.hintText?.isNotEmpty == true) {
      this._decoration = this._decoration?.copyWith(
            hintText: this.hintText,
          );
    }

    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets? decorationContentPadding = this._decoration!.contentPadding?.resolve(textDirection);

    final EdgeInsets? contentPadding;
    final decorationIsDense = this._decoration!.isDense == true;
    final bool isError = this._decoration!.errorText != null;
    InputBorder? border;
    if (!this._decoration!.enabled) {
      border = isError ? this._decoration!.errorBorder : this._decoration!.disabledBorder;
    } else {
      border = isError ? this._decoration!.errorBorder : this._decoration!.enabledBorder;
    }
    if (this._decoration?.isCollapsed == true) {
      contentPadding = decorationContentPadding ?? EdgeInsets.zero;
    } else if (border?.isOutline != true) {
      if (this._decoration?.filled == true) {
        contentPadding = decorationContentPadding ??
            (decorationIsDense
                ? const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0)
                : const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0));
      } else {
        contentPadding = decorationContentPadding ??
            (decorationIsDense
                ? const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0)
                : const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0));
      }
    } else {
      contentPadding = decorationContentPadding ??
          (decorationIsDense
              ? const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0)
              : const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 16.0));
    }
    this._decoration = this._decoration?.copyWith(
          contentPadding: contentPadding,
        );

    if (!_isInitialized) {
      _isInitialized = true;
      _errorStyle = errorStyle;
      _fieldName = fieldName;
      field = liteFormController.registerFormFieldIfNone<E>(
        fieldName: _fieldName,
        formName: group.name,
        label: _label,
        serializer: serializer,
        validators: validators,
        decoration: decoration,
        autovalidateMode: autovalidateMode,
      );
    } else {
      _reactivate();
    }
    field.updateValidatorsAndSerializer(
      validators: validators,
      serializer: serializer,
    );

    if (addFocusNodeListener) {
      /// this is required to be able to iterate through form
      /// focus nodes
      final node = field.getOrCreateFocusNode(
        focusNode: focusNode,
      );
      node?.removeListener(_updateFocus);
      node?.addListener(_updateFocus);
    }
  }

  // int _lastFocusChangeMillis = 0;
  void _updateFocus() {
    // print('UPDATE FOCUS');
    if (field.focusNode == null) {
      return;
    }

    onFocusChange();
  }

  TextStyle get errorStyle {
    return _errorStyle ??
        formConfig?.inputDecoration?.errorStyle ??
        TextStyle(color: Theme.of(context).colorScheme.error);
  }
}
