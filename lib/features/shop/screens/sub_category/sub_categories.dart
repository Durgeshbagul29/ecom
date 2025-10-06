import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/common/widgets/products_cart/horizontal_product_card.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Sports'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              /// Banner
              AppRoundedImage(
                imageUrl: AppImages.homeBanner4,
                width: double.infinity,
                applyImageRadius: true,
              ),
              const SizedBox(height: AppSizes.spaceBtwSections),

              /// Sub-Categories
              Column(
                children: [
                  /// Heading
                  AppSectionHeading(title: 'Sports Shirts', onPressed: () {}),
                  const SizedBox(height: AppSizes.spaceBtwItems / 2),

                  /// Horizontal Product Cards
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceBtwItems),
                      itemBuilder: (context, index) => const HorizontalProductCard(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}