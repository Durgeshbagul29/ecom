import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BillingAmountSection extends StatelessWidget {
  const BillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹1043', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: AppSizes.spaceBtwItems / 2),

        /// Shipping Fees
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shipping Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹50', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: AppSizes.spaceBtwItems / 2),

        /// Tax
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹16', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: AppSizes.spaceBtwItems / 2),

        /// Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyLarge),
            Text('₹1109', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}