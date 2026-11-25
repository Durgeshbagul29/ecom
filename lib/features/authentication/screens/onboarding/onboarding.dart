import 'package:ecom/common/widgets/system_ui/app_system_ui_overlay.dart';
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

    return AppSystemUiOverlay(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
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
                const PageNavigationIndicator(),

                /// Bottom buttons with transition
                Positioned(
                  left: 0,
                  right: 0,
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
                          ? const SizedBox(
                              width: double.infinity,
                              child: OnBoardingStartedButton(),
                            )
                          : const Row(
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
        ),
      ),
    );
  }
}
