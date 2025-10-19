import 'package:ecom/common/styles/padding.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../buttons/app_elevated_button.dart';


class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.title, required this.subTitle, required this.onTap, required this.image});

  // Variables Declaration
  final String image;
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenPadding,
          child: Column(
            children: [
              /// Account Created Image
              Lottie.asset(image, height: AppDeviceHelpers.getScreenWidth(context) * 0.6),
              SizedBox(height: AppSizes.spaceBtwSections),

              /// Title
              Text(
               title,
                style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              /// Subtitle
              Text(
                subTitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center
              ),
              SizedBox(height: AppSizes.spaceBtwSections),

              /// Continue Button
              AppElevatedButton(onPressed: onTap , child: Text(AppText.myContinue)),
            ],
          ),
        ),
      ),
    );
  }
}
