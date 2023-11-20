import 'package:flutter/material.dart';

void onPostFrame(VoidCallback fn) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    fn();
  });
}
