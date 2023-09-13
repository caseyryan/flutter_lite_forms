import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_form_rebuild_controller.dart';
import 'package:lite_forms/lite_forms.dart';
import 'package:lite_forms/utils/value_validator.dart';
import 'package:lite_state/lite_state.dart';

enum PasswordFieldCheckType {
  /// if passed, this will create a second line
  /// where user must enter the password again
  repeatPassword,
  validatorOnly,
}

class LitePasswordField extends StatelessWidget {
  const LitePasswordField({
    super.key,
    required this.name,
    required this.settings,
    this.repeatPlaceholder,
    this.useSmoothError = false,
    this.smoothErrorPadding = const EdgeInsets.only(
      top: 6.0,
    ),
    this.hintText,
    this.passwordFieldCheckType = PasswordFieldCheckType.repeatPassword,
    // this.validator,
    this.controller,
    this.restorationId,
    this.initialValue,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = true,
    this.enableSuggestions = true,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  });

  final PasswordFieldCheckType passwordFieldCheckType;
  final String name;
  final String? repeatPlaceholder;
  final String? hintText;
  final TextEditingController? controller;
  final PasswordSettings settings;

  /// makes sense only of [useSmoothError] is true
  final EdgeInsets? smoothErrorPadding;
  final bool useSmoothError;
  final String? restorationId;
  final Object? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool enableSuggestions;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  bool get _isDoubleLine {
    return passwordFieldCheckType == PasswordFieldCheckType.repeatPassword;
  }

  bool get _buildChecker {
    return settings.requirements != null;
  }

  @override
  Widget build(BuildContext context) {
    final repeatName = repeatPlaceholder ?? 'Confirm $name';
    final group = LiteFormGroup.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiteTextFormField(
          name: name,
          autocorrect: false,
          autofillHints: autofillHints,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          contextMenuBuilder: contextMenuBuilder,
          buildCounter: buildCounter,
          controller: controller,
          cursorColor: cursorColor,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorWidth: cursorWidth,
          decoration: decoration,
          enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
          enableInteractiveSelection: enableInteractiveSelection,
          enableSuggestions: enableSuggestions,
          enabled: enabled,
          expands: expands,
          focusNode: focusNode,
          hintText: hintText,
          initialValue: initialValue,
          inputFormatters: null,
          initialValueDeserializer: null,
          keyboardAppearance: keyboardAppearance,
          keyboardType: keyboardType,
          maxLines: 1,
          minLines: 1,
          validator: settings.validate,
          maxLength: maxLength,
          maxLengthEnforcement: null,
          mouseCursor: mouseCursor,
          onChanged: onChanged,
          obscureText: obscureText,
          paddingTop: paddingTop,
          paddingBottom: paddingBottom,
          paddingLeft: paddingLeft,
          paddingRight: paddingRight,
          readOnly: readOnly,
          onTapOutside: onTapOutside,
          scrollPadding: scrollPadding,
          scrollPhysics: scrollPhysics,
          scrollController: null,
          smoothErrorPadding: smoothErrorPadding,
          strutStyle: strutStyle,
          showCursor: showCursor,
        ),
        if (_buildChecker) settings._buildChecker(),
        if (_isDoubleLine)
          LiteTextFormField(
            name: repeatName,
            validator: (value) async {
              final mainFieldValue = liteFormController
                  .tryGetField(
                    formName: group!.name,
                    fieldName: name,
                  )
                  ?.value;
              final secondaryFieldValue = liteFormController
                  .tryGetField(
                    formName: group.name,
                    fieldName: repeatName,
                  )
                  ?.value;
              if (mainFieldValue != secondaryFieldValue) {}

              final error = await settings.validate(value);
              if (error?.isNotEmpty == true) {
                /// don't show error here is the main field has not validated
                return null;
              }
            },
            autocorrect: false,
            autofillHints: autofillHints,
            autofocus: autofocus,
            autovalidateMode: autovalidateMode,
            contextMenuBuilder: contextMenuBuilder,
            buildCounter: buildCounter,
            controller: controller,
            cursorColor: cursorColor,
            cursorHeight: cursorHeight,
            cursorRadius: cursorRadius,
            cursorWidth: cursorWidth,
            decoration: decoration,
            enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
            enableInteractiveSelection: enableInteractiveSelection,
            enableSuggestions: enableSuggestions,
            enabled: enabled,
            expands: expands,
            focusNode: focusNode,
            hintText: hintText,
            initialValue: initialValue,
            inputFormatters: null,
            initialValueDeserializer: null,
            keyboardAppearance: keyboardAppearance,
            keyboardType: keyboardType,
            maxLines: 1,
            minLines: 1,
            maxLength: maxLength,
            maxLengthEnforcement: null,
            mouseCursor: mouseCursor,
            onChanged: onChanged,
            obscureText: obscureText,
            paddingTop: 0.0,
            paddingBottom: paddingBottom,
            paddingLeft: paddingLeft,
            paddingRight: paddingRight,
            readOnly: readOnly,
            onTapOutside: onTapOutside,
            scrollPadding: scrollPadding,
            scrollPhysics: scrollPhysics,
            scrollController: null,
            smoothErrorPadding: smoothErrorPadding,
            strutStyle: strutStyle,
            showCursor: showCursor,
          ),
      ],
    );
  }
}

