import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/features/personalization/controllers/user_controller.dart';
import 'package:ecom/features/personalization/screens/profile/widgets/chnage_name.dart';
import 'package:ecom/features/personalization/screens/profile/widgets/profile_image_viewer.dart';
import 'package:ecom/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: CustomAppBar(title: Text('Profile', style: Theme.of(context).textTheme.headlineMedium), showBackArrow: true),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.all(AppSizes.defaultSpace),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Obx(() {
                    if (controller.imageUploading.value) {
                      return const SizedBox(
                        width: 80,
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      );
                    }
                    final networkImage = controller.user.value.profilePicture;
                    final image = networkImage.isNotEmpty
                        ? networkImage
                        : AppImages.user;
                    return AppRoundedImage(
                      imageUrl: image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      borderRadius: 100,
                      isNetworking: networkImage.isNotEmpty,
                      onPressed: () => ProfileImageViewer.show(
                        context,
                        imageUrl: image,
                        userName: controller.user.value.fullName,
                        isNetwork: networkImage.isNotEmpty,
                      ),
                    );
                  }),
                  Obx(
                    () => TextButton(
                      onPressed: controller.imageUploading.value
                          ? null
                          : () => controller.uploadUserProfilePicture(),
                      child: const Text('Change Profile Picture'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: AppSizes.spaceBtwItems),

            const AppSectionHeading(title: 'Profile Information', showActionButton: false),
            const SizedBox(height: AppSizes.spaceBtwItems),

            Obx(() => ProfileMenu(title: 'Name', value: controller.user.value.fullName, onPressed: () => Get.to(() => const ChangeName()))),
            Obx(() => ProfileMenu(title: 'Username', value: controller.user.value.username, onPressed: () {})),

            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: AppSizes.spaceBtwItems),

            const AppSectionHeading(title: 'Personal Information', showActionButton: false),
            const SizedBox(height: AppSizes.spaceBtwItems),

            Obx(() => ProfileMenu(title: 'User ID', value: controller.user.value.id, icon: Iconsax.copy, onPressed: () {})),
            Obx(() => ProfileMenu(title: 'E-mail', value: controller.user.value.email, onPressed: () {})),
            Obx(() => ProfileMenu(title: 'Phone Number', value: controller.user.value.phoneNumber, onPressed: () {})),
            ProfileMenu(title: 'Gender', value: 'Male',onPressed: () {}),
            ProfileMenu(title: 'Date of Birth', value: '29 July 2002',onPressed: () {}),

            const Divider(),
            const SizedBox(height: AppSizes.spaceBtwItems),

            Center(
              child: TextButton(
                onPressed: () => controller.deleteAccountWarningPopup(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.close, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('Close Account', style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.red)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
