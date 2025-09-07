import 'package:ecom/features/authentication/screens/login/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnBoardingController extends GetxController {
  // Declare at one time to save memory
  static OnBoardingController get instance => Get.find();

  // Variables
  final pageController = PageController();
  // form GetX
  RxInt currentIndex = 0.obs;

  // Update current index when page scroll
  void updatePageIndicator(index) {
    currentIndex.value = index;
  }

  // Jump to specific dot selected page
  void dotNavigationClick(index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  // Update current index and jump to the next page
  void nextPage() {
    if (currentIndex.value == 2) {
      // Declared False not first time
      final storage = GetStorage();

      if (kDebugMode){
        print('================== GET STORAGE [On Next Button] ==================');
        print(storage.read('isFirstTime'));
      }

      storage.write('isFirstTime', false);

      Get.offAll(() => LoginScreen());
    } else {
      int page = currentIndex.value++;
      pageController.jumpToPage(page);
    }
  }

  // Update current index and jump to the last page
  void skipPage() {
    currentIndex.value = 2;
    pageController.jumpToPage(currentIndex.value);
  }
}
