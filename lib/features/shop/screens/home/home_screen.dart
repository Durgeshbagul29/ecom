import 'package:ecom/common/custom_shapes/containers/app_header_container.dart';
import 'package:ecom/common/widgets/layouts/grid_layout.dart';
import 'package:ecom/common/widgets/products_cart/vertical_product_card.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/features/shop/screens/home/widgets/banner_slider.dart';
import 'package:ecom/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecom/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ecom/features/shop/screens/home/widgets/app_search_bar.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            AppHeaderContainer(
              child: Column(children: [
                /// App Bar
                HomeAppBar(),
                const SizedBox(height: AppSizes.spaceBtwSections),

                /// Search Bar
                AppSearchBar(text: AppText.searchBarTitle ,icon: Icons.search),

                /// Categories
                const Padding(padding: EdgeInsets.only(left: AppSizes.defaultSpace, top: AppSizes.defaultSpace),
                child: Column(
                  children: [
                    // category Heading
                    AppSectionHeading(title: AppText.popularCategories, showActionButton: false, textColor: AppColors.white),
                    SizedBox(height: AppSizes.spaceBtwItems),

                    // Categories List
                    HomeCategories()
                  ],
                ),
                )
              ]),
            ),

            /// ------ Home Body ------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
              child: Column(
                children: [
                  /// Home Banners Slider
                  const BannerSlider(
                      banners: [
                        AppImages.homeBanner1, AppImages.homeBanner2,
                        AppImages.homeBanner3, AppImages.homeBanner4,
                        AppImages.homeBanner5, AppImages.homeBanner6,
                      ], cHeight: 170, autoPlay: true, autoPlaySec: 4),

                  const SizedBox(height: AppSizes.spaceBtwSections),

                  /// Home Popular Products with Grid Layout
                  AppGridlayout(itemCount: 4, itemBuilder: (_, index) => const VerticalProductCard()),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
