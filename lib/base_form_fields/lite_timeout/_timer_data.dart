part of '../../controllers/lite_timer_controller.dart';

class TimerData {
  TimerData({
    required this.name,
    required this.autostart,
    required this.groupName,
  });

  Timer? _timer;

  bool get isStarted {
    return _timer != null && _timer!.isActive;
  }

  final String name;
  final String groupName;
  bool autostart;
  int numSeconds = 0;

  void startTimer() {
    _timer ??= Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        liteTimerController.onTimer(this);
      },
    );
  }

  void clearTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String get keyName {
    return 'timer_data_$name';
  }
}
