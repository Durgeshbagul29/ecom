import 'package:ecom/features/authentication/controllers/onboarding_controller.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OnBoardingSkipButton extends StatelessWidget {
  const OnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return TextButton(
      // Directly fetching from already created instance
      onPressed: () => OnBoardingController.instance.skipPage(),
      child: Text(
        "Skip",
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: isDark ? AppColors.grey : AppColors.secondary),
      ),
    );
  }
}
