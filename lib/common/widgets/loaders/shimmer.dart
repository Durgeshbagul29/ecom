import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmerEffect extends StatelessWidget {
  const AppShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = AppSizes.borderRadiusLg,
    this.color,
    this.shape = BoxShape.rectangle,
  });

  final double width, height, radius;
  final Color? color;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkerGrey : AppColors.grey,
      highlightColor: isDark ? AppColors.darkGrey : AppColors.lightGrey,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? (isDark ? AppColors.darkerGrey : AppColors.white),
          shape: shape,
          borderRadius:
              shape == BoxShape.circle ? null : BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
