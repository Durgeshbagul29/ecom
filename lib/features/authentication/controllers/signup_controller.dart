import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/data/repositories/user/user_repository.dart';
import 'package:ecom/features/authentication/screens/signup/verify_email_screen.dart';
import 'package:ecom/features/personalization/models/user_model.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/helpers/network_manager.dart';
import 'package:ecom/utils/popups/full_screen_loader.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:flutter/foundation.dart';
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
      final isFormValid = signFormKey.currentState!.validate();

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        AppLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'In order to create an account, you must read and accept the Privacy Policy & Terms of Use.',
        );
        return;
      }

      if (!isFormValid) return;

      // Start Loading
      FullScreenLoader.openLoadingDialog(
        'We are processing your information...',
        AppImages.bubbleLoading,
      );

      if (kDebugMode) {
        debugPrint('==================== [SIGNUP SCREEN - REQUEST] ====================');
        debugPrint('Action: Register User With Email & Password');
        debugPrint('First Name: ${firstName.text.trim()}');
        debugPrint('Last Name: ${lastName.text.trim()}');
        debugPrint('Username: ${username.text.trim()}');
        debugPrint('Email: ${email.text.trim()}');
        debugPrint('Phone Number: ${phoneNumber.text.trim()}');
        debugPrint('Privacy Policy Accepted: ${privacyPolicy.value}');
        debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
        debugPrint('===================================================================');
      }

      // Register user in the Firebase Authentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
            email.text.trim(),
            password.text.trim(),
          );

      if (kDebugMode) {
        debugPrint('==================== [SIGNUP SCREEN - AUTH RESPONSE] ====================');
        debugPrint('Status: User Registered Successfully in Authentication');
        debugPrint('User UID: ${userCredential.user?.uid}');
        debugPrint('User Email: ${userCredential.user?.email}');
        debugPrint('=========================================================================');
      }

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

      if (kDebugMode) {
        debugPrint('==================== [SIGNUP SCREEN - SAVE USER REQUEST] ====================');
        debugPrint('Target Collection: Users');
        debugPrint('User ID: ${newUser.id}');
        debugPrint('Payload: ${newUser.toJson()}');
        debugPrint('=============================================================================');
      }

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      if (kDebugMode) {
        debugPrint('==================== [SIGNUP SCREEN - SAVE USER RESPONSE] ====================');
        debugPrint('Status: User Record Successfully Saved to Firestore');
        debugPrint('User ID: ${newUser.id}');
        debugPrint('==============================================================================');
      }

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Message
      AppLoaders.successSnackBar(
        title: 'Congregations',
        message: 'Your account has been created! Verify email to continue.',
      );

      // Move to verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));

    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [SIGNUP SCREEN - ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('=================================================================');
      }

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      AppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
