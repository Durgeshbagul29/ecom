import 'dart:async';

import 'package:ecom/common/widgets/screens/success_screen.dart';
import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/utils/constants/app_text.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      AppLoaders.successSnackBar(
        title: 'Email Send',
        message: 'Please Check your inbox and verify your email.',
      );
    } catch (e) {
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
