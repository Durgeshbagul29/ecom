import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class AppTextTheme {
  /// Singleton cls
  AppTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    /// heading text
    headlineLarge: TextStyle().copyWith(fontSize: 32.0,fontWeight: FontWeight.bold,color: AppColors.dark),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0,fontWeight: FontWeight.w600,color: AppColors.dark),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0,fontWeight: FontWeight.w600,color: AppColors.dark),

    /// title text
    titleLarge: const TextStyle().copyWith(fontSize: 16.0,fontWeight: FontWeight.w600,color: AppColors.dark),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0,fontWeight: FontWeight.w500,color: AppColors.dark),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0,fontWeight: FontWeight.w400,color: AppColors.dark),

    /// body text
    bodyLarge: const TextStyle().copyWith(fontSize: 14.0,fontWeight: FontWeight.w500,color: AppColors.dark),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0,fontWeight: FontWeight.normal,color: AppColors.dark),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.dark.withValues(alpha: 0.5)),

    /// label text
    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.dark),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0,fontWeight: FontWeight.normal, color: AppColors.dark.withValues(alpha: 0.5),
    ),

  );

  static TextTheme darkTextTheme = TextTheme(
    /// heading text
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: AppColors.light),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: AppColors.light),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.light),

    /// title text
    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.light),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.light),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: AppColors.light),

    /// body text
    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.light),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: AppColors.light),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.light.withValues(alpha: 0.5)),

    /// lable text
    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.light),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.light.withValues(alpha: 0.5)),
  );
}
