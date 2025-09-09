import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/products_cart/cart_menu_icon.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [
          Text(AppText.homeAppBarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: AppColors.grey)),
          Text(AppText.homeAppBarSubTitle, style: Theme.of(context).textTheme.headlineSmall!.apply(color: AppColors.white)),
        ],
      ),
      actions: [
        MyCartCounterIcon(onPressed: () {},iconColor: AppColors.white)
      ],
    );
  }
}