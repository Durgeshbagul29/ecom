import 'package:ecom/common/widgets/layouts/grid_layout.dart';
import 'package:ecom/common/widgets/products_cart/vertical_product_card.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/features/shop/screens/store/widgets/brand_show_case.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [ Padding(padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          children: [
            /// Brands
            AppBrandShowcase(images: [AppImages.shoes, AppImages.belt, AppImages.drinks]),
            AppBrandShowcase(images: [AppImages.shoes, AppImages.belt, AppImages.drinks]),
            const SizedBox(height: AppSizes.spaceBtwItems),

            /// Products
            AppSectionHeading(title: 'You might like', onPressed: () {}),
            const SizedBox(height: AppSizes.spaceBtwItems),

            /// Products Grid Layout
            AppGridlayout(itemCount: 4, itemBuilder: (_, index) => const VerticalProductCard()),
            const SizedBox(height: AppSizes.spaceBtwItems),
          ],
        ),
      ),
    ]
    );
  }
}
