import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/common/widgets/loaders/shimmer.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppRoundedImage extends StatelessWidget {
  const AppRoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit,
    this.padding,
    this.isNetworking = false,
    this.onPressed,
    this.borderRadius = AppSizes.borderRadiusXXl,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworking;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: isNetworking
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: fit ?? BoxFit.cover,
                  progressIndicatorBuilder: (_, __, ___) => LayoutBuilder(
                    builder: (_, constraints) => AppShimmerEffect(
                      width: width ??
                          (constraints.maxWidth.isFinite
                              ? constraints.maxWidth
                              : AppSizes.imgLg),
                      height: height ??
                          (constraints.maxHeight.isFinite
                              ? constraints.maxHeight
                              : AppSizes.imgLg),
                      radius: applyImageRadius ? borderRadius : 0,
                    ),
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                )
              : Image.asset(
                  imageUrl,
                  fit: fit ?? BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
