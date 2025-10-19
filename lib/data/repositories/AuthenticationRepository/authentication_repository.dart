import 'package:ecom/features/authentication/screens/login/login_screen.dart';
import 'package:ecom/features/authentication/screens/onboarding/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;

  // Variables
  final deviceStorage = GetStorage();

  // Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  // Function to show relevant screen
  screenRedirect() async {
    // Local Storage
    if (kDebugMode){
      print('============ GET STORAGE [In Authentication Repository] ============');
      print(deviceStorage.read('isFirstTime'));
    }

    deviceStorage.writeIfNull('isFirstTime', true);
    deviceStorage.read('isFirstTime') != true ? Get.offAll(() => const LoginScreen()) : Get.offAll(() => const OnBoardingScreen());
  }

  //* ----------- Email and Password Sign-In ----------- */

  /// [EmailAuthentication] - SignIn

  /// Register a new user with email and password.
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Provide specific, user-friendly messages
      switch (e.code) {
        case 'email-already-in-use':
          throw 'This email is already registered. Please log in instead.';
        case 'invalid-email':
          throw 'The email address is invalid. Please check and try again.';
        case 'weak-password':
          throw 'Your password is too weak. Please choose a stronger one.';
        default:
          throw 'Registration failed: ${e.message ?? 'Unknown error.'}';
      }
    } on PlatformException catch (e) {
      throw 'Platform error: ${e.message ?? 'Unexpected issue occurred.'}';
    } on FormatException {
      throw 'Invalid input format. Please check your data.';
    } catch (e) {
      throw 'An unexpected error occurred during registration. Please try again.';
    }
  }

}