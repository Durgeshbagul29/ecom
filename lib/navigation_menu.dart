import 'package:ecom/features/shop/screens/home/home_screen.dart';
import 'package:ecom/features/shop/screens/store/store_screen.dart';
import 'package:ecom/features/shop/screens/wishlist/wishlist_screen.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing navigation state
class NavigationController extends GetxController {
  // GetX Provide Type Int Variable
  RxInt selectedIndex = 0.obs;

  final screens = <Widget>[
    const HomeScreen(),
    const StoreScreen(),
    const WishlistScreen(),
    const Center(child: Text("Profile Screen")),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark Mode Variable
    final isDark = AppHelperFunctions.isDarkMode(context);

    // Inject controller (singleton)
    final NavigationController controller = Get.put(NavigationController());

    return Scaffold(
      // Reactive body
      body: Obx(() => controller.screens[controller.selectedIndex.value]),

      // Bottom Navigation
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Always show labels
          backgroundColor: isDark ? AppColors.charcoalBlack : AppColors.white,
          elevation: 8,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDark ? AppColors.grey : AppColors.darkGrey,
          selectedLabelStyle: const TextStyle(
            fontSize: AppSizes.fontSizeXs,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Store"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
