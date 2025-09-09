import 'package:ecom/common/widgets/buttons/app_elevated_button.dart';
import 'package:ecom/features/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'package:ecom/navigation_menu.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            labelText: AppText.email,
          ),
        ),

        SizedBox(height: AppSizes.spaceBtwInputFields),

        // Password
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.password),
            labelText: AppText.password,
            suffixIcon: Icon(Iconsax.eye),
          ),
        ),

        SizedBox(height: AppSizes.spaceBtwInputFields / 2),

        /// Remember Me CheckBox and Forgot Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Remember Me
            Row(
              children: [
                Checkbox(value: true, onChanged: (value) {}),
                Text(AppText.rememberMe),
              ],
            ),

            // Forgot Password
            TextButton(
              child: Text(AppText.forgetPassword, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600)),
              onPressed: () => Get.to(() =>  ForgotPasswordScreen()),
            ),
          ],
        ),

        SizedBox(height: AppSizes.spaceBtwSections),

        /// Buttons
        // Sign In Button
        AppElevatedButton(
          onPressed: () => Get.to(() => NavigationMenu()),
          child: Text(AppText.signIn),
        ),

        // SizedBox(height: AppSizes.spaceBtwItems / 2),
        //
        // // Create Account
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton(
        //     onPressed: () => Get.to(() => SignUpScreen()),
        //     child: Text(AppText.createAccount),
        //   ),
        // ),
      ],
    );
  }
}
