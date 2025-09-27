import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ProductImageSlider extends StatelessWidget {
  const ProductImageSlider({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    /// Dark Mode
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: 30,
      right: 0,
      left: AppSizes.sm,
      child: SizedBox(
        height: 80,
        child: ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceBtwItems),
            itemBuilder: (_, index) => AppRoundedImage(
                imageUrl: AppImages.shirt2,
                backgroundColor: isDark ? AppColors.dark : AppColors.white,
                width: 80, fit: BoxFit.contain,
                border: Border.all(color: AppColors.primary),
                padding: EdgeInsets.all(AppSizes.sm)
            )
        ),
      ),
    );
  }
}
