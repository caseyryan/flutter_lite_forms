// ignore_for_file: unused_element

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

class LitePasswordField extends StatefulWidget {
  const LitePasswordField({
    super.key,
    required this.name,
    required this.settings,
    this.repeatPlaceholder,
    this.useSmoothError = true,
    this.smoothErrorPadding = const EdgeInsets.only(
      top: 6.0,
    ),
    this.hintText,
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
    this.obscureText = true,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
  });

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
  final bool enableSuggestions;
  final bool expands;
  final bool obscureText;
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

  @override
  State<LitePasswordField> createState() => _LitePasswordFieldState();
}

class _LitePasswordFieldState extends State<LitePasswordField> {
  bool _isObscure = true;

  @override
  void initState() {
    _isObscure = widget.obscureText;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LitePasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      setState(() {
        _isObscure = widget.obscureText;
      });
    }
  }

  bool get _isDoubleLine {
    return widget.settings.passwordFieldCheckType ==
        PasswordFieldCheckType.repeatPassword;
  }

  bool get _requiresCheckerView {
    return widget.settings.requirements != null;
  }

  @override
  Widget build(BuildContext context) {
    final repeatName = widget.repeatPlaceholder ?? 'Confirm ${widget.name}';
    final group = LiteFormGroup.of(context)!;
    final allowErrorTexts = widget.settings.validator != null;
    var inputDecoration = widget.decoration ??
        liteFormController.config?.inputDecoration ??
        const InputDecoration();
    if (widget.settings.hasShowPasswordButton) {
      inputDecoration = inputDecoration.copyWith(
        suffixIcon: widget.settings.showPasswordIconBuilder?.call(_isObscure) ??
            Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiteTextFormField(
          name: widget.name,
          allowErrorTexts: allowErrorTexts,
          autocorrect: false,
          autofillHints: widget.autofillHints,
          autofocus: widget.autofocus,
          autovalidateMode: widget.autovalidateMode,
          contextMenuBuilder: widget.contextMenuBuilder,
          buildCounter: widget.buildCounter,
          controller: widget.controller,
          cursorColor: widget.cursorColor,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorWidth: widget.cursorWidth,
          decoration: inputDecoration,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          enableSuggestions: widget.enableSuggestions,
          enabled: widget.enabled,
          expands: widget.expands,
          focusNode: widget.focusNode,
          hintText: widget.hintText,
          initialValue: widget.initialValue,
          inputFormatters: null,
          initialValueDeserializer: null,
          keyboardAppearance: widget.keyboardAppearance,
          keyboardType: widget.keyboardType,
          maxLines: 1,
          minLines: 1,
          validator: (value) async {
            final firstFieldValue = liteFormController
                .tryGetField(
                  formName: group.name,
                  fieldName: widget.name,
                )
                ?.value
                ?.toString();
            final secondaryFieldValue = liteFormController
                .tryGetField(
                  formName: group.name,
                  fieldName: repeatName,
                )
                ?.value
                ?.toString();
    
            bool? passwordsMatch = firstFieldValue == secondaryFieldValue;
            return widget.settings._validate(
              value: value,
              passwordsMatch: passwordsMatch,
              group: group,
            );
          },
          maxLength: widget.maxLength,
          maxLengthEnforcement: null,
          mouseCursor: widget.mouseCursor,
          onChanged: (value) {
            if (_isDoubleLine) {
              liteFormRebuildController.rebuild();
            }
            widget.onChanged?.call(value);
          },
          obscureText: _isObscure,
          paddingTop: widget.paddingTop,
          paddingBottom: widget.paddingBottom,
          paddingLeft: widget.paddingLeft,
          paddingRight: widget.paddingRight,
          readOnly: widget.readOnly,
          onTapOutside: widget.onTapOutside,
          scrollPadding: widget.scrollPadding,
          scrollPhysics: widget.scrollPhysics,
          scrollController: null,
          smoothErrorPadding: widget.smoothErrorPadding,
          strutStyle: widget.strutStyle,
          showCursor: widget.showCursor,
        ),
        if (_requiresCheckerView)
          LiteState<LiteFormRebuildController>(
            builder: (BuildContext c, LiteFormRebuildController controller) {
              return widget.settings._buildChecker(
                paddingTop: 0.0,
                paddingBottom: widget.paddingBottom,
                group: group,
                name: widget.name,
                repeatName: repeatName,
                decoration: inputDecoration.copyWith(
                  errorStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              );
            },
          ),
        if (_isDoubleLine)
          LiteTextFormField(
            allowErrorTexts: allowErrorTexts,
            name: repeatName,
    
            validator: (value) async {
              /// in this case no validation is required except for the password match
              liteFormRebuildController.rebuild();
              return null;
            },
            autocorrect: false,
            autofillHints: widget.autofillHints,
            autofocus: widget.autofocus,
            autovalidateMode: widget.autovalidateMode,
            contextMenuBuilder: widget.contextMenuBuilder,
            buildCounter: widget.buildCounter,
            controller: widget.controller,
            cursorColor: widget.cursorColor,
            cursorHeight: widget.cursorHeight,
            cursorRadius: widget.cursorRadius,
            cursorWidth: widget.cursorWidth,
            decoration: inputDecoration,
            enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            enableSuggestions: widget.enableSuggestions,
            enabled: widget.enabled,
            expands: widget.expands,
            focusNode: widget.focusNode,
            hintText: widget.hintText,
            inputFormatters: null,
            initialValueDeserializer: null,
            keyboardAppearance: widget.keyboardAppearance,
            keyboardType: widget.keyboardType,
            maxLines: 1,
            minLines: 1,
            maxLength: widget.maxLength,
            maxLengthEnforcement: null,
            mouseCursor: widget.mouseCursor,
            onChanged: (value) {
              liteFormRebuildController.rebuild();
              liteFormController.validateForm(formName: group.name);
            },
            obscureText: _isObscure,
            paddingTop: 0.0,
            paddingBottom: widget.paddingBottom,
            paddingLeft: widget.paddingLeft,
            paddingRight: widget.paddingRight,
            readOnly: widget.readOnly,
            onTapOutside: widget.onTapOutside,
            scrollPadding: widget.scrollPadding,
            scrollPhysics: widget.scrollPhysics,
            scrollController: null,
            smoothErrorPadding: widget.smoothErrorPadding,
            strutStyle: widget.strutStyle,
            showCursor: widget.showCursor,
          ),
      ],
    );
  }
}

