import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable widget to manage edge-to-edge status bar & navigation bar overlays.
class AppSystemUiOverlay extends StatelessWidget {
  const AppSystemUiOverlay({
    super.key,
    required this.child,
    this.statusBarColor,
    this.statusBarIconBrightness,
    this.navigationBarColor,
    this.navigationBarIconBrightness,
  });

  final Widget child;
  final Color? statusBarColor;
  final Brightness? statusBarIconBrightness;
  final Color? navigationBarColor;
  final Brightness? navigationBarIconBrightness;

  /// Returns standard edge-to-edge overlay style based on dark mode
  static SystemUiOverlayStyle getOverlayStyle({
    required bool isDark,
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
    Color? navigationBarColor,
    Brightness? navigationBarIconBrightness,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor ?? Colors.transparent,
      statusBarIconBrightness:
          statusBarIconBrightness ?? (isDark ? Brightness.light : Brightness.dark),
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: navigationBarColor ?? Colors.transparent,
      systemNavigationBarIconBrightness:
          navigationBarIconBrightness ?? (isDark ? Brightness.light : Brightness.dark),
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyle(
        isDark: isDark,
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
        navigationBarColor: navigationBarColor,
        navigationBarIconBrightness: navigationBarIconBrightness,
      ),
      child: child,
    );
  }
}
