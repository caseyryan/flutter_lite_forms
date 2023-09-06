import 'dart:convert';

import 'package:flutter/services.dart';

extension StringExtensions on String {
  static final RegExp _spaceRegexp = RegExp(r'[\s]+');

  Future copyToClipBoard() async {
    await Clipboard.setData(ClipboardData(text: this));
  }

  String firstToUpperCase() {
    if (isEmpty) return this;
    var split = toLowerCase().split('');
    split[0] = split[0].toUpperCase();
    return split.join();
  }

  Map base64ToMap() {
    return jsonDecode(
      utf8.decode(
        base64Decode(this),
      ),
    );
  }

  String get lastLetter {
    if (isEmpty) {
      return '';
    }
    return this[length - 1];
  }

  List<String> splitBySpace() {
    return split(_spaceRegexp).where((e) => e.trim().isNotEmpty).toList();
  }

  String firstToLowerCase() {
    if (isEmpty) return this;
    var split = toLowerCase().split('');
    split[0] = split[0].toLowerCase();
    return split.join();
  }

  String toCamelCase() {
    if (isEmpty) return this;
    final replaced = replaceAll(RegExp(r'[^A-Za-z ]+'), '');
    return replaced.firstToUpperCase();
  }

  String _capitalizeString(String string) {
    return "${string[0].toUpperCase()}${string.substring(1)}";
  }

  String splitByCamelCase() {
    var words = split(RegExp(r"(?=[A-Z])"));
    return words.map((e) => _capitalizeString(e)).join(' ');
  }

  Future copyToClipboard() async {
    if (isEmpty) {
      return;
    }
    var clipboardData = ClipboardData(
      text: this,
    );
    await Clipboard.setData(clipboardData);
  }

  bool get isNullOrWhiteSpace {
    return isEmpty;
  }

  bool isMatchingSearch(String? searchFor) {
    if (searchFor == null || searchFor.isEmpty) return true;
    var words = searchFor.toLowerCase().split(RegExp(r'\s+'));
    for (var w in words) {
      if (contains(w)) {
        return true;
      }
    }
    return false;
  }


}
