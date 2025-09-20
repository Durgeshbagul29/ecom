import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/device/device_utility.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// When we want to add background color to tab bar then wrap into Material Widget.
  /// To do that we need [PreferredSizeWidget] Widget and that's why created custom class.
  const AppTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    /// Dark Mode
    final isDark = AppHelperFunctions.isDarkMode(context);

    return Material(
      color: isDark ? AppColors.black : AppColors.white,
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        unselectedLabelColor: AppColors.darkGrey,
        labelColor: isDark ? AppColors.white : AppColors.primary,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppDeviceHelpers.getAppBarHeight());
}
