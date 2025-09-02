import 'dart:io';

import 'package:clocker/controllers/timer.dart';
import 'package:clocker/factories/keyboard_listener.dart';
import 'package:clocker/state.dart';
import 'package:clocker/styles.dart';
import 'package:clocker/utils/theme.dart';
import 'package:clocker/utils/utils.dart';
import 'package:clocker/widgets/button.dart';
import 'package:clocker/widgets/switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class TimerVw extends StatefulWidget {
  const TimerVw({Key? key}) : super(key: key);

  @override
  TimerVwState createState() => TimerVwState();
}

class TimerVwState extends State<TimerVw> {
  final _timer = TimerController();
  late FocusNode _node;
  bool _isSettingTime = false;
  int _selectedHours = 0;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _node = FocusNode();
    _timer.ticksStream.listen((event) {
      setState(() {});
    });
    _timer.finishedStream.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancelTimer();
    super.dispose();
  }

  void _run() {
    _timer.run();
    setState(() {});
  }

  void _pause() {
    _timer.pause();
    setState(() {});
  }

  void _restart() {
    _timer.restart();
    setState(() {});
  }

  void _reset() {
    _timer.reset();
    setState(() {
      _selectedHours = 0;
      _selectedMinutes = 0;
      _selectedSeconds = 0;
    });
  }

  void _quit() {
    _timer.cancelTimer();
    exit(0);
  }

  void _setTime() {
    setState(() {
      _isSettingTime = true;
      _selectedHours = _timer.hours;
      _selectedMinutes = _timer.minutes;
      _selectedSeconds = _timer.seconds;
    });
  }

  void _confirmTime() {
    _timer.setTime(
      h: _selectedHours,
      m: _selectedMinutes,
      s: _selectedSeconds,
    );
    setState(() {
      _isSettingTime = false;
    });
  }

  void _cancelSetTime() {
    setState(() {
      _isSettingTime = false;
      _selectedHours = _timer.hours;
      _selectedMinutes = _timer.minutes;
      _selectedSeconds = _timer.seconds;
    });
  }

  Widget _buildTimeSelector() {
    final isDark = GetIt.I<AppState>().themeNotifier.value == ThemeMode.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    
    return Container(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: _selectedHours,
              ),
              itemExtent: 50,
              onSelectedItemChanged: (value) {
                setState(() {
                  _selectedHours = value;
                });
              },
              children: List.generate(24, (index) {
                return Center(
                  child: Text(
                    pad(index),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                );
              }),
            ),
          ),
          Text(
            ':',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(
            width: 100,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: _selectedMinutes,
              ),
              itemExtent: 50,
              onSelectedItemChanged: (value) {
                setState(() {
                  _selectedMinutes = value;
                });
              },
              children: List.generate(60, (index) {
                return Center(
                  child: Text(
                    pad(index),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                );
              }),
            ),
          ),
          Text(
            ':',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(
            width: 100,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: _selectedSeconds,
              ),
              itemExtent: 50,
              onSelectedItemChanged: (value) {
                setState(() {
                  _selectedSeconds = value;
                });
              },
              children: List.generate(60, (index) {
                return Center(
                  child: Text(
                    pad(index),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return createKeyboardListener(
      {
        ' ': () {
          if (!_isSettingTime) {
            _timer.state == TimerState.running ? _pause() : _run();
          }
        },
        'q': _quit,
        'r': _restart,
        's': () {
          if (!_isSettingTime && _timer.state == TimerState.off) {
            _setTime();
          }
        },
        't': () => setTheme(GetIt.I<AppState>().themeNotifier.value != ThemeMode.dark),
      },
      _node,
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isSettingTime) ...[
              _buildTimeSelector(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _confirmTime,
                    child: const Text('Set'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _cancelSetTime,
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${pad(_timer.hours)}:', style: kTimeNumbersStyle),
                  Text('${pad(_timer.minutes)}:', style: kTimeNumbersStyle),
                  Text(pad(_timer.seconds), style: kTimeNumbersStyle),
                ],
              ),
              const DarkModeSwitch(onToggle: setTheme, key: Key('themeSwitch')),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_timer.state == TimerState.off &&
                      (_timer.hours == 0 &&
                          _timer.minutes == 0 &&
                          _timer.seconds == 0)) ...[
                    Button(
                      onPressed: _setTime,
                      icon: Icons.timer,
                    ),
                  ] else ...[
                    Button(
                      onPressed: () {
                        if (_timer.state == TimerState.running) {
                          _pause();
                        } else {
                          _run();
                        }
                      },
                      icon: _timer.state == TimerState.running
                          ? kPauseIcon
                          : kPlayIcon,
                    ),
                    const SizedBox(width: 5),
                    Button(
                      onPressed: _restart,
                      icon: kRestartIcon,
                    ),
                    const SizedBox(width: 5),
                    Button(
                      onPressed: _reset,
                      icon: Icons.clear,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}