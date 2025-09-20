import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/device/device_utility.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.text,
    this.icon,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap, this.padding = const EdgeInsets.symmetric(horizontal : AppSizes.defaultSpace)
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // Dark Mode
    final isDark = AppHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: AppDeviceHelpers.getScreenWidth(context),
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
              color: showBackground ? isDark ? AppColors.dark : AppColors.light : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              border: showBorder ? Border.all(color: AppColors.grey) : null
          ),
          child: Row(
            children: [
              Icon(icon, color: isDark ? AppColors.darkGrey : AppColors.darkerGrey), const SizedBox(width: AppSizes.spaceBtwItems),
              Text(text, style: Theme.of(context).textTheme.bodySmall)
            ],
          ),
        ),
      ),
    );
  }
}