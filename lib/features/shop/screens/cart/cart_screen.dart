import 'package:ecom/common/styles/padding.dart';
import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/features/shop/screens/cart/widgets/cart_product_items.dart';
import 'package:ecom/features/shop/screens/checkout/checkout.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        // In separatorBuilder _ means context, __ means index
        child: CartProductItems(),
      ),
      bottomNavigationBar: Padding(
        padding: AppPadding.screenNotTopPadding,
        child: ElevatedButton(onPressed: () => Get.to(() => const CheckoutScreen()), child: Text('Checkout ₹2200.00')),
      ),
    );
  }
}