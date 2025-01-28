import 'package:flutter/material.dart';
import 'package:lite_state/on_postframe.dart';


class SizeDetector extends StatefulWidget {
  final Widget? child;
  final ValueChanged<Size> onSizeDetected;
  final bool useDelay;

  const SizeDetector({
    Key? key,
    required this.onSizeDetected,
    this.child,
    this.useDelay = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SizeDetectorState createState() => _SizeDetectorState();
}

class _SizeDetectorState extends State<SizeDetector> {
  final GlobalKey _sizeDetectionKey = GlobalKey();
  Size? _size;

  Future _detectSize() async {
    if (widget.useDelay) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    onPostframe(_postframeCallback);
  }

  void _postframeCallback() {
    if (!mounted) {
      return;
    }
    if (_sizeDetectionKey.currentContext == null) {
      return;
    }
    try {
      if (_size != _sizeDetectionKey.currentContext!.size) {
        _size = _sizeDetectionKey.currentContext!.size;
        if (_size!.width > 0.0 && _size!.height > 0.0) {
          widget.onSizeDetected(_size!);
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    _detectSize();
    return Container(
      key: _sizeDetectionKey,
      child: widget.child,
    );
  }
}
