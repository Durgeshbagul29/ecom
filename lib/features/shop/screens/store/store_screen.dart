import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/images_design/app_circular_iamge.dart';
import 'package:ecom/common/widgets/layouts/grid_layout.dart';
import 'package:ecom/common/widgets/products_cart/cart_menu_icon.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:ecom/features/shop/screens/home/widgets/app_search_bar.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/enums.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_fucations.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Dark Mode Variable
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Store', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          MyCartCounterIcon(iconColor: Theme.of(context).primaryColor, onPressed: () {})
        ],
      ),
      body: NestedScrollView(headerSliverBuilder: (_, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: true,
            backgroundColor: AppHelperFunctions.isDarkMode(context) ? AppColors.charcoalBlack : AppColors.white,
            expandedHeight: 440,

            flexibleSpace: Padding(padding: EdgeInsets.all(AppSizes.defaultSpace),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                /// Search Bar
                SizedBox(height: AppSizes.spaceBtwItems),
                AppSearchBar(text: 'Search in ECom', showBorder: true, showBackground: false, padding: EdgeInsets.zero, icon: Icons.search),
                SizedBox(height: AppSizes.spaceBtwItems),

                /// Featured Brands
                AppSectionHeading(title: 'Featured Brands', onPressed: (){}),
                const SizedBox(height: AppSizes.spaceBtwItems / 1.5),

                /// Grid Layout of Brands
                AppGridlayout(itemCount: 4, mainAxisExtent : 80, itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: CircularContainer(
                      padding: const EdgeInsets.all(AppSizes.sm),
                      shadowBorder: true,
                      backgroundColor: Colors.transparent,
                      child: Row(
                        children: [
                          /// Brand Icon
                          // Use Flexible to solved render flex error of text
                          Flexible(
                            child: AppCircularImage(
                                isNetworkingImage: false,
                                fit: BoxFit.contain,
                                image: AppImages.nike, backgroundColor: Colors.transparent,
                                overlayColor: isDark ? AppColors.white : AppColors.charcoalBlack),
                          ),

                          /// Brand Text
                          // Use Expanded to solved render flex error of text
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const BrandTitleTextWithVerifiedIcon(title: 'Nike', brandTextSize: TextSizes.large),
                                Text('300 products', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelMedium),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ],
            )
            ),
          )
        ];
      }, body: Container()),
    );
  }
}
