
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key, required this.animationImage, required this.title, required this.subTitle,
  });

  final String animationImage, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppDeviceHelpers.getAppBarHeight()),
      child: Column(
        children: [
          Lottie.asset(animationImage, width: AppDeviceHelpers.getScreenWidth(context) * 0.8, height: AppDeviceHelpers.getScreenWidth(context) * 0.8 ),
          const SizedBox(height: AppSizes.spaceBtwItems),
          Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
          const SizedBox(height: AppSizes.spaceBtwInputFields),
          Text(subTitle, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
