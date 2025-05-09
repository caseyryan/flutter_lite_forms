import 'dart:io';

import 'package:flutter/foundation.dart';

import 'os_stub.dart' if (dart.library.html) 'web_stub.dart';

class ExtendedPlatform {

  static bool get isWebHtmlRenderer {
    return isHtmlRenderer;
  }

  static bool get isWebIOS {
    if (kIsWeb) {
      final userAgentLower = window.navigator.userAgent.toLowerCase();
      return userAgentLower.contains('ios') ||
          userAgentLower.contains('iphone') ||
          userAgentLower.contains('ipad');
    }
    return false;
  }

  static bool get isAndroid {
    if (kIsWeb) {
      return false;
    }
    return Platform.isAndroid;
  }

  static bool get isIOS {
    if (kIsWeb) {
      return false;
    }
    return Platform.isIOS;
  }
}
