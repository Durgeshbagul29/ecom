import 'package:ecom/common/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/icons/app_circular_icon.dart';
import 'package:ecom/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductDetailImage extends StatelessWidget {
  const ProductDetailImage({
    super.key
  });


  @override
  Widget build(BuildContext context) {
    /// Dark Mode
    final isDark = AppHelperFunctions.isDarkMode(context);

    return AppCurvedEdgesWidget(
      child: Container(
        color: isDark ? AppColors.darkerGrey : AppColors.light,
        child: Stack(
            children: [
              /// Main Large Image of Product
              SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: AppSizes.productImageRadius * 2,
                        right: AppSizes.productImageRadius * 2,
                        bottom: AppSizes.productImageRadius * 2,
                        top: AppSizes.appBarHeight),
                    child: Image(image: AssetImage(AppImages.shirt)),
                  )
              ),

              /// Images Slider
              // In ListView when we don't need any thing then pass underscore with there position count
              ProductImageSlider(),

              /// Appbar with Icons
              const CustomAppBar(
                showBackArrow: true,
                actions: [AppCircularIcon(icon: Iconsax.heart5, color: Colors.red)]
              )
            ]
        ),
      ),
    );
  }
}