import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/layouts/grid_layout.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/features/shop/screens/brands/brand_products.dart';
import 'package:ecom/features/shop/screens/store/widgets/brand_card.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('All Brands'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              /// Heading
              const AppSectionHeading(title: 'Brands', showActionButton: false),
              const SizedBox(height: AppSizes.spaceBtwItems),

              /// All Available Brands
              AppGridlayout(itemCount: 21, mainAxisExtent: 80, itemBuilder: (context, index) => BrandCard(showBorder: true, onTap: () => Get.to(() => const BrandProductsScreen())))
            ],
          ),
        ),
      ),
    );
  }
}
