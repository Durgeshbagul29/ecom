import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeading(title: 'Delivery Address', buttonTitle: 'Change', onPressed: (){}),
        Text('Durgesh Bagul', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppSizes.spaceBtwItems / 2),

        Row(
          children: [
            const Icon(Icons.phone, color:AppColors.darkGrey, size: 16),
            const SizedBox(width: AppSizes.spaceBtwItems),
            Text('8956037179', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: AppSizes.spaceBtwItems / 2),

        Row(
          children: [
            const Icon(Icons.location_history, color:AppColors.darkGrey, size: 16),
            const SizedBox(width: AppSizes.spaceBtwItems),
            Expanded(child: Text('Flat No. 6, Swara Apartment 1, Nashik', style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
      ],
    );
  }
}
