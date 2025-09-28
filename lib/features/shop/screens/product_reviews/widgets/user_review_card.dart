import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/common/widgets/products_cart/rating_star_indicator.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundImage: AssetImage(AppImages.user)),
                const SizedBox(width: AppSizes.spaceBtwItems),
                Text('Durgesh Bagul', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(width: AppSizes.spaceBtwItems),

        /// Review
        Row(
          children: [
            const RatingStarIndicator(rating: 3.5),
            const SizedBox(width: AppSizes.spaceBtwItems),
            Text('01 Sep 2025', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: AppSizes.spaceBtwItems),
        ReadMoreText(
          'Great quality product, exactly as described! The material feels durable and premium, and it looks just like the pictures. Delivery was on time, and the packaging was neat and secure. Overall, very satisfied with the purchase and would definitely recommend it to others.',
          textAlign: TextAlign.justify,
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: 'Show less',
          trimCollapsedText: 'Show More',
          moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
          lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: AppSizes.spaceBtwItems),

        /// Company Reply Review
        CircularContainer(
          backgroundColor: isDark ? AppColors.darkerGrey : AppColors.grey,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ECom Shop', style: Theme.of(context).textTheme.titleMedium),
                    Text('02 Sep 2025', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceBtwItems / 2),
                ReadMoreText(
                  'Great quality product, exactly as described! The material feels durable and premium, and it looks just like the pictures. Delivery was on time, and the packaging was neat and secure. Overall, very satisfied with the purchase and would definitely recommend it to others.',
                  textAlign: TextAlign.justify,
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: 'Show less',
                  trimCollapsedText: 'Show More',
                  moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                  lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceBtwItems),
      ],
    );
  }
}