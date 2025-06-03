// ignore_for_file: empty_catches, unused_field
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

  final bool autoRemoveUnregisteredFields;

  _FormGroupWrapper({
    required this.autoRemoveUnregisteredFields,
  });

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
    required String formName,
    required String? label,
    required LiteFormValueSerializer serializer,
    required List<LiteValidator>? validators,
    required AutovalidateMode? autovalidateMode,
    required InputDecoration? decoration,
    required ViewConverter? viewConverter,
  }) {
    if (_fields[name] == null) {
      _fields[name] = FormGroupField<T>(
        name: name,
        label: label,
      );
    }
    final field = _fields[name]! as FormGroupField<T>;
    field._serializer = serializer;
    field._validators = validators;
    field._formName = formName;
    field._viewConverter = viewConverter;
    field._autovalidateMode = autovalidateMode;
    field._parent = this;
    field._decoration = decoration;
    field.mount();
    return _fields[name] as FormGroupField<T>;
  }

  void unregisterField({
    required String fieldName,
  }) {
    _fields.remove(fieldName);
  }

  FormGroupField? tryFindField(String fieldName) {
    return _fields[fieldName];
  }

  Future<Map<String, dynamic>> getFormData(
    bool applySerializers,
  ) async {
    final map = <String, dynamic>{};
    for (var kv in _fields.entries) {
      if (kv.key.isIgnoredInForm() || kv.value._isRemoved) {
        continue;
      }
      if (applySerializers) {
        map[kv.key] = await kv.value.getSerializedValue();
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
        tryScrollFormToField(field: field);
        return false;
      }
    }
    return result ?? true;
  }

  FormGroupField? findFirstInvalidField() {
    return _fields.values.firstWhereOrNull(
      (field) => field.hasError,
    );
  }

  Size get screenSize {
    var view = WidgetsBinding.instance.platformDispatcher.views.first;
    return view.physicalSize / view.devicePixelRatio;
  }

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  Future scrollToFirstInvalidField([
    Duration? duration,
  ]) async {
    return tryScrollFormToField(
      duration: duration,
    );
  }

  /// Scrolls the form to the field if it is mounted
  /// [field] if null, it will try to find the first field with an error
  /// [duration] scroll animation duration
  Future tryScrollFormToField({
    FormGroupField? field,
    Duration? duration,
  }) async {
    field ??= findFirstInvalidField();
    if (field?.hasContext == true) {
      final scrollController =
          LiteForm.of(field!._context!)?.scrollController;
      if (scrollController?.hasClients == true) {
        final renderObject = field._context!.findRenderObject();
        if (renderObject is RenderBox) {
          final fieldPositionY =
              renderObject.getTransformTo(null).getTranslation().y;
          // final fieldHeight = renderObject.size.height;
          var curScrollPosition = scrollController!.position.pixels;
          var maxScrollExtent = scrollController.position.maxScrollExtent;

          double toYPos = screenHeight * .45;
          final scrollBy = toYPos - fieldPositionY;
          if (scrollBy != 0) {
            double offset =
                (curScrollPosition - scrollBy).clamp(0.0, maxScrollExtent);
            await scrollController.animateTo(
              offset,
              duration: duration ?? kThemeAnimationDuration,
              curve: Curves.linear,
            );
          }
        }
      } else {
        debugPrint('SCROLL CONTROLLER OF THE FORM ${field.formName} IS NOT ATTACHED TO ANY SCROLL VIEWS');
      }
    }
  }

  void clearDependencies() {
    for (var f in _fields.values) {
      f.clearDependencies();
    }
    _formState = null;
  }
}
