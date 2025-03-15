// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:js';

dynamic get window {
  return html.window;
}

bool get isHtmlRenderer {
  return context['flutterCanvasKit'] != null;
} 
