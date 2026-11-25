
import 'package:ecom/common/styles/padding.dart';
import 'package:ecom/common/widgets/buttons/social_media_buttons.dart';
import 'package:ecom/common/widgets/login_signup/form_divider.dart';
import 'package:ecom/features/authentication/screens/login/widgets/login_form.dart';
import 'package:ecom/features/authentication/screens/login/widgets/login_header.dart';
import 'package:ecom/features/authentication/screens/signup/signup_screen.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: AppPadding.screenNotTopPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Logo, Title and Subtitle - [Header]
                LoginHeader(),
      
                SizedBox(height: AppSizes.spaceBtwSections),
      
                /// Login Form
                LoginForm(),
      
                SizedBox(height: AppSizes.spaceBtwSections),
      
                /// Form Divider
                AppFormDivider(title: AppText.orSignInWith,),
      
                SizedBox(height: AppSizes.spaceBtwSections),
      
                /// Login Social Buttons
                AppSocialButtons(),
      
                SizedBox(height: AppSizes.spaceBtwSections),
      
                /// SignUp Screen Root
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(AppText.noAccount, style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(onPressed: () => Get.to(() => SignUpScreen()), child: Text(AppText.signUp, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)))
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