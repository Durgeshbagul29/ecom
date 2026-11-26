import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/loaders/circular_loader.dart';
import 'package:ecom/common/widgets/products_cart/cart_menu_icon.dart';
import 'package:ecom/features/personalization/controllers/user_controller.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return CustomAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.homeAppBarTitle,
            style: Theme.of(context).textTheme.labelMedium!.apply(color: AppColors.grey),
          ),
          Obx(() {
            if (controller.profileLoading.value) {
              // Display 3 dots animated loading while user profile is being loaded
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.xs),
                child: CircularLoader(
                  color: AppColors.white,
                  size: AppSizes.sm,
                  spacing: AppSizes.xs,
                ),
              );
            } else {
              return Text(controller.user.value.fullName,
                style: Theme.of(context).textTheme.headlineSmall!.apply(color: AppColors.white),
              );
            }
          }),
        ],
      ),
      actions: [MyCartCounterIcon(onPressed: () {}, iconColor: AppColors.white)],
    );
  }
}
