// ignore_for_file: empty_catches

library after_layout;

import 'package:flutter/widgets.dart';

mixin PostFrameMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        try {
          didFirstLayoutFinished(context);
        } catch (e) {}
      },
    );
  }

  void didFirstLayoutFinished(BuildContext context);

  void callAfterFrame(ValueChanged<BuildContext> fn) {
    WidgetsBinding.instance.ensureVisualUpdate();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        fn.call(context);
      }
    });
  }
}
