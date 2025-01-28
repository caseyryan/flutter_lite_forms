import 'package:flutter/material.dart';

InputDecoration mergeInputDecorations(List<InputDecoration?> decorations) {
  InputDecoration mergedDecoration = const InputDecoration();

  for (InputDecoration? decoration in decorations) {
    if (decoration == null) continue;

    mergedDecoration = mergedDecoration.copyWith(
      labelText: decoration.labelText ?? mergedDecoration.labelText,
      labelStyle: decoration.labelStyle ?? mergedDecoration.labelStyle,
      helperText: decoration.helperText ?? mergedDecoration.helperText,
      helperStyle: decoration.helperStyle ?? mergedDecoration.helperStyle,
      hintText: decoration.hintText ?? mergedDecoration.hintText,
      hintStyle: decoration.hintStyle ?? mergedDecoration.hintStyle,
      errorText: decoration.errorText ?? mergedDecoration.errorText,
      errorStyle: decoration.errorStyle ?? mergedDecoration.errorStyle,
      enabledBorder: decoration.enabledBorder ?? mergedDecoration.enabledBorder,
      focusedBorder: decoration.focusedBorder ?? mergedDecoration.focusedBorder,
      border: decoration.border ?? mergedDecoration.border,
      filled: decoration.filled ?? mergedDecoration.filled,
      fillColor: decoration.fillColor ?? mergedDecoration.fillColor,
      contentPadding: decoration.contentPadding ?? mergedDecoration.contentPadding,
      prefixIcon: decoration.prefixIcon ?? mergedDecoration.prefixIcon,
      suffixIcon: decoration.suffixIcon ?? mergedDecoration.suffixIcon,
    );
  }

  return mergedDecoration;
}
