// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:web/web.dart' as web;
import 'dart:js_interop';

dynamic get window {
  return web.window;
  // return html.window;
}

bool get isHtmlRenderer {
  return false;
  // return context['flutterCanvasKit'] != null || window['flutterWebRenderer'] == 'canvaskit';
} 
