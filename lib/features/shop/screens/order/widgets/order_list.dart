import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spaceBtwItems),
      itemCount: 7,
      itemBuilder: (_, index) => CircularContainer(
        shadowBorder: true,
        padding: const EdgeInsets.all(AppSizes.md),
        backgroundColor: isDark ? AppColors.dark : AppColors.light,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 1 - Row
            Row(
              children: [
                /// Icon
                Icon(Iconsax.ship),
                SizedBox(width: AppSizes.spaceBtwItems / 2),
      
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Processing', style: Theme.of(context).textTheme.bodyLarge!.apply(color: AppColors.primary, fontWeightDelta: 1),),
                      Text('01 Oct 2025', style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),
      
                /// Icon Button
                IconButton(
                  onPressed: () {},
                  icon: Icon(Iconsax.arrow_right_34, size: AppSizes.iconSm)),
              ],
            ),
            const SizedBox(height: AppSizes.spaceBtwItems),
      
            /// 2 - Row
            Row(
              children: [
                /// Order ID
                Expanded(
                  child: Row(
                    children: [
                      /// Icon
                      Icon(Iconsax.tag),
                      SizedBox(width: AppSizes.spaceBtwItems / 2),
      
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order', style: Theme.of(context).textTheme.labelMedium),
                            Text('#123', style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      
                /// Shipping Date
                Expanded(
                  child: Row(
                    children: [
                      /// Icon
                      Icon(Iconsax.calendar),
                      SizedBox(width: AppSizes.spaceBtwItems / 2),
      
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Shipping Date', style: Theme.of(context).textTheme.labelMedium),
                            Text('04 Oct 2025', style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
