import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/features/personalization/controllers/user_controller.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/helpers/network_manager.dart';
import 'package:ecom/utils/popups/full_screen_loader.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Variables
  final localStorage = GetStorage();
  final hidePassword = true.obs; // Observable for hiding/ showing password
  final rememberMe = true.obs; // Observable for privacy policy checkbox
  final autoValidateMode = AutovalidateMode.disabled.obs; // Observable for form auto-validation
  final email = TextEditingController(); // Controller for email input
  final password = TextEditingController(); // Controller for password input
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>(); // Form key for form validation

  final userController = Get.put(UserController());

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// Clear form validation errors and reset validation mode
  void clearFormErrors() {
    autoValidateMode.value = AutovalidateMode.disabled;
    final currentEmail = email.text;
    final currentPassword = password.text;
    loginFormKey.currentState?.reset();

    // Preserve current entered text, or fall back to saved credentials if empty
    final savedEmail = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    final savedPassword = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    email.text = currentEmail.isNotEmpty ? currentEmail : savedEmail;
    password.text = currentPassword.isNotEmpty ? currentPassword : savedPassword;
  }

  /// Login using Email & Password
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Enable auto validation so errors update dynamically as user corrects their input
      autoValidateMode.value = AutovalidateMode.onUserInteraction;

      // Form Validation
      if (!loginFormKey.currentState!.validate()) return;

      // Start Loading
      FullScreenLoader.openLoadingDialog(
        'Logging you in....',
        AppImages.bubbleLoading,
      );

      // Remember Me - Save Data if selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      if (kDebugMode) {
        debugPrint('==================== [LOGIN SCREEN - REQUEST] ====================');
        debugPrint('Action: Email & Password Sign-In');
        debugPrint('Email: ${email.text.trim()}');
        debugPrint('Remember Me: ${rememberMe.value}');
        debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
        debugPrint('==================================================================');
      }

      // Login user using Email & Password Authentication
      final userCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      if (kDebugMode) {
        debugPrint('==================== [LOGIN SCREEN - RESPONSE] ====================');
        debugPrint('Status: Login Successful');
        debugPrint('User UID: ${userCredential.user?.uid}');
        debugPrint('User Email: ${userCredential.user?.email}');
        debugPrint('Email Verified: ${userCredential.user?.emailVerified}');
        debugPrint('Display Name: ${userCredential.user?.displayName}');
        debugPrint('Provider: ${userCredential.additionalUserInfo?.providerId}');
        debugPrint('===================================================================');
      }

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();

    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [LOGIN SCREEN - ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('================================================================');
      }

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      AppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Login using Google Account
  Future<void> googleSignIn() async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Start Loading
      FullScreenLoader.openLoadingDialog('Logging you in....', AppImages.bubbleLoading);

      if (kDebugMode) {
        debugPrint('==================== [LOGIN SCREEN - GOOGLE SIGN-IN REQUEST] ====================');
        debugPrint('Action: Google Sign-In Initiated');
        debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
        debugPrint('=================================================================================');
      }

      // Login user using Google Account
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      if (kDebugMode) {
        debugPrint('==================== [LOGIN SCREEN - GOOGLE SIGN-IN RESPONSE] ====================');
        debugPrint('Status: Google Sign-In Successful');
        debugPrint('User UID: ${userCredentials?.user?.uid}');
        debugPrint('User Email: ${userCredentials?.user?.email}');
        debugPrint('Display Name: ${userCredentials?.user?.displayName}');
        debugPrint('==================================================================================');
      }

      // Save User Record
      await userController.saveUserRecord(userCredentials);

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();

    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [LOGIN SCREEN - GOOGLE SIGN-IN ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('===============================================================================');
      }

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      AppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
