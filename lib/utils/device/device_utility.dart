import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppDeviceHelpers {
  /// Hide keyboard if open
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// Set Status Bar Color
  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  /// Check if device is in Landscape Orientation
  static bool isLandscapeOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom == 0;
  }

  /// Check if device is in Portrait Orientation
  static bool isPortraitOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom != 0;
  }

  /// Enable / Disable Full Screen
  static void setFullScreen(bool enable) {
      SystemChrome.setEnabledSystemUIMode(enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

  /// Screen Dimensions
  static double getScreenHeight() =>
      MediaQuery.of(Get.context!).size.height;

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getPixelRatio() =>
      MediaQuery.of(Get.context!).devicePixelRatio;

  static double getStatusBarHeight() =>
      MediaQuery.of(Get.context!).padding.top;

  static double getBottomNavigationBarHeight() =>
      kBottomNavigationBarHeight;

  static double getAppBarHeight() => kToolbarHeight;

  /// Keyboard
  static double getKeyboardHeight() {
    final viewInsets = MediaQuery.of(Get.context!).viewInsets;
    return viewInsets.bottom;
  }

  static Future<bool> isKeyboardVisible() async {
    final viewInsets = View.of(Get.context!).viewInsets;
    return viewInsets.bottom > 0;
  }

  /// Device Info
  static Future<bool> isPhysicalDevice() async {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Vibrate device
  static void vibrate(Duration duration) {
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }

  /// Preferred Orientation
  static Future<void> setPreferredOrientations(
      List<DeviceOrientation> orientations) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  /// Status Bar Controls
  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: []);
  }

  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
  }

  /// Internet Connection Check
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Platform Checks
  static bool isIOS() => Platform.isIOS;

  static bool isAndroid() => Platform.isAndroid;

  /// Launch a URL in external browser or app
  // static Future<void> launchUrl(String url) async {
  //   if (await canLaunchUrlString(url)) {
  //     await launchUrlString(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}