import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/images_design/app_circular_iamge.dart';
import 'package:ecom/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:ecom/common/widgets/texts/product_price_text.dart';
import 'package:ecom/common/widgets/texts/product_title_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/enums.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ProductMetaData extends StatelessWidget {
  const ProductMetaData({super.key});

  @override
  Widget build(BuildContext context) {
    /// Dark Variable
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price, Title, Stock and Brand
        Row(
          children: [
            // ----- Sale Tag -----
            CircularContainer(
              radius: AppSizes.sm,
              backgroundColor: AppColors.yellow.withValues(alpha: 0.8),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
              child: Text('25%', style: Theme.of(context).textTheme.labelLarge!.apply(color: AppColors.secondary)),
            ),
            const SizedBox(width: AppSizes.spaceBtwItems),

            // ----- Price -----
            ProductPriceText(price: '110', lineThrough: true),
            const SizedBox(width: AppSizes.spaceBtwItems),
            const ProductPriceText(price: '99', isLarge: true)
          ],
        ),
        const SizedBox(height: AppSizes.spaceBtwItems / 1.5),
        
        /// Title
        const ProductTitleText(title: 'Blue Indian Odee'),
        const SizedBox(height: AppSizes.spaceBtwItems / 1.5),

        /// Stock Status
        Row(
          children: [
            const ProductTitleText(title: 'Status'),
            const SizedBox(width: AppSizes.spaceBtwItems),
            Text('In Stock', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: AppSizes.spaceBtwItems / 1.5),

        /// Brand
        Row(
          children: [
            AppCircularImage(
                image: AppImages.nike, height: 32, width: 32, padding: 0,
                overlayColor: isDark ? AppColors.white : AppColors.charcoalBlack,
                fit: BoxFit.contain),
            const BrandTitleTextWithVerifiedIcon(title: 'Zara', brandTextSize: TextSizes.medium),
          ],
        )

      ],
    );
  }
}
