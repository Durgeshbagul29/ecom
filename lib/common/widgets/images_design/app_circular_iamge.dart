import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/common/widgets/loaders/shimmer.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AppCircularImage extends StatelessWidget {
  const AppCircularImage({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetworkingImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width = AppSizes.imgSm,
    this.height = AppSizes.imgSm,
    this.padding = AppSizes.sm,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkingImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (AppHelperFunctions.isDarkMode(context)
                ? AppColors.charcoalBlack
                : AppColors.white),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Center(
          child: isNetworkingImage
              ? CachedNetworkImage(
                  fit: fit ?? BoxFit.cover,
                  color: overlayColor,
                  imageUrl: image,
                  progressIndicatorBuilder: (_, __, ___) => AppShimmerEffect(
                    width: width,
                    height: height,
                    shape: BoxShape.circle,
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                )
              : Image(
                  fit: fit,
                  image: AssetImage(image),
                  color: overlayColor,
                ),
        ),
      ),
    );
  }
}
