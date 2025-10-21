import 'package:ecom/common/widgets/buttons/app_elevated_button.dart';
import 'package:ecom/features/authentication/controllers/login_controller.dart';
import 'package:ecom/features/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController(), permanent: false);

    return Form(
      key: controller.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email
          TextFormField(
            controller: controller.email,
            validator: (value) => AppValidator.validateEmail(value!.trim()),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: AppText.email,
            ),
          ),

          SizedBox(height: AppSizes.spaceBtwInputFields),

          // Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => AppValidator.validatePassword(value!.trim()),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: AppText.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value =
                      !controller.hidePassword.value,
                  icon: Icon(
                    controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                ),
              ),
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
                  Obx(
                    () => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) => controller.rememberMe.value =
                          !controller.rememberMe.value,
                    ),
                  ),
                  Text(AppText.rememberMe),
                ],
              ),

              // Forgot Password
              TextButton(
                child: Text(
                  AppText.forgetPassword,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Get.to(() => ForgotPasswordScreen()),
              ),
            ],
          ),

          SizedBox(height: AppSizes.spaceBtwSections),

          /// Buttons
          // Sign In Button
          AppElevatedButton(
            onPressed: () => controller.emailAndPasswordSignIn(),
            child: Text(AppText.signIn),
          ),
        ],
      ),
    );
  }
}
