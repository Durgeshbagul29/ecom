import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AppSocialButtons extends StatelessWidget {
  const AppSocialButtons({super.key});


  @override
  Widget build(BuildContext context) {
    // Dark Mode variable
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Button
        socialButton(AppImages.googleIcon, () {}, isDark),
        SizedBox(width: AppSizes.spaceBtwItems),
        // Facebook Button
        socialButton(AppImages.facebookIcon, () {}, isDark),
        SizedBox(width: AppSizes.spaceBtwItems),
        // Apple Button
        socialButton(AppImages.twitterIcon, () {}, isDark),
      ],
    );
  }

  Widget socialButton(String image, VoidCallback onPressed, bool isDark) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.borderRadiusLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBlack : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusXl),
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: AppSizes.borderRadiusSm,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(
          image,
          height: AppSizes.iconMd,
          width: AppSizes.iconMd,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
