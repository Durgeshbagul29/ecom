import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/data/repositories/user/user_repository.dart';
import 'package:ecom/data/services/cloudinary_service.dart';
import 'package:ecom/features/authentication/screens/login/login_screen.dart';
import 'package:ecom/features/personalization/models/user_model.dart';
import 'package:ecom/features/personalization/screens/profile/widgets/re_authentication_user_login.dart';
import 'package:ecom/utils/constants/images.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/network_manager.dart';
import 'package:ecom/utils/popups/full_screen_loader.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance =>
      Get.isRegistered<UserController>() ? Get.find<UserController>() : Get.put(
          UserController());

  final profileLoading = false.obs;
  final imageUploading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepo = Get.isRegistered<UserRepository>() ? Get.find<
      UserRepository>() : Get.put(UserRepository());

  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        user(UserModel.empty());
        return;
      }

      profileLoading.value = true;
      if (kDebugMode) {
        debugPrint('==================== [USER CONTROLLER - FETCH RECORD REQUEST] ====================');
        debugPrint('Action: fetchUserDetails for UID: ${authUser.uid}');
        debugPrint('==================================================================================');
      }
      final fetchedUser = await userRepo.fetchUserDetails();
      user(fetchedUser);
      if (kDebugMode) {
        debugPrint('==================== [USER CONTROLLER - FETCH RECORD RESPONSE] ====================');
        debugPrint('Fetched User: ${fetchedUser.toJson()}');
        debugPrint('===================================================================================');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER CONTROLLER - FETCH RECORD ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('================================================================================');
      }
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      await fetchUserRecord();

      if (user.value.id.isEmpty) {
        if (userCredential != null) {
          final nameParts = UserModel.nameParts(
            userCredential.user!.displayName ?? '',
          );
          final userName = UserModel.generateUsername(
            userCredential.user!.displayName ?? '',
          );

          final user = UserModel(
            id: userCredential.user!.uid,
            firstName: nameParts[0],
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            username: userName,
            email: userCredential.user!.email ?? '',
            phoneNumber: userCredential.user!.phoneNumber ?? '',
            profilePicture: userCredential.user!.photoURL ?? '',
          );

          if (kDebugMode) {
            debugPrint('==================== [USER CONTROLLER - SAVE RECORD REQUEST] ====================');
            debugPrint('Action: saveUserRecord from provider');
            debugPrint('Payload: ${user.toJson()}');
            debugPrint('=================================================================================');
          }

          await userRepo.saveUserRecord(user);

          if (kDebugMode) {
            debugPrint('==================== [USER CONTROLLER - SAVE RECORD RESPONSE] ====================');
            debugPrint('Status: User record saved');
            debugPrint('==================================================================================');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER CONTROLLER - SAVE RECORD ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('================================================================================');
      }
      AppLoaders.warningSnackBar(
        title: 'Data not saved',
        message:
        'Something went wrong while saving your information,. You can re-save your data in your Profile.',
      );
    }
  }

  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(AppSizes.md),
      title: 'Delete Account',
      middleText:
          'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async {
          Navigator.of(Get.overlayContext!).pop();
          deleteUserAccount();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: Text('Delete')),
      ),
      cancel: OutlinedButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
      ),
    );
  }

  void deleteUserAccount() async {
    try {
      FullScreenLoader.openLoadingDialog(
          'Processing..', AppImages.bubbleLoading);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      final auth = AuthenticationRepository.instance;
      final authUser = auth.authUser;

      if (authUser == null) {
        FullScreenLoader.stopLoading();
        AppLoaders.warningSnackBar(title: 'Error', message: 'No authenticated user found.');
        return;
      }

      final provider = authUser.providerData.isNotEmpty
          ? authUser.providerData.map((e) => e.providerId).first
          : 'password';

      if (provider == 'google.com') {
        await auth.signInWithGoogle();
        await auth.deleteAccount();
        FullScreenLoader.stopLoading();
        Get.offAll(() => const LoginScreen());
      } else {
        FullScreenLoader.stopLoading();
        verifyEmail.text = authUser.email ?? user.value.email;
        Get.to(() => const ReAuthLoginForm());
      }
    } catch (e) {
      FullScreenLoader.stopLoading();
      AppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> reAuthenticateEmailAndPassword() async {
    try {
      FullScreenLoader.openLoadingDialog('Processing', AppImages.bubbleLoading);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
        verifyEmail.text.trim(),
        verifyPassword.text.trim(),
      );

      await AuthenticationRepository.instance.deleteAccount();
      FullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      FullScreenLoader.stopLoading();
      AppLoaders.warningSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  Future<String> uploadImage(XFile image, {String? folder}) async {
    try {
      return await CloudinaryService.uploadImage(image, folder: folder);
    } on PlatformException catch (e) {
      throw e.message ?? 'Platform error occurred (${e.code}).';
    } catch (e) {
      if (e is String) rethrow;
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> uploadUserProfilePicture({
    ImageSource source = ImageSource.gallery,
  }) async {
    if (imageUploading.value) return;

    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image == null) return;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      final uid =
          AuthenticationRepository.instance.authUser?.uid ?? user.value.id;
      if (uid.isEmpty) {
        AppLoaders.errorSnackBar(
          title: 'Oh Snap!',
          message: 'User is not authenticated.',
        );
        return;
      }

      imageUploading.value = true;

      final imageUrl = await uploadImage(
        image,
        folder: 'ecom/user/profileImages/$uid',
      );

      // Save secure_url to Firestore: Users/{uid} → ProfilePicture
      await userRepo.updateSingleField({'ProfilePicture': imageUrl});

      user.value.profilePicture = imageUrl;
      user.refresh();

      AppLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your Profile Image has been updated!',
      );
    } catch (e) {
      AppLoaders.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    } finally {
      imageUploading.value = false;
    }
  }
}
