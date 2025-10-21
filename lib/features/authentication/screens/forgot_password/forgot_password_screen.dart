import 'package:ecom/common/styles/padding.dart';
import 'package:ecom/common/widgets/buttons/app_elevated_button.dart';
import 'package:ecom/common/widgets/appbar/my_appbar.dart';
import 'package:ecom/features/authentication/controllers/forgot_password_controller.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/device/device_utility.dart';
import 'package:ecom/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController(), permanent: false);

    return Scaffold(
      appBar: MyAppBar(title: ''),
      // Using SingleChildScrollView not occurred render pixel error
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenNotTopPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Forgot Password Animation
              Center(
                child: Lottie.asset(
                  AppImages.forgotPasswordAnimation,
                  width: AppDeviceHelpers.getScreenWidth(context) * 0.6,
                  height: AppDeviceHelpers.getScreenHeight() * 0.4,
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwItems * 2),

              /// Title & Subtitle- [Header]
              // Title
              Text(
                AppText.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: AppSizes.spaceBtwItems / 2),

              // Subtitle
              Text(
                AppText.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
              ),

              SizedBox(height: AppSizes.spaceBtwSections),

              /// Form - [Forgot Password]
              Column(
                children: [
                  // Email
                  Form(
                    key: controller.forgotPasswordFormKey,
                    child: TextFormField(
                      controller: controller.email,
                      validator: AppValidator.validateEmail,
                      decoration: InputDecoration(
                        labelText: AppText.email,
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                  ),

                  SizedBox(height: AppSizes.spaceBtwItems),

                  AppElevatedButton(
                    onPressed: () => controller.sendResetPasswordEmail(),
                    child: Text(AppText.submit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
