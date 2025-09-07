import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo
        Image.asset(AppImages.ecomBlackLogo, height: AppSizes.imgLg),
        SizedBox(height: AppSizes.sm),
        // Title
        Text(
            AppText.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium
        ),
        SizedBox(height: AppSizes.sm),
        // Subtitle
        Text(
          AppText.loginSubTitle,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}