import 'package:ecom/features/personalization/controllers/user_controller.dart';
import 'package:ecom/features/personalization/screens/profile/profile_screen.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
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
        leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: border ? 1 : 0)
            ),
            child: CircleAvatar(radius: 30, backgroundImage: AssetImage(AppImages.user))),
        title: Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color : AppColors.white)),
        subtitle : Text(controller.user.value.email, style: Theme.of(context).textTheme.bodyMedium!.apply(color : AppColors.white)),
        trailing: IconButton(onPressed: () => Get.to(() => const ProfileScreen()), icon: const Icon(Iconsax.edit, color: AppColors.white))
    );
  }
}
