import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CouponCode extends StatelessWidget {
  const CouponCode({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return CircularContainer(
      shadowBorder: true,
      backgroundColor: isDark ? AppColors.dark : AppColors.white,
      padding: const EdgeInsets.only(
        top: AppSizes.sm,
        bottom: AppSizes.sm,
        right: AppSizes.sm,
        left: AppSizes.md,
      ),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Have a promo code? Enter here..',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),

          /// Apply Button
          SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: isDark
                    ? AppColors.white.withValues(alpha: 0.5)
                    : AppColors.dark.withValues(alpha: 0.5),
                backgroundColor: AppColors.grey.withValues(
                  alpha: 0.2,
                ),
                side: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.1),
                ),
              ),
              child: Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}