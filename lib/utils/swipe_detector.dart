import 'dart:math';

import 'package:flutter/material.dart';

enum SwipeDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

enum AcceptedSwipes {
  all,
  horizontal,
  vertical,

  /// [none] will disable swipe detector
  none,
}

class SwipeDetector extends StatefulWidget {
  final Widget child;
  final double velocityThreshhold;
  final ValueChanged<SwipeDirection> onSwipe;
  final AcceptedSwipes acceptedSwipes;
  final bool onlySwipesFromEdges;
  final double interactiveEdgeWidth;

  const SwipeDetector({
    Key? key,
    required this.child,
    required this.onSwipe,
    this.velocityThreshhold = 150.0,
    this.onlySwipesFromEdges = false,
    this.interactiveEdgeWidth = 100.0,
    this.acceptedSwipes = AcceptedSwipes.all,
  }) : super(key: key);

  @override
  State<SwipeDetector> createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  Offset? _startPosition;
  final Stopwatch _stopwatch = Stopwatch();
  int _lastMillis = 0;

  @override
  void initState() {
    _stopwatch.start();
    super.initState();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  bool _isSupportedDirection(SwipeDirection direction) {
    if (widget.acceptedSwipes == AcceptedSwipes.none) {
      return false;
    } else if (widget.acceptedSwipes == AcceptedSwipes.all) {
      return true;
    } else if (widget.acceptedSwipes == AcceptedSwipes.horizontal) {
      if (direction == SwipeDirection.leftToRight ||
          direction == SwipeDirection.rightToLeft) {
        return true;
      }
    } else if (widget.acceptedSwipes == AcceptedSwipes.vertical) {
      if (direction == SwipeDirection.topToBottom ||
          direction == SwipeDirection.bottomToTop) {
        return true;
      }
    }
    return false;
  }

  void _onHorizontalSwipe(SwipeDirection direction) {
    if (_isSupportedDirection(direction)) {
      widget.onSwipe(direction);
    }
  }

  void _onVerticalSwipe(SwipeDirection direction) {
    if (_isSupportedDirection(direction)) {
      widget.onSwipe(direction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, BoxConstraints constraints) {
        return Listener(
          onPointerUp: (details) {
            final newPosition = details.localPosition;
            final diffX = (newPosition.dx).abs() - (_startPosition!.dx).abs();
            final diffY = (newPosition.dy).abs() - (_startPosition!.dy).abs();
            final velocityXAbs = max(diffX.abs(), 0.001);
            final velocityYAbs = max(diffY.abs(), 0.001);

            final delta = max(velocityXAbs, velocityYAbs) /
                min(velocityXAbs, velocityYAbs);
            final isAmbiguous = delta < 1.32;
            if (isAmbiguous) {
              return;
            }
            final isHorizontalSwipe = velocityXAbs > velocityYAbs;
            if (isHorizontalSwipe) {
              if (velocityXAbs < widget.velocityThreshhold) {
                return;
              }
              final fromLeft = newPosition.dx - _startPosition!.dx > 0;
              final direction = fromLeft
                  ? SwipeDirection.leftToRight
                  : SwipeDirection.rightToLeft;
              if (!_isSupportedDirection(direction)) {
                return;
              }
              if (widget.onlySwipesFromEdges) {
                if (fromLeft) {
                  if (_startPosition!.dx > widget.interactiveEdgeWidth) {
                    return;
                  }
                } else {
                  if (_startPosition!.dx <
                      constraints.biggest.width - widget.interactiveEdgeWidth) {
                    return;
                  }
                }
              }
              _onHorizontalSwipe(direction);
            } else {
              if (velocityYAbs < widget.velocityThreshhold) {
                return;
              }
              final fromTop = newPosition.dy - _startPosition!.dy > 0;
              final direction = fromTop
                  ? SwipeDirection.topToBottom
                  : SwipeDirection.bottomToTop;
              if (!_isSupportedDirection(direction)) {
                return;
              }
              if (widget.onlySwipesFromEdges) {
                if (fromTop) {
                  if (_startPosition!.dy > widget.interactiveEdgeWidth) {
                    return;
                  }
                } else {
                  if (_startPosition!.dy <
                      constraints.biggest.height -
                          widget.interactiveEdgeWidth) {
                    return;
                  }
                }
              }
              _onVerticalSwipe(direction);
            }
          },
          onPointerDown: (details) {
            _startPosition = details.localPosition;
            _lastMillis = _stopwatch.elapsed.inMilliseconds;
          },
          onPointerMove: (details) {
            final newMillis = _stopwatch.elapsed.inMilliseconds;
            final millisDiff = newMillis - _lastMillis;
            if (millisDiff >= 300) {
              _startPosition = details.localPosition;
              _lastMillis = newMillis;
            }
          },
          child: widget.child,
        );
      },
    );
  }
}
