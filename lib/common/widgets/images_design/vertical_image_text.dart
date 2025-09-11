import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_fucations.dart';
import 'package:flutter/material.dart';

class AppVerticalImageText extends StatelessWidget {
  const AppVerticalImageText({
    super.key, required this.image, required this.title, this.textColor = AppColors.white, this.backgroundColor, this.onTap,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // Dark Mode variable
    final isDark = AppHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: AppSizes.spaceBtwItems),
        child: Column(
          children: [
            // Circular Icon
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                  color: backgroundColor ?? (isDark ? AppColors.cardBlack.withValues(alpha: 0.9) : AppColors.white.withValues(alpha: 0.9)),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg)
              ),
              // Category Image
              child: Center(
                child: Image(image: AssetImage(image), fit: BoxFit.cover),
              ),
            ),
            // Category Text
            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            SizedBox(width: 55, child: Text(title, style: Theme.of(context).textTheme.labelMedium!.apply(color: textColor),
                maxLines: 1,overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}