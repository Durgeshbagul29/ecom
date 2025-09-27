import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/chips/choice_chip.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/common/widgets/texts/product_price_text.dart';
import 'package:ecom/common/widgets/texts/product_title_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    /// Dark Mode
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        /// Selected Attributes Pricing and Description
        CircularContainer(
          padding: const EdgeInsets.all(AppSizes.md),
          backgroundColor: isDark ? AppColors.darkerGrey : AppColors.grey,
          child: Column(
            children: [
              /// Title, Price and Stoke Status
              const ProductTitleText(title: 'Price: ', smallSize: true),
              Row(
                children: [
                  const AppSectionHeading(title: 'Variation', showActionButton: false),
                  const SizedBox(width: AppSizes.spaceBtwItems),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          /// Actual Price
                          ProductPriceText(price: '25', lineThrough: true),
                          SizedBox(width: AppSizes.spaceBtwItems),
                          /// Sale Price
                          ProductPriceText(price: '21', lineThrough: true)
                        ],
                      ),
                      /// Stock
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ProductTitleText(title: 'Stock', smallSize: true),
                          Text('In Stock', style: Theme.of(context).textTheme.titleMedium)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              /// Variation Description
              ProductTitleText(
                title: 'This is the description of the product and it can go up to max 4 lines',
                smallSize: true,
                maxLines: 4
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spaceBtwItems),

        /// Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionHeading(title: 'Colors', showActionButton: false),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                AppChoiceChip(text: 'Green', selected: true, onSelected: (value) {}),
                AppChoiceChip(text: 'Red', selected: false, onSelected: (value) {}),
                AppChoiceChip(text: 'Yellow', selected: false, onSelected: (value) {}),
                AppChoiceChip(text: 'Pink', selected: false, onSelected: (value) {}),
                AppChoiceChip(text: 'Blue', selected: false, onSelected: (value) {})
              ],
            ),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionHeading(title: 'Sizes', showActionButton: false),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                AppChoiceChip(text: 'Xs', selected: true, onSelected: (value) {}),
                AppChoiceChip(text: 'Md', selected: false, onSelected: (value) {}),
                AppChoiceChip(text: 'Xl', selected: false, onSelected: (value) {}),
                AppChoiceChip(text: 'Xll', selected: false, onSelected: (value) {})
              ],
            ),
          ],
        ),
      ],
    );
  }
}
