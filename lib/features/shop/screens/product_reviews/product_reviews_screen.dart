import 'package:ecom/common/widgets/appbar/my_appbar.dart';
import 'package:ecom/common/widgets/products_cart/rating_star_indicator.dart';
import 'package:ecom/features/shop/screens/product_reviews/widgets/overall_product_rating.dart';
import 'package:ecom/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar
      appBar: const MyAppBar(title: 'Reviews & Rating'),

      /// Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ratings and reviews are verified and are from people who use the same type of device that you use.'),
              const SizedBox(height: AppSizes.spaceBtwItems),

              /// Overall Product Ratings
              const OverallProductRating(),
              const RatingStarIndicator(rating: 4),
              Text('12,611', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSizes.spaceBtwItems),

              /// User Reviews List
              UserReviewCard(),
              UserReviewCard(),
              UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}