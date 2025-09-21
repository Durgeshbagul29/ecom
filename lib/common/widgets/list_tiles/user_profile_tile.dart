import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/features/personaliation/screens/profile/profile_screen.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
    required this.name,
    required this.email,
    required this.image,
    this.border = false,
  });

  final String name, email, image;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: border ? 1 : 0)
            ),
            child: CircleAvatar(radius: 30, backgroundImage: AssetImage(image))),
        title: Text(name, style: Theme.of(context).textTheme.headlineSmall!.apply(color : AppColors.white)),
        subtitle : Text(email, style: Theme.of(context).textTheme.bodyMedium!.apply(color : AppColors.white)),
        trailing: IconButton(onPressed: () => Get.to(() => const ProfileScreen()), icon: const Icon(Iconsax.edit, color: AppColors.white))
    );
  }
}
