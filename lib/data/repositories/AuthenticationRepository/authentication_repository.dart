import 'package:ecom/features/authentication/screens/login/login_screen.dart';
import 'package:ecom/features/authentication/screens/onboarding/onboarding.dart';
import 'package:ecom/features/authentication/screens/signup/verify_email_screen.dart';
import 'package:ecom/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    // Remove the native splash screen
    FlutterNativeSplash.remove();
    // Redirect to the appropriate screen
    screenRedirect();
  }

  // Function to show relevant screen
  screenRedirect() async {
    User? user = _auth.currentUser;
    //
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      /// Local Storage check first time or not
      // if (kDebugMode) {
      //   print(
      //     '============ GET STORAGE [In Authentication Repository] ============',
      //   );
      //   print(deviceStorage.read('isFirstTime'));
      // }
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const OnBoardingScreen());
    }
  }

  //* ----------- Email and Password Sign-In ----------- */

  /// [EmailAuthentication] - SignIn
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No account found with this email. Please sign up first.';
        case 'wrong-password':
          throw 'Incorrect password. Please try again.';
        case 'invalid-email':
          throw 'The email address is invalid. Please check and try again.';
        case 'user-disabled':
          throw 'This account has been disabled. Please contact support.';
        default:
          throw 'Login failed: ${e.message ?? 'Unknown error.'}';
      }
    } on PlatformException catch (e) {
      throw 'Platform error: ${e.message ?? 'Unexpected issue occurred.'}';
    } on FormatException {
      throw 'Invalid input format. Please check your data.';
    } catch (e) {
      throw 'An unexpected error occurred during login. Please try again.';
    }
  }


  /// Register a new user with email and password.
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
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

  /// [EmailVerification] - Mail Verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'No authenticated user found.';
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication specific errors
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for this email.';
        case 'invalid-email':
          throw 'The provided email address is invalid. Please check and try again.';
        case 'too-many-requests':
          throw 'Too many requests. Please wait a moment and try again.';
        default:
          throw 'Authentication error: ${e.message ?? 'Unknown FirebaseAuth error occurred.'}';
      }
    } on FirebaseException catch (e) {
      // Handles general Firebase errors not limited to Auth
      throw 'Firebase error: ${e.message ?? 'An unexpected Firebase issue occurred.'}';
    } on PlatformException catch (e) {
      throw 'Platform error: ${e.message ?? 'A platform-related issue occurred.'}';
    } on FormatException {
      throw 'Invalid input format. Please verify your data and try again.';
    } catch (e) {
      throw 'An unexpected error occurred while sending the verification email. Please try again.';
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for this email.';
        case 'invalid-email':
          throw 'The provided email address is invalid.';
        case 'too-many-requests':
          throw 'Too many requests. Please wait and try again.';
        default:
          throw 'Authentication error: ${e.message ?? 'Unknown FirebaseAuth error.'}';
      }
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.message ?? 'An unexpected Firebase issue occurred.'}';
    } on PlatformException catch (e) {
      throw 'Platform error: ${e.message ?? 'A platform-related issue occurred.'}';
    } on FormatException {
      throw 'Invalid input format. Please verify your data and try again.';
    } catch (e) {
      throw 'An unexpected error occurred while logging out. Please try again.';
    }
  }

}
