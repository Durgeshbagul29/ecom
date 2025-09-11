import 'package:ecom/common/custom_shapes/containers/app_header_container.dart';
import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
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
import 'package:carousel_slider/carousel_slider.dart';

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
                SizedBox(height: AppSizes.spaceBtwSections),

                /// Search Bar
                AppSearchBar(text: AppText.searchBarTitle ,icon: Icons.search),

                /// Categories
                Padding(padding: EdgeInsets.only(left: AppSizes.defaultSpace, top: AppSizes.defaultSpace),
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
            /// Home Banners
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
              child: BannerSlider(
                  banners: [
                    AppImages.homeBanner1,
                    AppImages.homeBanner2,
                    AppImages.homeBanner3,
                    AppImages.homeBanner4,
                    AppImages.homeBanner5,
                    AppImages.homeBanner6,
                  ])
            )
          ],
        ),
      ),
    );
  }
}