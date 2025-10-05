import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/products_cart/coupon_code.dart';
import 'package:ecom/common/widgets/screens/success_screen.dart';
import 'package:ecom/features/shop/screens/cart/widgets/cart_product_items.dart';
import 'package:ecom/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:ecom/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecom/features/shop/screens/checkout/widgets/delivery_address_section.dart';
import 'package:ecom/navigation_menu.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              /// Selected Products List
              CartProductItems(showAddRemoveButtons: false),
              const SizedBox(height: AppSizes.spaceBtwSections),

              /// Coupon TextField
              CouponCode(),
              const SizedBox(height: AppSizes.spaceBtwSections),

              /// Billing Section
              CircularContainer(
                shadowBorder: true,
                padding: const EdgeInsets.all(AppSizes.md),
                backgroundColor: isDark ? AppColors.black : AppColors.white,
                child: Column(
                  children: [
                    /// Pricing
                    BillingAmountSection(),
                    const SizedBox(height: AppSizes.spaceBtwItems),

                    /// Divider
                    const Divider(),
                    const SizedBox(height: AppSizes.spaceBtwItems / 2),

                    /// Payment Methods
                    BillingPaymentSection(),
                    const SizedBox(height: AppSizes.spaceBtwItems),

                    /// Delivery Addresses
                    DeliveryAddressSection(),
                    const SizedBox(height: AppSizes.spaceBtwItems / 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => Get.to(
            () => SuccessScreen(
              image: AppImages.successDoneAnimation,
              title: 'Payment Success!',
              subTitle: 'Your item will be shipped soon!',
              onTap: () => Get.offAll(() => const NavigationMenu())
            ),
          ),
          child: Text('Checkout ₹2200.00'),
        ),
      ),
    );
  }
}