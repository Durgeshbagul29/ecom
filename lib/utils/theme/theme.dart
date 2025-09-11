import 'package:ecom/utils/theme/widgets/appbar_theme.dart';
import 'package:ecom/utils/theme/widgets/bottom_sheet_theme.dart';
import 'package:ecom/utils/theme/widgets/checkbox_theme.dart';
import 'package:ecom/utils/theme/widgets/chip_theme.dart';
import 'package:ecom/utils/theme/widgets/elevated_button_theme.dart';
import 'package:ecom/utils/theme/widgets/outlined_button_theme.dart';
import 'package:ecom/utils/theme/widgets/text_field_theme.dart';
import 'package:ecom/utils/theme/widgets/text_theme.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AppTheme {
  /// singleton cls constructor
  AppTheme._();

  // light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    disabledColor: AppColors.grey,
    textTheme: AppTextTheme.lightTextTheme,
    chipTheme: AppChipTheme.lightChipTheme,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppAppBarTheme.lightAppBarTheme,
    checkboxTheme: AppCheckBoxTheme.lightCheckboxTheme,
    bottomSheetTheme: AppBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: AppTextFieldTheme.lightInputDecorationTheme,
  );

  // dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    disabledColor: AppColors.grey,
    textTheme: AppTextTheme.darkTextTheme,
    chipTheme: AppChipTheme.darkChipTheme,
    scaffoldBackgroundColor: AppColors.charcoalBlack,
    appBarTheme: AppAppBarTheme.darkAppBarTheme,
    checkboxTheme: AppCheckBoxTheme.darkCheckboxTheme,
    bottomSheetTheme: AppBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: AppTextFieldTheme.darkInputDecorationTheme,
  );
}
