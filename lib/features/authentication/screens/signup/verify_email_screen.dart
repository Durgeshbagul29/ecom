import 'package:ecom/common/styles/padding.dart';
import 'package:ecom/common/widgets/buttons/App_elevated_button.dart';
import 'package:ecom/common/widgets/screens/success_screen.dart';
import 'package:ecom/features/authentication/screens/login/login_screen.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/device/device_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => LoginScreen()),
            icon: Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenPadding,
          child: Column(
            children: [
              /// Image Email Send
              Image.asset(
                AppImages.mailSentImage,
                height: AppDeviceHelpers.getScreenHeight() * 0.4,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              /// Title
              Text(
                AppText.verifyEmailTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              /// Email
              Text(
                'example@gmail.com',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              /// Subtitle
              Text(
                AppText.verifyEmailSubTitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.spaceBtwSections),

              /// Continue Button
              AppElevatedButton(
                onPressed: () => Get.to(
                  () => SuccessScreen(
                    title: AppText.accountCreatedTitle,
                    subTitle: AppText.accountCreatedSubTitle,
                    image: AppImages.successDoneAnimation,
                    onTap: () {},
                  ),
                ),
                child: Text(AppText.myContinue),
              ),

              SizedBox(height: AppSizes.spaceBtwItems / 2),

              /// Resend Email Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: Text(AppText.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
