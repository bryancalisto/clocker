import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:clocker/utils/utils.dart';
import 'package:flutter/material.dart';

Widget createPlatformWrapper(Widget child) {
  final os = getOS();

  switch (os) {
    case 'linux':
    case 'windows':
      return MoveWindow(child: child);
    // TODO: Add support for macOS
    default:
      return Container(child: child);
  }
}
