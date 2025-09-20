import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/appbar/tab_bar.dart';
import 'package:ecom/common/widgets/layouts/grid_layout.dart';
import 'package:ecom/common/widgets/products_cart/cart_menu_icon.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/features/shop/screens/home/widgets/app_search_bar.dart';
import 'package:ecom/features/shop/screens/store/widgets/brand_card.dart';
import 'package:ecom/features/shop/screens/store/widgets/category_tab.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Dark Mode Variable
    final isDark = AppHelperFunctions.isDarkMode(context);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('Store', style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            MyCartCounterIcon(
              iconColor: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: isDark ? AppColors.charcoalBlack : AppColors.white,
                expandedHeight: 390,

                flexibleSpace: Padding(
                  padding: EdgeInsets.all(AppSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      /// Search Bar
                      SizedBox(height: AppSizes.spaceBtwItems),
                      AppSearchBar(
                        text: 'Search in ECom',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                        icon: Icons.search,
                      ),
                      const SizedBox(height: AppSizes.spaceBtwItems),

                      /// Featured Brands
                      AppSectionHeading(
                        title: 'Featured Brands',
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSizes.spaceBtwItems / 1.5),

                      /// Grid Layout of Brands
                      AppGridlayout(
                        itemCount: 4,
                        mainAxisExtent: 70,
                        itemBuilder: (_, index) {
                          return BrandCard(showBorder: true);
                        },
                      ),
                    ],
                  ),
                ),

                /// Categories Tabs
                bottom: AppTabBar(
                  tabs: [
                    Tab(child: Text('Electronics')),
                    Tab(child: Text('Sports')),
                    Tab(child: Text('Furniture')),
                    Tab(child: Text('Fashion')),
                    Tab(child: Text('Beauty')),
                    Tab(child: Text('Groceries')),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
              children: [
                const CategoryTab(),
                const CategoryTab(),
                const CategoryTab(),
                const CategoryTab(),
                const CategoryTab(),
                const CategoryTab()
              ]
          ),
        ),
      ),
    );
  }
}
