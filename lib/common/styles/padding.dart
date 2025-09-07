import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';

class AppPadding {
  // Private Constructor
  AppPadding._();

  // Full Screen Padding
  static const EdgeInsetsGeometry screenPadding = EdgeInsets.all(
    AppSizes.defaultSpace,
  );

  // Three Side Padding Left + Right + Bottom
  static const EdgeInsetsGeometry screenNotTopPadding = EdgeInsets.only(
    left: AppSizes.defaultSpace,
    right: AppSizes.defaultSpace,
    bottom: AppSizes.defaultSpace,
  );
}
