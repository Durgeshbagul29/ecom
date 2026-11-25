import 'package:ecom/common/widgets/buttons/app_elevated_button.dart';
import 'package:ecom/features/authentication/controllers/signup_controller.dart';
import 'package:ecom/features/authentication/screens/signup/privacy_policy_screen.dart';
import 'package:ecom/features/authentication/screens/signup/terms_of_use_screen.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/validators/validation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignUPForm extends StatelessWidget {
  const SignUPForm({super.key});

  @override
  Widget build(BuildContext context) {
    /// Create Signup Controller Instance
    final controller = Get.put(SignupController(), permanent: false);

    return Form(
      key: controller.signFormKey,
      child: Column(
        children: [
          /// First Name and Last Name
          Row(
            children: [
              /// First Name
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      AppValidator.validatedEmptyText(AppText.firstName, value),
                  decoration: InputDecoration(
                    labelText: AppText.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),

              SizedBox(width: AppSizes.spaceBtwInputFields),

              /// Last Name
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      AppValidator.validatedEmptyText(AppText.lastName, value),
                  decoration: InputDecoration(labelText: AppText.lastName),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: (value) => AppValidator.validateEmail(value!.trim()),
            decoration: InputDecoration(
              labelText: AppText.email,
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          SizedBox(height: AppSizes.spaceBtwInputFields),

          /// Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => AppValidator.validatePhoneNumber(value),
            decoration: InputDecoration(
              labelText: AppText.phoneNumber,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),

          SizedBox(height: AppSizes.spaceBtwInputFields),

          /// Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => AppValidator.validatePassword(value),
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

          /// Check Box Privacy Policy
          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: controller.privacyPolicy.value,
                  onChanged: (value) =>
                      controller.privacyPolicy.value = value ?? false,
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '${AppText.iAgreeTo} ',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => controller.privacyPolicy.value =
                              !controller.privacyPolicy.value,
                      ),
                      TextSpan(
                        text: '${AppText.privacyPolicy} ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => const PrivacyPolicyScreen()),
                      ),
                      TextSpan(
                        text: '${AppText.and} ',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => controller.privacyPolicy.value =
                              !controller.privacyPolicy.value,
                      ),
                      TextSpan(
                        text: '${AppText.termsOfUse} ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => const TermsOfUseScreen()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSizes.spaceBtwInputFields),

          /// Create Account Button
          AppElevatedButton(
            onPressed: () => controller.signup(),
            child: Text(AppText.signUp),
          ),
        ],
      ),
    );
  }
}
