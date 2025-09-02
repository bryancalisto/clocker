import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:clocker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

void setupWindow() {
  doWhenWindowReady(() {
    const initialSize = Size(200, 200);
    appWindow
      ..size = initialSize
      ..minSize = initialSize
      ..maxSize = initialSize
      ..alignment = Alignment.bottomRight
      ..show();
  });
}

Future<void> runCustomPlatformApp(void Function() runApp) async {
  final os = getOS();

  switch (os) {
    case 'linux':
      runApp();

      setupWindow();

      break;
    case 'windows':
      await Window.initialize();
      await Window.hideWindowControls();

      runApp();

      setupWindow();

      Window.setEffect(effect: WindowEffect.transparent);

      break;
    // TODO: Customize for macOS (window size is not initialized small)
    default:
      runApp();
  }
}
