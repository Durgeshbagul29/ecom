import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/products_cart/sortable_products.dart';
import 'package:ecom/features/shop/screens/store/widgets/brand_card.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BrandProductsScreen extends StatelessWidget {
  const BrandProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Nike'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              /// Brand Details
              BrandCard(showBorder: true),
              const SizedBox(height: AppSizes.spaceBtwSections),

              /// Brand Products
              SortableProducts(),
            ],
          ),
        ),
      ),
    );
  }
}
