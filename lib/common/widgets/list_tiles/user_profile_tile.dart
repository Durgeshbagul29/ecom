import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/common/widgets/loaders/shimmer.dart';
import 'package:ecom/features/personalization/controllers/user_controller.dart';
import 'package:ecom/features/personalization/screens/profile/profile_screen.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({super.key, required this.border});

  final bool border;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return ListTile(
      leading: Obx(() {
        if (controller.profileLoading.value || controller.imageUploading.value) {
          return const AppShimmerEffect(
            width: AppSizes.imgSm,
            height: AppSizes.imgSm,
            shape: BoxShape.circle,
          );
        }

        final networkImage = controller.user.value.profilePicture;

        return Container(
          width: AppSizes.imgSm,
          height: AppSizes.imgSm,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: border ? Border.all(color: AppColors.grey) : null,
          ),
          child: ClipOval(
            child: networkImage.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: networkImage,
                    width: AppSizes.imgSm,
                    height: AppSizes.imgSm,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (_, __, ___) =>
                        const AppShimmerEffect(
                      width: AppSizes.imgSm,
                      height: AppSizes.imgSm,
                      shape: BoxShape.circle,
                    ),
                    errorWidget: (_, __, ___) => Image.asset(
                      AppImages.user,
                      width: AppSizes.imgSm,
                      height: AppSizes.imgSm,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    AppImages.user,
                    width: AppSizes.imgSm,
                    height: AppSizes.imgSm,
                    fit: BoxFit.cover,
                  ),
          ),
        );
      }),
      title: Obx(() {
        if (controller.profileLoading.value) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: AppShimmerEffect(
              width: AppSizes.buttonWidth,
              height: AppSizes.md,
            ),
          );
        }
        return Text(
          controller.user.value.fullName,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: AppColors.white),
        );
      }),
      subtitle: Obx(() {
        if (controller.profileLoading.value) {
          return const Padding(
            padding: EdgeInsets.only(top: AppSizes.xs),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppShimmerEffect(
                width: AppSizes.brandCardWidth,
                height: AppSizes.sm,
              ),
            ),
          );
        }
        return Text(
          controller.user.value.email,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .apply(color: AppColors.white),
        );
      }),
      trailing: IconButton(
        onPressed: () => Get.to(() => const ProfileScreen()),
        icon: const Icon(Iconsax.edit, color: AppColors.white),
      ),
    );
  }
}
