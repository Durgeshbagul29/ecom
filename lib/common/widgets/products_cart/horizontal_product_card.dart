import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/icons/app_circular_icon.dart';
import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:ecom/common/widgets/texts/product_price_text.dart';
import 'package:ecom/common/widgets/texts/product_title_text.dart';
import 'package:ecom/features/shop/screens/product_details/product_details_screen.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HorizontalProductCard extends StatelessWidget {
  const HorizontalProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark Mode Variable
    final isDark = AppHelperFunctions.isDarkMode(context);

    /// Product Container with side padding, color, edges, radius and shadow
    return GestureDetector(
      onTap: () => Get.to(() => const ProductDetailsScreen()),
      child: Container(
        width: 310,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
          color: isDark ? AppColors.darkerGrey : AppColors.lightContainer,
        ),

        child: Row(
          children: [
            /// Product Image, Wishlist Button and Discount Tag
            CircularContainer(
              height: 120,
              padding: const EdgeInsets.all(AppSizes.sm),
              backgroundColor: isDark ? AppColors.dark : AppColors.light,

              child: Stack(
                children: [
                  /// Product Image
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: const AppRoundedImage(
                      imageUrl: AppImages.belt,
                      applyImageRadius: true,
                      fit: BoxFit.contain,
                    ),
                  ),

                  /// Sale Tag
                  Positioned(
                    top: 12,
                    child: CircularContainer(
                      radius: AppSizes.sm,
                      backgroundColor: AppColors.yellow.withValues(alpha: 0.8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      child: Text(
                        '25%',
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),

                  /// Favourite Icon Button
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: const AppCircularIcon(
                      icon: Iconsax.heart5,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            /// Product Details
            SizedBox(
              width: 172,
              child: Padding(
                padding: EdgeInsets.only(left: AppSizes.sm, top: AppSizes.sm),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductTitleText(
                          title: "Men's Brown Belt",
                          smallSize: true,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: AppSizes.spaceBtwItems / 2),
                        // Brand Text With Verified Icon
                        BrandTitleTextWithVerifiedIcon(title: 'Nike'),
                      ],
                    ),

                    // Maintain spacing between each field equally for all cards
                    const Spacer(),

                    /// Price and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product Price
                        Flexible(child: const ProductPriceText(price: '100')),

                        // Add to cart
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.dark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppSizes.cardRadiusMd),
                              bottomRight: Radius.circular(
                                AppSizes.productImageRadius,
                              ),
                            ),
                          ),
                          child: const SizedBox(
                            width: AppSizes.iconLg * 1.2,
                            height: AppSizes.iconLg * 1.2,
                            child: Center(
                              child: Icon(Iconsax.add, color: AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
