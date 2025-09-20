import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/icons/app_circular_icon.dart';
import 'package:ecom/common/widgets/layouts/grid_layout.dart';
import 'package:ecom/common/widgets/products_cart/vertical_product_card.dart';
import 'package:ecom/features/shop/screens/home/home_screen.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Wishlist', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          AppCircularIcon(icon: Iconsax.add, onPressed: () => Get.to(const HomeScreen())),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          children: [
            AppGridlayout(itemCount: 8, itemBuilder: (_, index) => const VerticalProductCard())
          ],
        ),
        ),
      ),
    );
  }
}
