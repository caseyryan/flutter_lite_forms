import 'dart:io';

import 'package:flutter/foundation.dart';

import 'os_stub.dart' if (dart.library.html) 'web_stub.dart';

class ExtendedPlatform {
  static bool get isIOS {
    if (kIsWeb) {
      final userAgentLower = window.navigator.userAgent.toLowerCase();
      return userAgentLower.contains('ios') || userAgentLower.contains('iphone') || userAgentLower.contains('ipad');
    }
    return Platform.isIOS;
  }

}