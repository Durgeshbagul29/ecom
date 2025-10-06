import 'package:ecom/common/widgets/layouts/grid_layout.dart';
import 'package:ecom/common/widgets/products_cart/vertical_product_card.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SortableProducts extends StatelessWidget {
  const SortableProducts({super.key,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Dropdown List
        DropdownButtonFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.sort),
          ),
          onChanged: (value) {},
          items: ['Name', 'Higher Price', 'Lower Price', 'Sale', 'Newest', 'Popularity']
              .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option))).toList(),
        ),
        const SizedBox(height: AppSizes.spaceBtwSections),

        /// All Sorted Products
        AppGridlayout(itemCount: 7, itemBuilder: (_, index) => const VerticalProductCard())
      ],
    );
  }
}
