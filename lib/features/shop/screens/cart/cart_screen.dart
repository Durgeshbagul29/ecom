import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/products_cart/cart_item.dart';
import 'package:ecom/common/widgets/texts/product_price_text.dart';
import 'package:ecom/features/shop/screens/cart/widgets/product_quantity_add_remove.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

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
        child: ListView.separated(
          shrinkWrap: true, // Take space or height of it's children's
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spaceBtwSections),
          itemCount: 20,
          itemBuilder: (_, index) => Column(
            children: [
              /// Cart Item
              CartItem(),
              const SizedBox(height: AppSizes.spaceBtwItems),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      /// Extra Space
                      const SizedBox(width: 70),

                      /// Add Remove Buttons
                      ProductQuantityAddRemove(),
                    ],
                  ),

                  /// Product total price
                  ProductPriceText(price: '499'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: ElevatedButton(onPressed: () {}, child: Text('Checkout ₹2200.00')),
      ),
    );
  }
}
