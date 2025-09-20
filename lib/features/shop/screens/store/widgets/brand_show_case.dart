import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/features/shop/screens/store/widgets/brand_card.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AppBrandShowcase extends StatelessWidget {
  const AppBrandShowcase({
    super.key, required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return CircularContainer(
      shadowBorder: true,
      backgroundColor: Colors.transparent,
      borderColor: AppColors.darkGrey,
      padding: const EdgeInsets.all(AppSizes.md),
      margin: const EdgeInsets.only(bottom: AppSizes.spaceBtwItems),
      child: Column(
        children: [
          /// Brand with products count
          const BrandCard(showBorder: false),
          const SizedBox(height: AppSizes.spaceBtwItems),

          /// Top 3 images of Brand
          Row(
            /// Map of all images which is top products
            children: images.map((img) => brandTopProductImageWidget(img, context)).toList(),
          )
        ],
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context){
    return Expanded(
      child: CircularContainer(
        height: 100,
        backgroundColor: AppHelperFunctions.isDarkMode(context) ? AppColors.darkerGrey : AppColors.light,
        margin: const EdgeInsets.only(right: AppSizes.sm),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Image(image: AssetImage(image), fit: BoxFit.contain),
      ),
    );
  }
}
