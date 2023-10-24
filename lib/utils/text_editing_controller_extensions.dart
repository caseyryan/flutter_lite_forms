import 'package:flutter/material.dart';

extension TextEditingControllerExtension on TextEditingController {

  void safeSetText(String value) {
    if (WidgetsBinding.instance.hasScheduledFrame) {
      WidgetsBinding.instance.ensureVisualUpdate();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
        text = value;
      });
    }
    else {
      text = value;
    }
  }

  Future _delay(int millis) async {
    return Future.delayed(Duration(milliseconds: millis));
  }


  Future setSelectionToEnd([
    FocusNode? focusNode,
    int delayMillis = 100,
  ]) async {
    await _delay(delayMillis);
    selection = TextSelection.collapsed(
      offset: text.length,
    );
    focusNode?.requestFocus();
  }

  Future setSelectionToComfortNumber([
    FocusNode? focusNode,
    int delayMillis = 100,
  ]) async {
    await _delay(delayMillis);
    final indexOfPeriod = text.lastIndexOf('.');
    if (indexOfPeriod > -1) {
      selection = TextSelection.collapsed(
        offset: indexOfPeriod,
      );
    }

    focusNode?.requestFocus();
  }

  void setSelectionToIndex(
    int index, [
    FocusNode? focusNode,
  ]) {
    selection = TextSelection.collapsed(
      offset: index,
    );
    focusNode?.requestFocus();
  }


}