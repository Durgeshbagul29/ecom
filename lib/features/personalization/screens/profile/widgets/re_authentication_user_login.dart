
import 'package:ecom/features/personalization/controllers/user_controller.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Re-Authenticate User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email
                TextFormField(
                  controller: controller.verifyEmail,
                  validator: AppValidator.validateEmail,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: AppText.email,
                  ),
                ),

                const SizedBox(
                  height: AppSizes.spaceBtwInputFields,
                ),

                // Password
                Obx(
                      () => TextFormField(
                    obscureText: controller.hidePassword.value,
                    controller: controller.verifyPassword,
                    validator: (value) =>
                        AppValidator.validatedEmptyText('Password', value),
                    decoration: InputDecoration(
                      labelText: AppText.password,
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.hidePassword.value =
                          !controller.hidePassword.value;
                        },
                        icon: Icon(
                          controller.hidePassword.value
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.reAuthenticateEmailAndPassword(),
                    child: const Text('Verify'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
