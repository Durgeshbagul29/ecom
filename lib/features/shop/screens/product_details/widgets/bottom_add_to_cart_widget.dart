import 'package:ecom/common/widgets/icons/app_circular_icon.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomAddToCart extends StatelessWidget {
  const BottomAddToCart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace, vertical: AppSizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkerGrey : AppColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.cardRadiusLg),
          topRight: Radius.circular(AppSizes.cardRadiusLg)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const AppCircularIcon(icon: Iconsax.minus, backgroundColor: AppColors.darkGrey, width: 40, height: 40, color: AppColors.white),
              const SizedBox(width: AppSizes.spaceBtwItems),
              Text('2', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: AppSizes.spaceBtwItems),
              const AppCircularIcon(icon: Iconsax.add, backgroundColor: AppColors.darkGrey, width: 40, height: 40, color: AppColors.white),
            ],
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(AppSizes.md),
                backgroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.black)
              ),
              child: const Text('Add to cart'))
        ],
      ),
    );
  }
}
