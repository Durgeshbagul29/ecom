
import 'package:ecom/features/authentication/controllers/onboarding_controller.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class PageNavigationIndicator extends StatelessWidget {
  const PageNavigationIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
      bottom: AppDeviceHelpers.getBottomNavigationBarHeight() * 3,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: const ExpandingDotsEffect(dotHeight: 6, activeDotColor: AppColors.primary),
        ),
      ),
    );
  }
}
