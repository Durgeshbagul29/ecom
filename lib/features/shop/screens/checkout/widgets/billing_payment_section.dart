import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class BillingPaymentSection extends StatelessWidget {
  const BillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        AppSectionHeading(title: 'Payment Method', buttonTitle: 'Change', onPressed: (){}),
        const SizedBox(height: AppSizes.spaceBtwItems / 2),

        Row(
          children: [
            CircularContainer(
              width: 60,
              height: 35,
              backgroundColor: isDark ? AppColors.light : AppColors.white,
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Image(image: AssetImage(AppImages.drinks), fit: BoxFit.contain),
            ),
            const SizedBox(width: AppSizes.spaceBtwItems / 2),
            Text('Phone Pay', style: Theme.of(context).textTheme.bodyLarge),
          ],
        )
      ],
    );
  }
}