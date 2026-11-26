
import 'package:ecom/data/repositories/user/user_repository.dart';
import 'package:ecom/features/personalization/controllers/user_controller.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/helpers/network_manager.dart';
import 'package:ecom/utils/popups/full_screen_loader.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


/// Controller to manage user name updates.
class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  // Text Editing Controllers
  final firstName = TextEditingController();
  final lastName = TextEditingController();

  // Instances
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());

  // Form Key
  GlobalKey<FormState> updateUserNameFormKey =
  GlobalKey<FormState>();

  /// Initialize user data when screen opens.
  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  /// Fetch existing user name.
  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  /// Update user's first and last name.
  Future<void> updateUserName() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
        'Updating Name....',
        AppImages.bubbleLoading,
      );

      // Check Internet Connectivity
      final isConnected =
      await NetworkManager.instance.isConnected();

      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Prepare updated name data
      final Map<String, dynamic> name = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim(),
      };

      // Update user's name in Firebase Firestore
      await userRepository.updateSingleField(name);

      // Update GetX User value
      userController.user.value.firstName =
          firstName.text.trim();

      userController.user.value.lastName =
          lastName.text.trim();

      // Refresh reactive user data
      userController.user.refresh();

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Message
      AppLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your Name has been updated.',
      );

      // Navigate to Previous Screen
      Get.back();

    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Error Message
      AppLoaders.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    super.onClose();
  }
}
