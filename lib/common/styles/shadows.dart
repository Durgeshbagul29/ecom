import 'package:ecom/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';

class AppShadowStyle {

  // Shadow for vertical product card
  static final verticalProductShadow = BoxShadow(
    color: AppColors.darkGrey.withValues(alpha: 0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );

  // Shadow for horizontal product card
  static final horizontalProductShadow = BoxShadow(
      color: AppColors.darkGrey.withValues(alpha: 0.1),
      blurRadius: 50,
      spreadRadius: 7,
      offset: const Offset(0, 2)
  );

}