
import 'dart:async';
import 'package:belteiis_kids/core/constant/logger.dart';
import 'package:get/get.dart';

class TimerController extends GetxController {
//  final int initialSeconds;
  final void Function()? onTimeout;
  final void Function()? showMissionAlert;

  var seconds = 0.obs;
  var countTime = 0.obs;
  var missingTime = 0.obs;
  var isLowTime = false.obs;
  RxBool isRunning = false.obs;
  Timer? _timer;

  TimerController({
    // this.initialSeconds = 180,
    this.onTimeout,
    this.showMissionAlert,
  }) {
    // seconds.value = initialSeconds;
  }

  void resetTimer() {
    _timer?.cancel();
    // seconds.value = initialSeconds;
    countTime.value = 0;
    missingTime.value = 0;
    isRunning.value = false;
    isLowTime.value = false;
  }

  void startCountdown() {
    if (isRunning.value) {
      _timer?.cancel();
    }
    isRunning.value = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
        countTime.value++;
        missingTime.value++;
        isLowTime.value = seconds.value < 5;
        if (showMissionAlert != null) {
          showMissionAlert!();
        } else {
          Logger.error("Error: showMissionAlert is null"); // Debug log
        }
      } else {
        timer.cancel();
        isRunning.value = false;
        isLowTime.value = false;
        onTimeout?.call();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    isRunning.value = false;
  }

  void stopTimer() {
    _timer?.cancel();
    isRunning.value = false;
  }

  String get formattedTime {
    final minutes = seconds.value ~/ 60;
    final secs = seconds.value % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  String get formattedCountupTime {
    final minutes = countTime.value ~/ 60;
    final secs = countTime.value % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }




  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}