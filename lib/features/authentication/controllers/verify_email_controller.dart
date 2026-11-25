import 'dart:async';

import 'package:ecom/common/widgets/screens/success_screen.dart';
import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  /// Send Email whenever Verify Screen appears & Set Timer for auto redirect.
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// Send Email Verification link
  sendEmailVerification() async {
    if (kDebugMode) {
      debugPrint('==================== [VERIFY EMAIL CONTROLLER - REQUEST] ====================');
      debugPrint('Action: Send Email Verification Link');
      debugPrint('User: ${FirebaseAuth.instance.currentUser?.email}');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('==============================================================================');
    }
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      if (kDebugMode) {
        debugPrint('==================== [VERIFY EMAIL CONTROLLER - RESPONSE] ====================');
        debugPrint('Status: Verification email sent successfully');
        debugPrint('===============================================================================');
      }
      AppLoaders.successSnackBar(
        title: 'Email Send',
        message: 'Please Check your inbox and verify your email.',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [VERIFY EMAIL CONTROLLER - ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('===========================================================================');
      }
      AppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        if (kDebugMode) {
          debugPrint('==================== [VERIFY EMAIL - AUTO REDIRECT] ====================');
          debugPrint('User Email Verified: true (UID: ${user?.uid})');
          debugPrint('=========================================================================');
        }
        Get.off(
          () => SuccessScreen(
            title: AppText.accountCreatedTitle,
            subTitle: AppText.accountCreatedSubTitle,
            image: AppImages.successDoneAnimation,
            onTap: () => AuthenticationRepository.instance.screenRedirect(),
          ),
        );
      }
    });
  }

  /// Manually Check if Email Verification
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (kDebugMode) {
      debugPrint('==================== [VERIFY EMAIL - MANUAL CHECK] ====================');
      debugPrint('Checking status for: ${currentUser?.email}');
      debugPrint('Is Verified: ${currentUser?.emailVerified ?? false}');
      debugPrint('========================================================================');
    }
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          title: AppText.accountCreatedTitle,
          subTitle: AppText.accountCreatedSubTitle,
          image: AppImages.successDoneAnimation,
          onTap: () => AuthenticationRepository.instance.screenRedirect(),
        ),
      );
    }
  }
}
