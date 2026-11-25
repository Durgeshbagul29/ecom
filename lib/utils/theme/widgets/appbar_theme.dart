import 'package:ecom/common/widgets/system_ui/app_system_ui_overlay.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class AppAppBarTheme {
  AppAppBarTheme._();

  static final lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: AppColors.black, size: AppSizes.iconMd),
    actionsIconTheme: const IconThemeData(color: AppColors.black, size: AppSizes.iconMd),
    titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.black),
    systemOverlayStyle: AppSystemUiOverlay.getOverlayStyle(isDark: false),
  );

  static final darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: AppColors.white, size: AppSizes.iconMd),
    actionsIconTheme: const IconThemeData(color: AppColors.white, size: AppSizes.iconMd),
    titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.white),
    systemOverlayStyle: AppSystemUiOverlay.getOverlayStyle(isDark: true),
  );
}