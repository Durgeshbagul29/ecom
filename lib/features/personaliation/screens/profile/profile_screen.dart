import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/images_design/app_rounded_image.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/features/personaliation/screens/profile/widgets/profile_menu.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Profile', style: Theme.of(context).textTheme.headlineMedium), showBackArrow: true),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.all(AppSizes.defaultSpace),
        child: Column(
          children: [
            /// User Profile Picture
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const AppRoundedImage(imageUrl: AppImages.user, width: 80, height: 80, fit: BoxFit.cover, borderRadius: 100),
                  TextButton(onPressed: () {}, child: const Text('Change Profile Picture')),
                ],
              ),
            ),

            /// Details
            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: AppSizes.spaceBtwItems),

            const AppSectionHeading(title: 'Profile Information', showActionButton: false),
            const SizedBox(height: AppSizes.spaceBtwItems),

            ProfileMenu(title: 'Name', value: 'Durgesh Bagul',onPressed: () {}),
            ProfileMenu(title: 'Username', value: 'durgesh29',onPressed: () {}),

            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: AppSizes.spaceBtwItems),

            /// Personal Information
            const AppSectionHeading(title: 'Personal Information', showActionButton: false),
            const SizedBox(height: AppSizes.spaceBtwItems),

            ProfileMenu(title: 'User ID', value: '7179',icon: Iconsax.copy,onPressed: () {}),
            ProfileMenu(title: 'E-mail', value: 'baguldurgesh29@gmail.com',onPressed: () {}),
            ProfileMenu(title: 'Phone Number', value: '8956037179',onPressed: () {}),
            ProfileMenu(title: 'Gender', value: 'Male',onPressed: () {}),
            ProfileMenu(title: 'Date of Birth', value: '29 July 2002',onPressed: () {}),

            const Divider(),
            const SizedBox(height: AppSizes.spaceBtwItems),

            Center(
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close, color: Colors.red),
                    SizedBox(width: 8),
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