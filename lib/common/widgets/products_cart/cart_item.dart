import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:ecom/common/widgets/texts/product_title_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Product Image
        AppRoundedImage(
          imageUrl: AppImages.shirt,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(AppSizes.md),
          backgroundColor: AppHelperFunctions.isDarkMode(context)
              ? AppColors.darkerGrey
              : AppColors.light,
        ),
        SizedBox(width: AppSizes.spaceBtwItems),

        /// Title, Price and Size
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandTitleTextWithVerifiedIcon(title: 'Zara'),
              const Flexible(
                child: ProductTitleText(
                  title: 'Black Sport Shirt',
                  maxLines: 1,
                ),
              ),

              /// Attributes
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Color',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: 'Green',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    WidgetSpan(child: SizedBox(width: 8)),
                    TextSpan(
                      text: 'Size',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: 'XXL',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}