typedef PasswordCheckBuilder = Widget Function(
  bool? digitsOk,
  bool? upperCaseOk,
  bool? lowerCaseOk,
  bool? specialCharsOk,
  bool? lengthOk,

  /// used only in case you use [PasswordFieldCheckType.repeatPassword]
  bool? passwordsMatch,
);

typedef ShowPasswordIconBuilder = Widget Function(bool isVisible);

class PasswordSettings {
  PasswordSettings({
    this.validator,
    this.requirements,
    this.checkerBuilder,
    this.hasShowPasswordButton = true,
    this.minLength = 3,
    this.showPasswordIconBuilder,
    this.passwordFieldCheckType = PasswordFieldCheckType.repeatPassword,
  }) : assert(
          (validator == null || requirements == null) &&
              (validator != null || requirements != null),
          'You must provide either a validator or a requirements config',
        );

  final LiteFormFieldValidator<String>? validator;
  final int minLength;
  final PasswordRequirements? requirements;
  final PasswordFieldCheckType passwordFieldCheckType;

  /// if you need to display a button that hides / shows the password
  final bool hasShowPasswordButton;

  /// if you need to build a custom icon for showing and hiding a password
  ///
  /// NOTICE: if you implement your own icon, you will have to write a custom logic
  /// to pass [obscureText] parameter to the LitePasswordField as well
  final ShowPasswordIconBuilder? showPasswordIconBuilder;

  /// If you don't like the default look and feel of the
  /// password requirements check, you can implement your own
  /// and return it here
  final PasswordCheckBuilder? checkerBuilder;

