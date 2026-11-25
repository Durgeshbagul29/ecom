import 'package:ecom/features/authentication/screens/login/login_screen.dart';
import 'package:ecom/features/authentication/screens/onboarding/onboarding.dart';
import 'package:ecom/features/authentication/screens/signup/verify_email_screen.dart';
import 'package:ecom/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;

  // Variables
  final deviceStorage = GetStorage();

  /// Get Authenticated User Data - (Getter Method)
  User? get authUser => _auth.currentUser;

  // Called from main.dart on app launch
  @override
  void onReady() {
    // Remove the native splash screen
    FlutterNativeSplash.remove();
    // Redirect to the appropriate screen
    screenRedirect();
  }

  /// Function to show relevant screen
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
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const OnBoardingScreen());
    }
  }

  //* ------------------- Email and Password Sign-In ------------------- */

  /// [EmailAuthentication] - SignIn
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    if (kDebugMode) {
      debugPrint('==================== [AUTH REPO: LOGIN REQUEST] ====================');
      debugPrint('Action: signInWithEmailAndPassword');
      debugPrint('Email: $email');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('====================================================================');
    }
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: LOGIN RESPONSE] ====================');
        debugPrint('Status: Authentication Successful');
        debugPrint('UID: ${credential.user?.uid}');
        debugPrint('Email: ${credential.user?.email}');
        debugPrint('Email Verified: ${credential.user?.emailVerified}');
        debugPrint('=====================================================================');
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: LOGIN FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code}');
        debugPrint('Message: ${e.message}');
        debugPrint('===========================================================================');
      }
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
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: LOGIN PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('===========================================================================');
      }
      throw 'Platform error: ${e.message ?? 'Unexpected issue occurred.'}';
    } on FormatException {
      throw 'Invalid input format. Please check your data.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: LOGIN UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('=============================================================================');
      }
      throw 'An unexpected error occurred during login. Please try again.';
    }
  }


  /// Register a new user with email and password.
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    if (kDebugMode) {
      debugPrint('==================== [AUTH REPO: REGISTER REQUEST] ====================');
      debugPrint('Action: createUserWithEmailAndPassword');
      debugPrint('Email: $email');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('=======================================================================');
    }
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: REGISTER RESPONSE] ====================');
        debugPrint('Status: User Created Successfully');
        debugPrint('UID: ${credential.user?.uid}');
        debugPrint('Email: ${credential.user?.email}');
        debugPrint('========================================================================');
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: REGISTER FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code}');
        debugPrint('Message: ${e.message}');
        debugPrint('==============================================================================');
      }
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
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: REGISTER PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('==============================================================================');
      }
      throw 'Platform error: ${e.message ?? 'Unexpected issue occurred.'}';
    } on FormatException {
      throw 'Invalid input format. Please check your data.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: REGISTER UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('================================================================================');
      }
      throw 'An unexpected error occurred during registration. Please try again.';
    }
  }

  /// [EmailVerification] - Mail Verification
  Future<void> sendEmailVerification() async {
    if (kDebugMode) {
      debugPrint('==================== [AUTH REPO: SEND EMAIL VERIFICATION REQUEST] ====================');
      debugPrint('Action: sendEmailVerification');
      debugPrint('Current User: ${_auth.currentUser?.email} (UID: ${_auth.currentUser?.uid})');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('======================================================================================');
    }
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'No authenticated user found.';
      await user.sendEmailVerification();
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: SEND EMAIL VERIFICATION RESPONSE] ====================');
        debugPrint('Status: Verification Email Sent Successfully');
        debugPrint('User: ${user.email}');
        debugPrint('=======================================================================================');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: EMAIL VERIFICATION FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code}');
        debugPrint('Message: ${e.message}');
        debugPrint('========================================================================================');
      }
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
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: EMAIL VERIFICATION FIREBASE EXCEPTION] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('============================================================================================');
      }
      throw 'Firebase error: ${e.message ?? 'An unexpected Firebase issue occurred.'}';
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: EMAIL VERIFICATION PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('========================================================================================');
      }
      throw 'Platform error: ${e.message ?? 'A platform-related issue occurred.'}';
    } on FormatException {
      throw 'Invalid input format. Please verify your data and try again.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: EMAIL VERIFICATION UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('==========================================================================================');
      }
      throw 'An unexpected error occurred while sending the verification email. Please try again.';
    }
  }

  /// Forgot Password
  Future<void> sendResetPasswordEmail(String email) async {
    if (kDebugMode) {
      debugPrint('==================== [AUTH REPO: RESET PASSWORD REQUEST] ====================');
      debugPrint('Action: sendPasswordResetEmail');
      debugPrint('Email: $email');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('=============================================================================');
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: RESET PASSWORD RESPONSE] ====================');
        debugPrint('Status: Password Reset Email Sent Successfully');
        debugPrint('Target Email: $email');
        debugPrint('==============================================================================');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: RESET PASSWORD FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code}');
        debugPrint('Message: ${e.message}');
        debugPrint('====================================================================================');
      }
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
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: RESET PASSWORD FIREBASE EXCEPTION] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('========================================================================================');
      }
      throw 'Firebase error: ${e.message ?? 'An unexpected Firebase issue occurred.'}';
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: RESET PASSWORD PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('====================================================================================');
      }
      throw 'Platform error: ${e.message ?? 'A platform-related issue occurred.'}';
    } on FormatException {
      throw 'Invalid input format. Please verify your data and try again.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: RESET PASSWORD UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('======================================================================================');
      }
      throw 'An unexpected error occurred while sending the verification email. Please try again.';
    }
  }

  /* ------------------------- Social Sign In ------------------------- */
  /// Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    if (kDebugMode) {
      debugPrint('==================== [AUTH REPO: GOOGLE SIGN-IN REQUEST] ====================');
      debugPrint('Action: signInWithGoogle');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('=============================================================================');
    }
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credentials);
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: GOOGLE SIGN-IN RESPONSE] ====================');
        debugPrint('Status: Google Sign-In Successful');
        debugPrint('UID: ${userCredential.user?.uid}');
        debugPrint('Email: ${userCredential.user?.email}');
        debugPrint('Display Name: ${userCredential.user?.displayName}');
        debugPrint('==============================================================================');
      }
      return userCredential;

    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: GOOGLE SIGN-IN FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code}');
        debugPrint('Message: ${e.message}');
        debugPrint('====================================================================================');
      }
      throw e.message ?? 'A Firebase authentication error occurred.';
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: GOOGLE SIGN-IN FIREBASE EXCEPTION] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('========================================================================================');
      }
      throw e.message ?? 'A Firebase error occurred.';
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: GOOGLE SIGN-IN PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('====================================================================================');
      }
      throw e.message ?? 'A platform-specific error occurred.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: GOOGLE SIGN-IN UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('======================================================================================');
      }
      return null;
    }
  }


  /// Logout current user
  Future<void> logout() async {
    if (kDebugMode) {
      debugPrint('==================== [AUTH REPO: LOGOUT REQUEST] ====================');
      debugPrint('Action: signOut');
      debugPrint('Current User: ${_auth.currentUser?.email} (UID: ${_auth.currentUser?.uid})');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('=====================================================================');
    }
    try {
      await FirebaseAuth.instance.signOut();
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: LOGOUT RESPONSE] ====================');
        debugPrint('Status: User Signed Out Successfully');
        debugPrint('======================================================================');
      }
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: LOGOUT FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code}');
        debugPrint('Message: ${e.message}');
        debugPrint('============================================================================');
      }
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
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: LOGOUT FIREBASE EXCEPTION] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('================================================================================');
      }
      throw 'Firebase error: ${e.message ?? 'An unexpected Firebase issue occurred.'}';
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: LOGOUT PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('============================================================================');
      }
      throw 'Platform error: ${e.message ?? 'A platform-related issue occurred.'}';
    } on FormatException {
      throw 'Invalid input format. Please verify your data and try again.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [AUTH REPO: LOGOUT UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('==============================================================================');
      }
      throw 'An unexpected error occurred while logging out. Please try again.';
    }
  }

}
