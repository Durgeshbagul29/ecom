import 'package:ecom/common/styles/padding.dart';
import 'package:ecom/common/widgets/buttons/social_media_buttons.dart';
import 'package:ecom/common/widgets/login_signup/form_divider.dart';
import 'package:ecom/common/widgets/appbar/my_appbar.dart';
import 'package:ecom/features/authentication/screens/login/login_screen.dart';
import 'package:ecom/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(showLogo: true),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: AppPadding.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// SignUp Header
                Text(
                  AppText.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                // SizedBox(height: AppSizes.spaceBtwItems / 2),
                // Text(
                //   AppText.signupSubTitle,
                //   style: Theme.of(context).textTheme.bodyLarge,
                // ),

                SizedBox(height: AppSizes.spaceBtwSections),

                /// SignUp Form
                SignUPForm(),

                SizedBox(height: AppSizes.spaceBtwSections),

                /// Form Divider
                AppFormDivider(title: AppText.orSignupWith),

                SizedBox(height: AppSizes.spaceBtwSections),

                /// Login Social Buttons
                AppSocialButtons(),

                SizedBox(height: AppSizes.spaceBtwSections),

                /// Login Screen Root
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(AppText.haveAccount, style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(onPressed: () => Get.to(() => LoginScreen()), child: Text(AppText.signIn, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