  Widget _buildChecker({
    required double paddingTop,
    required double paddingBottom,
    required LiteFormGroup group,
    required String name,
    required String repeatName,
    required InputDecoration decoration,
  }) {
    final firstFieldValue = liteFormController
        .tryGetField(
          formName: group.name,
          fieldName: name,
        )
        ?.value
        ?.toString();
    final secondaryFieldValue = liteFormController
        .tryGetField(
          formName: group.name,
          fieldName: repeatName,
        )
        ?.value
        ?.toString();

    /// just to make sure all fields are updated
    bool? passwordsMatch = firstFieldValue == secondaryFieldValue;
    requirements!._validate(
      value: firstFieldValue,
      rebuild: false,
      passwordsMatch: passwordsMatch,
      group: group,
    );
    if (firstFieldValue?.isNotEmpty != true && secondaryFieldValue?.isNotEmpty != true) {
      passwordsMatch = null;
    }
    final digitsOk = requirements!.minDigits < 1 ? null : requirements!._digitsOk;
    final upperCaseOk =
        requirements!.minUpperCaseLetters < 1 ? null : requirements!._upperCaseOk;
    final lowerCaseOk =
        requirements!.minLowerCaseLetters < 1 ? null : requirements!._lowerCaseOk;
    final specialCharsOk =
        requirements!.minSpecialChars < 1 ? null : requirements!._specialCharsOk;

    return checkerBuilder?.call(
          digitsOk,
          upperCaseOk,
          lowerCaseOk,
          specialCharsOk,
          requirements!._lengthOk,
          passwordsMatch,
        ) ??
        PasswordChecker(
          digitsOk: digitsOk,
          upperCaseOk: upperCaseOk,
          lowerCaseOk: lowerCaseOk,
          specialCharsOk: specialCharsOk,
          lengthOk: requirements!._lengthOk,
          minDigits: requirements!.minDigits,
          minLength: requirements!.minLength,
          minLowerCaseLetters: requirements!.minLowerCaseLetters,
          minPasswordLength: requirements!.minLength,
          minSpecialCharacters: requirements!.minSpecialChars,
          minUpperCaseLetters: requirements!.minUpperCaseLetters,
          passwordsMatch: passwordsMatch,
          paddingBottom: paddingBottom,
          paddingTop: paddingTop,
          group: group,
          baseTextStyle: decoration.errorStyle,
          textColor: null,
        );
  }

  Future<String?> _validate({
    required String? value,
    required bool passwordsMatch,
    required LiteFormGroup? group,
  }) async {
    if (validator != null) {
      if (passwordFieldCheckType == PasswordFieldCheckType.repeatPassword) {
        if (!passwordsMatch) {
          const errorText = 'Passwords do not match';
          if (group != null) {
            return group.translationBuilder.call(errorText);
          }
          return errorText;
        }
      }
      final result = await validator!(value);

      return result;
    }
    return requirements!._validate(
      value: value,
      passwordsMatch: passwordsMatch,
      group: group,
    );
  }
}

class PasswordRequirements {
  factory PasswordRequirements.defaultRequirements() {
    return PasswordRequirements();
  }

  PasswordRequirements({
    this.minDigits = 1,
    this.minSpecialChars = 1,
    this.minUpperCaseLetters = 1,
    this.minLowerCaseLetters = 1,
    this.minLength = 4,
    this.lowerCaseLettersPattern = 'a-z',
    this.upperCaseLettersPattern = 'A-Z',
    this.specialCharsPattern = "[\"!#\$%&')(*+,-\\.\\/:;<=>?@\\][^_`|}{~]",
    this.digitsPattern = '0-9',
  }) {
    if (digitsPattern.isNotEmpty && minDigits > 0) {
      _digitsRegex = RegExp('[$digitsPattern]+');
    }
    if (lowerCaseLettersPattern.isNotEmpty && minLowerCaseLetters > 0) {
      _lowerCaseLettersRegex = RegExp('[$lowerCaseLettersPattern]+');
    }
    if (upperCaseLettersPattern.isNotEmpty && minUpperCaseLetters > 0) {
      _upperCaseLettersRegex = RegExp('[$upperCaseLettersPattern]+');
    }
    if (specialCharsPattern.isNotEmpty && minSpecialChars > 0) {
      _specialCharsLettersRegex = RegExp('$specialCharsPattern+');
    }
  }

  String? _validate({
    required String? value,
    required bool passwordsMatch,
    required LiteFormGroup? group,
    bool rebuild = true,
  }) {
    if (value?.isNotEmpty != true) {
      return 'Password cannot be empty';
    }
    _digitsOk = _isDigitsOk(value!);
    _lowerCaseOk = _isLowerCaseOk(value);
    _upperCaseOk = _isUpperCaseOk(value);
    _specialCharsOk = _isSpecialCharsOk(value);
    _lengthOk = _isLengthOk(value);
    if (rebuild) {
      liteFormRebuildController.rebuild();
    }
    final success = _digitsOk &
        _lowerCaseOk &
        _upperCaseOk &
        _specialCharsOk &
        _lengthOk &
        passwordsMatch;
    if (!success) {
      return 'Invalid form';
    }
    return null;
  }

  bool _isDigitsOk(String value) {
    if (minDigits < 1) {
      return true;
    }
    return _digitsRegex!.allMatches(value).length >= minDigits;
  }

  bool _isLengthOk(String value) {
    return value.length >= minLength;
  }

  bool _isLowerCaseOk(
    String value,
  ) {
    if (minLowerCaseLetters < 1) {
      return true;
    }
    return _lowerCaseLettersRegex!.allMatches(value).length >= minLowerCaseLetters;
  }

