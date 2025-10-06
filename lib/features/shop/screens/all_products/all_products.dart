import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/products_cart/sortable_products.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('All Products'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: SortableProducts(),
        ),
      ),
    );
  }
}
