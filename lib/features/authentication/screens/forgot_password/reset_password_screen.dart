
import 'package:ecom/common/styles/padding.dart';
import 'package:ecom/common/widgets/buttons/app_elevated_button.dart';
import 'package:ecom/features/authentication/controllers/forgot_password_controller.dart';
import 'package:ecom/features/authentication/screens/login/login_screen.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/device/device_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
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
                height: AppDeviceHelpers.getScreenHeight() * 0.3,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              /// Title
              Text(
                AppText.resetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              /// Email
              Text(email, style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: AppSizes.spaceBtwItems),

              /// Subtitle
              Text(
                AppText.resetPasswordSubTitle,
                style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.center
              ),
              SizedBox(height: AppSizes.spaceBtwSections),

              /// Done Button
              AppElevatedButton(onPressed: () => Get.offAll(() => const LoginScreen()), child: Text(AppText.done)),

              SizedBox(height: AppSizes.spaceBtwItems / 2),

              /// Resend Email Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => ForgotPasswordController.instance.resendResetPasswordEmail(email),
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
