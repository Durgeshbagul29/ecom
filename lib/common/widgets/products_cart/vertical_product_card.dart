import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/styles/shadows.dart';
import 'package:ecom/common/widgets/icons/AppCircularIcon.dart';
import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/common/widgets/texts/product_title_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_fucations.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class VerticalProductCard extends StatelessWidget {
  const VerticalProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark Mode Variable
    final isDark = AppHelperFunctions.isDarkMode(context);

    /// Product Container with side padding, color, edges, radius and shadow
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
          color: isDark ? AppColors.darkerGrey : AppColors.white,
          boxShadow: [AppShadowStyle.verticalProductShadow]
        ),
        child: Column(
          children: [
            /// Product Image, Wishlist Button and Discount Tag
            CircularContainer(
              height: 180,
              padding: const EdgeInsets.all(AppSizes.sm),
              backgroundColor: isDark ? AppColors.dark : AppColors.light,
              child: Stack(
                children: [
                  /// Product Image
                  const AppRoundedImage(imageUrl: AppImages.belt, applyImageRadius: true),

                  /// Sale Tag
                  Positioned(
                    top: 12,
                    child: CircularContainer(
                      radius: AppSizes.sm,
                      backgroundColor: AppColors.yellow.withValues(alpha: 0.8),
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
                      child: Text('25%', style: Theme.of(context).textTheme.labelLarge!.apply(color: AppColors.secondary)),
                    ),
                  ),

                  /// Favourite Icon Button
                  Positioned(top:0, right: 0,child: const AppCircularIcon(icon: Iconsax.heart5, color: Colors.red))
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spaceBtwItems / 2),

            /// Product Details
            Padding(padding: const EdgeInsets.only(left: AppSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductTitleText(title: "Men's Brown Belt",smallSize: true,textAlign: TextAlign.left),
                const SizedBox(height: AppSizes.spaceBtwItems / 2),

                // Brand Text
                Row(
                  children: [
                    Text('Zara', overflow: TextOverflow.ellipsis, maxLines: 1, style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(width: AppSizes.sm),
                    Icon(Iconsax.verify5, color: AppColors.primary, size: AppSizes.iconXs)
                  ],
                ),

                // Maintain spacing between each field equally for all cards
                // Spacer(),

                // Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹100', maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineMedium),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.dark,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.cardRadiusMd),
                          bottomRight: Radius.circular(AppSizes.productImageRadius)
                        )
                      ),
                      child: const SizedBox(width: AppSizes.iconLg * 1.2, height: AppSizes.iconLg * 1.2,
                          child: Center(child: Icon(Iconsax.add, color: AppColors.white))),
                    )
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}