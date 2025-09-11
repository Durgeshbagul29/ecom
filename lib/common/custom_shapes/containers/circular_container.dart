import 'package:ecom/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
    this.child,
    this.height = 400,
    this.width = 400,
    this.radius = 400,
    this.backgroundColor = AppColors.white,
    this.padding = 0,
    this.margin,
  });

  // Container Variables
  final double height, width, radius;
  final Color backgroundColor;
  final double? padding;
  final EdgeInsets? margin;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding!),
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child
    );
  }
}
