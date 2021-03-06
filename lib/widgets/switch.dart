import 'package:clocker/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get_it/get_it.dart';

class DarkModeSwitch extends StatelessWidget {
  final Function(bool) onToggle;

  const DarkModeSwitch({Key? key, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    return ValueListenableBuilder(
      valueListenable: GetIt.I<AppState>().themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return Column(
          children: [
            Text('Cyberpunk', style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 2,
            ),
            FlutterSwitch(
              width: 45.0,
              height: 20.0,
              valueFontSize: 10.0,
              toggleSize: 17.0,
              value: currentMode == ThemeMode.dark,
              borderRadius: 20.0,
              activeColor: primaryColor,
              activeTextColor: onPrimaryColor,
              inactiveColor: primaryColor,
              inactiveTextColor: onPrimaryColor,
              toggleColor: onPrimaryColor,
              showOnOff: true,
              onToggle: onToggle,
            ),
          ],
        );
      },
    );
  }
}
