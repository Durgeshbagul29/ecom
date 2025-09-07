import 'package:ecom/common/widgets/buttons/app_elevated_button.dart';
import 'package:ecom/features/authentication/screens/signup/verify_email_screen.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class SignUPForm extends StatelessWidget {
  const SignUPForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          // First Name and Last Name
          Row(
            children: [

              // First Name
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: AppText.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),

              SizedBox(width: AppSizes.spaceBtwInputFields),

              // Last Name
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: AppText.lastName,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            decoration: InputDecoration(
              labelText: AppText.email,
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          SizedBox(height: AppSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            decoration: InputDecoration(
              labelText: AppText.phoneNumber,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),

          SizedBox(height: AppSizes.spaceBtwInputFields),

          // Password
          TextFormField(
            decoration: InputDecoration(
                labelText: AppText.password,
                prefixIcon: Icon(Icons.password),
                suffixIcon: Icon(Iconsax.eye)
            ),
          ),

          SizedBox(height: AppSizes.spaceBtwInputFields / 2),
          // Check Box Privacy Policy
          Row(
              children: [
                Checkbox(value: true, onChanged: (value){}),
                RichText(text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(text: '${AppText.iAgreeTo} '),
                      TextSpan(text: '${AppText.privacyPolicy} ',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primary, decoration: TextDecoration.underline, decorationColor: AppColors.primary)),
                      TextSpan(text: '${AppText.and} '),
                      TextSpan(text: '${AppText.termsOfUse} ',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primary, decoration: TextDecoration.underline, decorationColor: AppColors.primary))
                    ]
                ))
              ]
          ),

          SizedBox(height: AppSizes.spaceBtwInputFields),

          // Create Account Button
          AppElevatedButton(onPressed: () => Get.to(() => VerifyEmailScreen()), child: Text(AppText.signUp))
        ]
    );
  }
}