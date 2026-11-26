
import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/features/personalization/controllers/update_name_controller.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());

    return Scaffold(
      // Custom AppBar
      appBar: CustomAppBar(
        showBackArrow: true,
        title: Text(
          'Change Name',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              'Use real name for easy verification. This name will appear on several pages.',
              style: Theme.of(context).textTheme.labelMedium,
            ),

            const SizedBox(height: AppSizes.spaceBtwSections),

            // Text fields
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  // First Name
                  TextFormField(
                    controller: controller.firstName,
                    validator: (value) =>
                        AppValidator.validatedEmptyText('First name', value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: AppText.firstName,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),

                  const SizedBox(
                    height: AppSizes.spaceBtwInputFields,
                  ),

                  // Last Name
                  TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>
                        AppValidator.validatedEmptyText('Last name', value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: AppText.lastName,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateUserName(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