typedef PasswordCheckBuilder = Widget Function(
  bool digitsOk,
  bool upperCaseOk,
  bool lowerCaseOk,
  bool specialCharsOk,
);

class PasswordSettings {
  final LiteFormFieldValidator<String>? validator;
  final int minLength;
  final PasswordRequirements? requirements;

  /// If you don't like the default look and feel of the
  /// password requirements check, you can implement your own
  /// and return it here
  final PasswordCheckBuilder? checkerBuilder;

  Widget _buildChecker() {
    return checkerBuilder?.call(
          requirements!._digitsOk,
          requirements!._upperCaseOk,
          requirements!._lowerCaseOk,
          requirements!._specialCharsOk,
        ) ??
        _PasswordChecker(
          digitsOk: requirements!._digitsOk,
          upperCaseOk: requirements!._upperCaseOk,
          lowerCaseOk: requirements!._lowerCaseOk,
          specialCharsOk: requirements!._specialCharsOk,
        );
  }

  PasswordSettings({
    this.validator,
    this.requirements,
    this.checkerBuilder,
    this.minLength = 3,
  }) : assert(
          (validator == null || requirements == null) &&
              (validator != null || requirements != null),
          'You must provide either a validator or a requirements config',
        );

  Future<String?> validate(String? value) async {
    if (validator != null) {
      return validator!(value);
    }
    return requirements!.validate(value);
  }
}

class PasswordRequirements {
  factory PasswordRequirements.defaultRequirements() {
    return PasswordRequirements();
  }

  PasswordRequirements({
    this.minDigits = 1,
    this.numSpecialChars = 1,
    this.numUpperCaseLetters = 1,
    this.numLowerCaseLetters = 1,
    this.lowerCaseLettersPattern = 'a-z',
    this.upperCaseLettersPattern = 'A-Z',
    this.specialCharsPattern = "[\"!#\$%&')(*+,-./:;<=>?@\\][^_`|}{~]",
    this.digitsPattern = '0-9',
  }) {
    if (digitsPattern.isNotEmpty) {
      _digitsRegex = RegExp('$digitsPattern*');
    }
    if (lowerCaseLettersPattern.isNotEmpty) {
      _lowerCaseLettersRegex = RegExp('$lowerCaseLettersPattern*');
    }
    if (upperCaseLettersPattern.isNotEmpty) {
      _upperCaseLettersRegex = RegExp('$upperCaseLettersPattern*');
    }
    if (specialCharsPattern.isNotEmpty) {
      _specialCharsLettersRegex = RegExp('$specialCharsPattern*');
    }
  }

  String? validate(String? value) {
    if (value == null) {
      return 'Password cannot be empty';
    }
    _digitsOk = _isDigitsOk(value);
    _lowerCaseOk = _isLowerCaseOk(value);
    _upperCaseOk = _isUpperCaseOk(value);
    _specialCharsOk = _isSpecialCharsOk(value);
    return null;
  }

  bool _isDigitsOk(String value) {
    if (minDigits < 1) {
      return true;
    }
    return _digitsRegex!.allMatches(value).length >= minDigits;
  }

  bool _isLowerCaseOk(
    String value,
  ) {
    if (numLowerCaseLetters < 1) {
      return true;
    }
    return _lowerCaseLettersRegex!.allMatches(value).length >= numLowerCaseLetters;
  }

  bool _isUpperCaseOk(
    String value,
  ) {
    if (numUpperCaseLetters < 1) {
      return true;
    }
    return _upperCaseLettersRegex!.allMatches(value).length >= numUpperCaseLetters;
  }

  bool _isSpecialCharsOk(
    String value,
  ) {
    if (numSpecialChars < 1) {
      return true;
    }
    return _specialCharsLettersRegex!.allMatches(value).length >= numSpecialChars;
  }

  RegExp? _digitsRegex;
  RegExp? _upperCaseLettersRegex;
  RegExp? _lowerCaseLettersRegex;
  RegExp? _specialCharsLettersRegex;

  bool _digitsOk = false;
  bool _upperCaseOk = false;
  bool _lowerCaseOk = false;
  bool _specialCharsOk = false;

  final int minDigits;
  final int numSpecialChars;
  final int numUpperCaseLetters;
  final int numLowerCaseLetters;
  final String specialCharsPattern;
  final String lowerCaseLettersPattern;
  final String upperCaseLettersPattern;
  final String digitsPattern;
}

class _PasswordChecker extends StatelessWidget {
  const _PasswordChecker({
    required this.digitsOk,
    required this.upperCaseOk,
    required this.lowerCaseOk,
    required this.specialCharsOk,
  });

  final bool digitsOk;
  final bool upperCaseOk;
  final bool lowerCaseOk;
  final bool specialCharsOk;

  @override
  Widget build(BuildContext context) {
    return LiteState<LiteFromRebuildController>(
      builder: (BuildContext c, LiteFromRebuildController controller) {
        return Container(
          height: 110.0,
          width: double.infinity,
          color: Colors.orange,
        );
      },
    );
  }
}
