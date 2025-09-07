import 'package:ecom/features/authentication/controllers/onboarding_controller.dart';
import 'package:ecom/features/authentication/screens/onboarding/widgets/onboarding_dots_navigation.dart';
import 'package:ecom/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:ecom/features/authentication/screens/onboarding/widgets/onboarding_page_view.dart';
import 'package:ecom/features/authentication/screens/onboarding/widgets/onboarding_skip_button.dart';
import 'package:ecom/features/authentication/screens/onboarding/widgets/onboarding_started_button.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instance of OnBoarding Controller using put method in GetX
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
        child: Stack(
          children: [
            /// Scrollable Page
            PageView(
              controller: controller.pageController,
              onPageChanged: (value) => controller.updatePageIndicator(value),
              children: [
                // add OnBoardingPage with Data
                OnBoardingPageView(
                  animationImage: AppImages.shoppingAnimation,
                  title: AppText.onBoardingTitle1,
                  subTitle: AppText.onBoardingSubTitle1,
                ),
                OnBoardingPageView(
                  animationImage: AppImages.mobileEComAnimation,
                  title: AppText.onBoardingTitle2,
                  subTitle: AppText.onBoardingSubTitle2,
                ),
                OnBoardingPageView(
                  animationImage: AppImages.workHouseDeliveryAnimation,
                  title: AppText.onBoardingTitle3,
                  subTitle: AppText.onBoardingSubTitle3,
                ),
              ],
            ),

            /// Indictor
            PageNavigationIndicator(),

            /// Bottom buttons with transition
            Positioned(
              left: AppSizes.defaultSpace,
              right: AppSizes.defaultSpace,
              bottom: AppSizes.spaceBtwItems,
              child: Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.horizontal,
                      child: child,
                    );
                  },
                  child: controller.currentIndex.value == 2
                      ? SizedBox(
                          width: double.infinity,
                          child: OnBoardingStartedButton(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Skip Button
                            OnBoardingSkipButton(),
                            // Next Button
                            OnBoardingNextButton(),
                          ],
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
