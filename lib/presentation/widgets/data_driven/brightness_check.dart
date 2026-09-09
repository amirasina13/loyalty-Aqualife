import 'dart:async';

import 'package:screen_brightness/screen_brightness.dart';

class BrightnessCheck {
  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setSystemScreenBrightness(brightness);
    } catch (e) {
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetApplicationScreenBrightness();
    } catch (e) {
      throw 'Failed to reset brightness';
    }
  }

  Future<double> get systemBrightness async {
    try {
      return await ScreenBrightness().system;
    } catch (e) {
      // print(e);
      throw 'Failed to get system brightness';
    }
  }
}