  bool _isUpperCaseOk(
    String value,
  ) {
    if (minUpperCaseLetters < 1) {
      return true;
    }
    return _upperCaseLettersRegex!.allMatches(value).length >= minUpperCaseLetters;
  }

  bool _isSpecialCharsOk(
    String value,
  ) {
    if (minSpecialChars < 1) {
      return true;
    }
    return _specialCharsLettersRegex!.allMatches(value).length >= minSpecialChars;
  }

  RegExp? _digitsRegex;
  RegExp? _upperCaseLettersRegex;
  RegExp? _lowerCaseLettersRegex;
  RegExp? _specialCharsLettersRegex;

  bool _digitsOk = false;
  bool _upperCaseOk = false;
  bool _lowerCaseOk = false;
  bool _specialCharsOk = false;
  bool _lengthOk = false;

  final int minDigits;
  final int minSpecialChars;
  final int minUpperCaseLetters;
  final int minLowerCaseLetters;
  final int minLength;
  final String specialCharsPattern;
  final String lowerCaseLettersPattern;
  final String upperCaseLettersPattern;
  final String digitsPattern;
}

class PasswordChecker extends StatelessWidget {
  const PasswordChecker({
    super.key,
    required this.digitsOk,
    required this.upperCaseOk,
    required this.lowerCaseOk,
    required this.specialCharsOk,
    required this.passwordsMatch,
    required this.lengthOk,
    required this.group,
    required this.baseTextStyle,
    required this.minDigits,
    required this.minLowerCaseLetters,
    required this.minUpperCaseLetters,
    required this.minPasswordLength,
    required this.minSpecialCharacters,
    required this.minLength,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.errorColor,
    this.successColor,
    this.textColor,
  });

  final int minLength;
  final bool? digitsOk;
  final int minDigits;
  final bool? upperCaseOk;
  final int minUpperCaseLetters;
  final bool? lowerCaseOk;
  final int minLowerCaseLetters;
  final bool? specialCharsOk;
  final int minSpecialCharacters;
  final bool? passwordsMatch;
  final bool? lengthOk;
  final int minPasswordLength;
  final double paddingTop;
  final double paddingBottom;
  final LiteFormGroup group;
  final Color? errorColor;
  final Color? successColor;
  final Color? textColor;
  final TextStyle? baseTextStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
      ),
      child: AnimatedSize(
        duration: kThemeAnimationDuration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PasswordRequirementLine(
              text: group.translationBuilder('Passwords match') ?? '',
              isOk: passwordsMatch,
            ),
            _PasswordRequirementLine(
              text: group.translationBuilder('Length (min: $minLength)') ?? '',
              isOk: lengthOk,
            ),
            _PasswordRequirementLine(
              text: group.translationBuilder(
                      'Special characters (min: $minSpecialCharacters)') ??
                  '',
              isOk: specialCharsOk,
            ),
            _PasswordRequirementLine(
              text: group.translationBuilder(
                      'Lower case letters (min: $minLowerCaseLetters)') ??
                  '',
              isOk: lowerCaseOk,
            ),
            _PasswordRequirementLine(
              text: group.translationBuilder(
                      'Upper case letters (min: $minUpperCaseLetters)') ??
                  '',
              isOk: upperCaseOk,
            ),
            _PasswordRequirementLine(
              text: group.translationBuilder('Digits (min: $minDigits)') ?? '',
              isOk: digitsOk,
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordRequirementLine extends StatefulWidget {
  const _PasswordRequirementLine({
    super.key,
    required this.text,
    required this.isOk,
    this.errorColor,
    this.successColor,
    this.baseTextStyle,
    this.textColor,
  });

  final bool? isOk;
  final String text;
  final Color? errorColor;
  final Color? successColor;
  final Color? textColor;
  final TextStyle? baseTextStyle;

  @override
  State<_PasswordRequirementLine> createState() => __PasswordRequirementLineState();
}

class __PasswordRequirementLineState extends State<_PasswordRequirementLine> {
  late ThemeData _theme;

  Color? get _color {
    if (widget.isOk == true) {
      return widget.successColor ?? Colors.green;
    } else if (widget.isOk == false) {
      return widget.errorColor ?? _theme.colorScheme.error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOk == null) {
      return const SizedBox.shrink();
    }
    _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5.0,
      ),
      child: Row(
        children: [
          Flexible(
            child: Icon(
              widget.isOk! ? Icons.check_circle : Icons.cancel,
              size: 18.0,
              color: _color,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            widget.text,
            style: widget.baseTextStyle?.copyWith(
              color: widget.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
