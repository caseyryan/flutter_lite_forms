part of '../lite_forms_configuration.dart';

LiteFormsConfiguration _vanila(BuildContext context) {
  final primaryColor = Theme.of(context).primaryColor;
  const cornerRadius = 6.0;
  const normalBorderWidth = .1;
  const focusedBorderWidth = .4;
  const borderRadius = BorderRadius.only(
    topLeft: Radius.circular(
      cornerRadius,
    ),
    topRight: Radius.circular(
      cornerRadius,
    ),
    bottomRight: Radius.circular(
      cornerRadius,
    ),
    bottomLeft: Radius.circular(
      cornerRadius,
    ),
  );
  const defaultBorder = OutlineInputBorder(
    borderRadius: borderRadius,
  );

  /// Must be called in the beginning.
  /// Basically that's all you need
  /// to start using Lite Forms
  // initializeLiteForms(
  /// optional configuration which will be used as default
  return LiteFormsConfiguration(
    defaultDateFormat: 'dd MMM, yyyy',
    defaultTimeFormat: 'HH:mm',
    dropSelectorSettings: const DropSelectorSettings(
      dropSelectorActionType: DropSelectorActionType.simple,
      dropSelectorType: DropSelectorType.adaptive,
    ),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    useAutogeneratedHints: true,
    allowUnfocusOnTapOutside: true,
    defaultTextEntryModalRouteSettings: TextEntryModalRouteSettings(
      backgroundOpacity: .95,
    ),
    lightTheme: LiteFormsTheme(
      defaultTextStyle: const TextStyle(
        fontSize: 15.0,
        color: Color.fromARGB(255, 32, 32, 32),
        fontWeight: FontWeight.normal,
      ),
      destructiveColor: Colors.red,
      filePickerDecoration: const BoxDecoration(
        borderRadius: borderRadius,
        border: Border.fromBorderSide(
          BorderSide(
            width: normalBorderWidth,
          ),
        ),
      ),
      inputDecoration: InputDecoration(
        filled: false,
        isDense: false,
        contentPadding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 4.0,
          bottom: 4.0,
        ),
        errorStyle: const TextStyle(
          fontSize: 16.0,
          color: Colors.red,
        ),
        border: defaultBorder,
        enabledBorder: defaultBorder.copyWith(
          borderSide: const BorderSide(
            width: normalBorderWidth,
          ),
        ),
        focusedBorder: defaultBorder.copyWith(
          borderSide: BorderSide(
            width: focusedBorderWidth,
            color: primaryColor,
          ),
        ),
      ),
    ),
    darkTheme: LiteFormsTheme(
      defaultTextStyle: const TextStyle(
        fontSize: 15.0,
        color: Color.fromARGB(255, 248, 248, 248),
        fontWeight: FontWeight.normal,
      ),
      destructiveColor: Colors.redAccent,
      inputDecoration: InputDecoration(
        filled: false,
        isDense: false,
        contentPadding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 4.0,
          bottom: 4.0,
        ),
        errorStyle: const TextStyle(
          fontSize: 16.0,
          color: Colors.redAccent,
        ),
        border: defaultBorder,
        enabledBorder: defaultBorder.copyWith(
          borderSide: const BorderSide(
            width: normalBorderWidth,
            color: Colors.white,
          ),
        ),
        focusedBorder: defaultBorder.copyWith(
          borderSide: const BorderSide(
            width: focusedBorderWidth,
            color: Colors.white,
          ),
        ),
      ),
      filePickerDecoration: const BoxDecoration(
        borderRadius: borderRadius,
        border: Border.fromBorderSide(
          BorderSide(
            width: normalBorderWidth,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
