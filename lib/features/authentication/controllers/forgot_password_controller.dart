import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/features/authentication/screens/forgot_password/reset_password_screen.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/helpers/network_manager.dart';
import 'package:ecom/utils/popups/full_screen_loader.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgotPasswordFormKey =
      GlobalKey<FormState>(); // Form key for form validation

  /// Send Reset Password Email
  sendResetPasswordEmail() async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Form Validation
      if (!forgotPasswordFormKey.currentState!.validate()) return;

      // Start Loading
      FullScreenLoader.openLoadingDialog(
        'Processing your request....',
        AppImages.bubbleLoading,
      );

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendResetPasswordEmail(
        email.text.trim(),
      );

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Message
      AppLoaders.successSnackBar(
        title: 'Email sent',
        message: 'Email Link Sent to Reset your Password'.tr,
      );

      // Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      AppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


  /// Re-Send Reset Password Email
  resendResetPasswordEmail(String email) async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Start Loading
      FullScreenLoader.openLoadingDialog(
        'Processing your request....',
        AppImages.bubbleLoading,
      );

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendResetPasswordEmail(email);

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Message
      AppLoaders.successSnackBar(
        title: 'Email sent',
        message: 'Email Link Sent to Reset your Password'.tr,
      );
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      AppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
