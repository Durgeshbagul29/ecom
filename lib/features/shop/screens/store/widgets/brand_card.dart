
import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/images_design/app_circular_iamge.dart';
import 'package:ecom/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/enums.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    required this.showBorder,
    this.onTap,
  });

  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    /// Dark Mode
    final isDark = AppHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: CircularContainer(
        padding: const EdgeInsets.all(AppSizes.sm),
        shadowBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Brand Icon
            // Use Flexible to solved render flex error of text
            Flexible(
              child: AppCircularImage(
                  isNetworkingImage: false,
                  fit: BoxFit.contain,
                  image: AppImages.nike,
                  backgroundColor: Colors.transparent,
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
  }
}
