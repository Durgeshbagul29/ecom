import 'package:ecom/common/custom_shapes/containers/circular_container.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SingleAddress extends StatelessWidget {
  const SingleAddress({super.key, required this.selectedAddress});

  final bool selectedAddress;
  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);

    return CircularContainer(
      width: double.infinity,
      shadowBorder: true,
      backgroundColor: selectedAddress
          ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
          : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.transparent
          : isDark
          ? AppColors.darkerGrey
          : AppColors.grey,
      padding: const EdgeInsets.all(AppSizes.md),
      margin: const EdgeInsets.only(bottom: AppSizes.spaceBtwItems),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
              selectedAddress ? Iconsax.tick_circle5 : null,
              color: selectedAddress
                  ? isDark
                        ? AppColors.light
                        : AppColors.dark.withValues(alpha: 0.8)
                  : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Durgesh Bagul',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppSizes.sm / 2),
              Text('8956037179', maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: AppSizes.sm / 2),
              Text('Flat No. 6, Swara Apartment 1, Nashik.', softWrap: true),
              SizedBox(height: AppSizes.sm / 2),
            ],
          ),
        ],
      ),
    );
  }
}
