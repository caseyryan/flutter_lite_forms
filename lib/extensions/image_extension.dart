import 'dart:async';

import 'package:flutter/material.dart';

extension ImageExtension on Image {

  Future<ImageInfo> toUiImage() async {
    final completer = Completer<ImageInfo>();
    image
        .resolve(
      const ImageConfiguration(),
    )
        .addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          info.image.height;
          info.sizeBytes;
          completer.complete(info);
        },
      ),
    );
    return completer.future;
  }
}
