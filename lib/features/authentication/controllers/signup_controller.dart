import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/data/repositories/user/user_repository.dart';
import 'package:ecom/features/authentication/screens/signup/verify_email_screen.dart';
import 'package:ecom/features/personaliation/models/userModel.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/helpers/network_manager.dart';
import 'package:ecom/utils/popups/full_screen_loader.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  /// Get the current instance of SignupController
  // This allows you to access the same controller anywhere in your app without creating a new instance.
  static SignupController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs; // Observable for hiding/ showing password
  final privacyPolicy = true.obs; // Observable for privacy policy checkbox
  final email = TextEditingController(); // Controller for email input
  final firstName = TextEditingController(); // Controller for first name input
  final lastName = TextEditingController(); // Controller for last name input
  final username = TextEditingController(); // Controller for username input
  final password = TextEditingController(); // Controller for password input
  final phoneNumber =
      TextEditingController(); // Controller for phone number input
  GlobalKey<FormState> signFormKey =
      GlobalKey<FormState>(); // Form key for form validation

  /// Sign Up
  void signup() async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Form Validation
      if (!signFormKey.currentState!.validate()) return;

      // privacy Policy Check
      if (!privacyPolicy.value) {
        AppLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to crete account, you must have to read and accept the Privacy Policy & Terms of Use.');
        return;
      }

      // Start Loading
      FullScreenLoader.openLoadingDialog(
        'We are processing your information...',
        AppImages.bubbleLoading,
      );

      // Register user in the Firebase Authentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
            email.text.trim(),
            password.text.trim(),
          );

      // Save Authentication user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Remove Loader
      // FullScreenLoader.stopLoading();

      // Show Success Message
      AppLoaders.successSnackBar(
        title: 'Congregations',
        message: 'Your account has been created! Verify email to continue.',
      );

      // Move to verify Email Screen
      Get.to(() => const VerifyEmailScreen());

    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      AppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
