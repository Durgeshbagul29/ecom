import 'package:ecom/common/custom_shapes/containers/app_header_container.dart';
import 'package:ecom/common/widgets/appbar/appbar.dart';
import 'package:ecom/common/widgets/images_design/app_circular_iamge.dart';
import 'package:ecom/common/widgets/list_tiles/settings_menu_title.dart';
import 'package:ecom/common/widgets/texts/app_section_heading.dart';
import 'package:ecom/features/personaliation/screens/profile/profile_screen.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header Container
            AppHeaderContainer(
                child: Column(
                  children: [
                    CustomAppBar(title: Text('Account', style: Theme.of(context).textTheme.headlineMedium!.apply(color: AppColors.white))),
                    const SizedBox(height: AppSizes.spaceBtwItems),

                    /// User Profile Card
                    ListTile(
                      leading: AppCircularImage(
                          image: AppImages.user,  padding: 0),
                      title: Text('Durgesh Bagul', style: Theme.of(context).textTheme.headlineSmall!.apply(color : AppColors.white)),
                      subtitle : Text('baguldurgesh29@gmail.com', style: Theme.of(context).textTheme.bodyMedium!.apply(color : AppColors.white)),
                      trailing: IconButton(onPressed: () => Get.to(() => const ProfileScreen()), icon: const Icon(Iconsax.edit, color: AppColors.white))
                    ),
                    const SizedBox(height: AppSizes.spaceBtwSections),

              ],
            )),

            /// Body
            Padding(padding: const EdgeInsets.all(AppSizes.defaultSpace),
            child: Column(
              children: [
                /// Account Information
                const AppSectionHeading(title: 'Account Settings', showActionButton: false),
                const SizedBox(height: AppSizes.spaceBtwItems),

                SettingsMenuTitle(icon: Iconsax.safe_home, title: 'My Addresses',subTitle: 'Set shopping delivery address', onTap: () {}),
                SettingsMenuTitle(icon: Iconsax.shopping_cart, title: 'My Cart',subTitle: 'Add, remove products and move to checkout', onTap: () {}),
                SettingsMenuTitle(icon: Iconsax.bag_tick, title: 'My Orders',subTitle: 'In-progress and Completed Orders', onTap: () {}),
                SettingsMenuTitle(icon: Iconsax.bank, title: 'Bank Account',subTitle: 'Withdraw balance to registered bank account', onTap: () {}),
                SettingsMenuTitle(icon: Iconsax.discount_shape, title: 'My Coupons',subTitle: 'List of all the discounted coupons', onTap: () {}),
                SettingsMenuTitle(icon: Iconsax.notification, title: 'Notifications',subTitle: 'Set any kind of notifications message', onTap: () {}),
                SettingsMenuTitle(icon: Iconsax.security_card, title: 'Account Privacy',subTitle: 'Manage data usage and connected accounts', onTap: () {}),

                /// App Settings
                const SizedBox(height: AppSizes.spaceBtwSections),
                AppSectionHeading(title: 'App Settings', showActionButton: false),
                const SizedBox(height: AppSizes.spaceBtwItems),
                SettingsMenuTitle(icon: Iconsax.document_upload, title: 'Load Data',subTitle: 'Upload Data to your Cloud Firebase', trailing: Switch(value: false, onChanged: (value) {})),
                SettingsMenuTitle(icon: Iconsax.location, title: 'Geolocation',subTitle: 'Set recommendation based on location', trailing: Switch(value: true, onChanged: (value) {})),
                SettingsMenuTitle(icon: Iconsax.security_user, title: 'Safe Mode',subTitle: 'Search result is safe for all ages', trailing: Switch(value: true, onChanged: (value) {})),
                SettingsMenuTitle(icon: Iconsax.image, title: 'HD Image Quality',subTitle: 'Set image quality to be seen', trailing: Switch(value: false, onChanged: (value) {})),

                /// Logout Button
                const SizedBox(height: AppSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: () {}, child: const Text('Logout'))
                ),
                const SizedBox(height: AppSizes.spaceBtwSections),
                Text('Powered By BSquare Softwares Pvt Ltd.', style: Theme.of(context).textTheme.labelMedium!.apply(color: AppColors.primary))
              ],
            ))

          ],
        ),
      ),
    );
  }
}
