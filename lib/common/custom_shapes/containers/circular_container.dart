import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.borderColor = AppColors.borderPrimary ,
    this.radius = AppSizes.cardRadiusLg,
    this.backgroundColor = AppColors.white,
    this.shadowBorder = false
  });

  // Container Variables
  final double? height, width, radius;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final bool shadowBorder;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: backgroundColor,
        border: shadowBorder ? Border.all(color: borderColor, width: 1.5) : null
      ),
      child: child
    );
  }
}
