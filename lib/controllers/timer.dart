import 'dart:async';

enum TimerState {
  off,
  running,
  paused,
}

class TimerController {
  TimerState state = TimerState.off;
  int initialHours = 0;
  int initialMinutes = 0;
  int initialSeconds = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  Timer? _timer;
  final _ticksEmitter = StreamController();
  Stream get ticksStream => _ticksEmitter.stream;
  final _finishedEmitter = StreamController();
  Stream get finishedStream => _finishedEmitter.stream;

  void setTime({required int h, required int m, required int s}) {
    initialHours = h;
    initialMinutes = m;
    initialSeconds = s;
    hours = h;
    minutes = m;
    seconds = s;
    _ticksEmitter.add(null);
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  void run() {
    if (hours == 0 && minutes == 0 && seconds == 0) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else if (minutes > 0) {
        minutes--;
        seconds = 59;
      } else if (hours > 0) {
        hours--;
        minutes = 59;
        seconds = 59;
      }

      _ticksEmitter.add(null);

      if (hours == 0 && minutes == 0 && seconds == 0) {
        timer.cancel();
        state = TimerState.off;
        _finishedEmitter.add(null);
      }
    });

    state = TimerState.running;
  }

  void pause() {
    cancelTimer();
    state = TimerState.paused;
  }

  void restart() {
    cancelTimer();
    hours = initialHours;
    minutes = initialMinutes;
    seconds = initialSeconds;
    state = TimerState.off;
    _ticksEmitter.add(null);
  }

  void reset() {
    cancelTimer();
    hours = 0;
    minutes = 0;
    seconds = 0;
    initialHours = 0;
    initialMinutes = 0;
    initialSeconds = 0;
    state = TimerState.off;
    _ticksEmitter.add(null);
  }
}