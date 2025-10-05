import 'package:ecom/common/widgets/icons/app_circular_icon.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductQuantityAddRemove extends StatelessWidget {
  const ProductQuantityAddRemove({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Remove Button
        AppCircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: AppSizes.md,
          color: isDark ? AppColors.white : AppColors.charcoalBlack,
          backgroundColor: isDark ? AppColors.darkerGrey : AppColors.light,
        ),
        const SizedBox(width: AppSizes.spaceBtwItems),
        Text('3', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: AppSizes.spaceBtwItems),

        /// Add Button
        AppCircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: AppSizes.md,
          color: AppColors.white,
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }
}
