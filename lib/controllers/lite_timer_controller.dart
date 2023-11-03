import 'dart:async';

import 'package:lite_state/lite_state.dart';

part '../base_form_fields/lite_timeout/_timer_data.dart';

LiteTimerController get liteTimerController {
  return findController<LiteTimerController>();
}

class LiteTimerController extends LiteStateController<LiteTimerController> {
  final Map<String, TimerData> _timerDatas = {};

  void onTimer(TimerData value) {
    rebuild();
  }

  int getNumSecondsLeftByName({
    required String timerName,
    required String groupName,
  }) {
    final key = '$groupName$timerName';
    final timerData = _timerDatas[key];
    if (timerData == null) {
      return 0;
    }
    return numSecondsLeft(timerData);
  }

  int numSecondsLeft(TimerData timerData) {
    if (!isActive(timerData)) {
      return timerData.numSeconds;
    }
    final now = DateTime.now();
    final expiration = _getExpirationDate(timerData)!;
    return expiration.difference(now).inSeconds;
  }

  @override
  void reset() {}

  TimerData tryStartTimer({
    required String timerName,
    required String groupName,
    required int seconds,
    required bool autostart,
  }) {
    TimerData? timerData;
    final key = '$groupName$timerName';
    if (!_timerDatas.containsKey(key)) {
      _timerDatas[key] = TimerData(
        name: timerName,
        groupName: groupName,
        autostart: autostart,
      );
    }
    timerData = _timerDatas[key]!;
    timerData.autostart = autostart;
    timerData.numSeconds = seconds;
    if (autostart) {
      tryActivateTimer(timerData);
    }
    return timerData;
  }

  Future tryActivateTimer(TimerData timerData) async {
    if (!isActive(timerData)) {
      final expirationDate = DateTime.now().add(
        Duration(
          seconds: timerData.numSeconds + 1,
        ),
      );
      await setPersistentValue<String>(
        timerData.keyName,
        expirationDate.toIso8601String(),
      );
      if (timerData.autostart) {
        timerData.startTimer();
      }
    }
  }

  Future resetTimerByName({
    required String timerName,
    required String groupName,
    int? numSeconds,
    bool forceStart = false,
  }) async {
    final timerData = _timerDatas['$groupName$timerName'];
    if (timerData != null) {
      await resetTimer(
        timerData: timerData,
        numSeconds: numSeconds,
        forceStart: forceStart,
      );
    }
  }

  Future startTimerByName({
    required String timerName,
    required String groupName,
  }) async {
    final timerData = _timerDatas['$groupName$timerName'];
    if (timerData != null) {
      tryActivateTimer(timerData);
      timerData.startTimer();
    }
  }

  Future resetTimer({
    required TimerData timerData,
    int? numSeconds,
    bool forceStart = false,
  }) async {
    if (numSeconds != null) {
      timerData.numSeconds = numSeconds;
    }
    await setPersistentValue<String>(
      timerData.keyName,
      null,
    );
    if (timerData.autostart || forceStart) {
      await tryActivateTimer(timerData);
    } else {
      timerData.clearTimer();
    }
    rebuild();
  }

  DateTime? _getExpirationDate(TimerData value) {
    String? timerExpiration = getPersistentValue<String>(value.keyName);
    if (timerExpiration == null) {
      return null;
    }
    return DateTime.tryParse(timerExpiration);
  }

  bool getIsActiveState({
    required String timerName,
    required String groupName,
  }) {
    final timerData = _timerDatas['$groupName$timerName'];
    if (timerData != null) {
      return isActive(timerData);
    }
    return false;
  }

  bool isActive(TimerData value) {
    final expirationDateTime = _getExpirationDate(value);
    if (expirationDateTime == null) {
      return false;
    }
    return DateTime.now().isBefore(expirationDateTime);
  }

  @override
  void onLocalStorageInitialized() {}
}
