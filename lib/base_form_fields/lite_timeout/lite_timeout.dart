import 'package:flutter/material.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/controllers/lite_timer_controller.dart';
import 'package:lite_forms/intl_local/lib/intl.dart';
import 'package:lite_forms/lite_forms.dart';

class LiteTimeout extends StatefulWidget {
  LiteTimeout({
    Key? key,
    this.pattern = 'mm:ss',
    required this.name,
    this.startedText = '',
    this.notStartedText = '',
    this.textAlign = TextAlign.center,
    this.style,
    this.autostart = true,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.seconds = 10,
  }) : super(key: key ?? Key(name));

  final String name;

  /// [autostart] whether the timer must start immediately or not
  /// if you pass [false], then the timer has to be started manually
  /// by calling a shorthand of form('timerName').timer.start()
  final bool autostart;
  final int seconds;
  final String pattern;
  final String startedText;
  final String notStartedText;
  final TextStyle? style;
  final TextAlign textAlign;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;

  @override
  State<LiteTimeout> createState() => _LiteTimeoutState();
}

class _LiteTimeoutState extends State<LiteTimeout> {
  TimerData? _timerData;
  late DateFormat _dateFormat;

  @override
  void initState() {
    _dateFormat = DateFormat(widget.pattern);
    super.initState();
  }

  bool get _isStarted {
    return _timerData!.isStarted;
  }

  int get _numSecondsLeft {
    return liteTimerController.numSecondsLeft(_timerData!);
  }

  String get _text {
    if (!_isStarted) {
      return widget.notStartedText;
    }
    final date = DateTime(1, 1, 1, 0, 0, _numSecondsLeft);
    return '${widget.startedText} ${_dateFormat.format(date)}';
  }

  @override
  void dispose() {
    _timerData?.clearTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = LiteFormGroup.of(context)!;
    if (_timerData == null) {
      _timerData = liteTimerController.tryStartTimer(
        seconds: widget.seconds,
        timerName: widget.name,
        autostart: widget.autostart,
        groupName: group.name,
      );
      if (widget.autostart || liteTimerController.isActive(_timerData!)) {
        _timerData!.startTimer();
      }
    }
    return LiteState<LiteTimerController>(
      builder: (BuildContext c, LiteTimerController controller) {
        final textStyle = widget.style ??
            liteFormController.config?.defaultTextStyle ??
            Theme.of(context).textTheme.bodyMedium;
        if (_numSecondsLeft <= 0) {
          controller.resetTimer(
            timerData: _timerData!,
          );
        }
        return Padding(
          padding: EdgeInsets.only(
            top: widget.paddingTop,
            bottom: widget.paddingBottom,
            left: widget.paddingLeft,
            right: widget.paddingRight,
          ),
          child: Text(
            _text,
            style: textStyle,
            textAlign: widget.textAlign,
          ),
        );
      },
    );
  }
}
