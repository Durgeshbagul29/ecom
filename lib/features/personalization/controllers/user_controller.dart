import 'dart:io';

import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/data/repositories/user/user_repository.dart';
import 'package:ecom/data/services/cloudinary_service.dart';
import 'package:ecom/features/authentication/screens/login/login_screen.dart';
import 'package:ecom/features/personalization/models/user_model.dart';
import 'package:ecom/features/personalization/screens/profile/widgets/profile_image_cropper.dart';
import 'package:ecom/features/personalization/screens/profile/widgets/re_authentication_user_login.dart';
import 'package:ecom/utils/constants/colors.dart';
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
import 'package:get_storage/get_storage.dart';
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

  Future<CloudinaryUploadResult> uploadImageWithDetails(
    XFile image, {
    String? folder,
  }) async {
    try {
      return await CloudinaryService.uploadImageWithDetails(
        image,
        folder: folder,
      );
    } on PlatformException catch (e) {
      throw e.message ?? 'Platform error occurred (${e.code}).';
    } catch (e) {
      if (e is String) rethrow;
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<String> uploadImage(XFile image, {String? folder}) async {
    final result = await uploadImageWithDetails(image, folder: folder);
    return result.secureUrl;
  }

  static const Duration _deleteTokenMaxAge = Duration(minutes: 10);

  String _deleteTokenKey(String uid) => 'profile_image_delete_token_$uid';
  String _deleteTokenAtKey(String uid) => 'profile_image_delete_token_at_$uid';

  Future<void> _deletePreviousProfileImageIfPossible(String uid) async {
    final storage = GetStorage();
    final previousToken = storage.read<String>(_deleteTokenKey(uid));
    final savedAtMs = storage.read<int>(_deleteTokenAtKey(uid));

    if (previousToken == null || previousToken.isEmpty || savedAtMs == null) {
      if (kDebugMode) {
        debugPrint(
          '[PROFILE IMAGE CLEANUP] Skipped: no previous delete_token stored for UID $uid.',
        );
      }
      return;
    }

    final savedAt = DateTime.fromMillisecondsSinceEpoch(savedAtMs);
    if (DateTime.now().difference(savedAt) < _deleteTokenMaxAge) {
      final deleted = await CloudinaryService.deleteByToken(previousToken);
      if (kDebugMode) {
        debugPrint(
          '[PROFILE IMAGE CLEANUP] deleteByToken result for UID $uid: $deleted',
        );
      }
    } else if (kDebugMode) {
      debugPrint(
        '[PROFILE IMAGE CLEANUP] Skipped: previous delete_token expired (>10 min).',
      );
    }

    await storage.remove(_deleteTokenKey(uid));
    await storage.remove(_deleteTokenAtKey(uid));
  }

  Future<void> _saveProfileDeleteToken(String uid, String? deleteToken) async {
    final storage = GetStorage();
    if (deleteToken != null && deleteToken.isNotEmpty) {
      await storage.write(_deleteTokenKey(uid), deleteToken);
      await storage.write(
        _deleteTokenAtKey(uid),
        DateTime.now().millisecondsSinceEpoch,
      );
      if (kDebugMode) {
        debugPrint(
          '[PROFILE IMAGE CLEANUP] Saved new delete_token for UID $uid (valid 10 min).',
        );
      }
    } else {
      await storage.remove(_deleteTokenKey(uid));
      await storage.remove(_deleteTokenAtKey(uid));
      if (kDebugMode) {
        debugPrint(
          '[PROFILE IMAGE CLEANUP] No delete_token in Cloudinary response. '
          'Enable "Return delete token" in upload preset "${CloudinaryService.uploadPresetName}".',
        );
      }
    }
  }

  Future<ImageSource?> _pickImageSource(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.defaultSpace,
              AppSizes.sm,
              AppSizes.defaultSpace,
              AppSizes.defaultSpace,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Photo',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSizes.spaceBtwItems),
                Row(
                  children: [
                    _buildSourceOption(
                      context: sheetContext,
                      icon: Icons.photo_camera_outlined,
                      label: 'Camera',
                      onTap: () =>
                          Navigator.of(sheetContext).pop(ImageSource.camera),
                    ),
                    const SizedBox(width: AppSizes.spaceBtwSections),
                    _buildSourceOption(
                      context: sheetContext,
                      icon: Icons.photo_library_outlined,
                      label: 'Gallery',
                      onTap: () =>
                          Navigator.of(sheetContext).pop(ImageSource.gallery),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grey),
              ),
              child: Icon(icon, color: AppColors.primary, size: AppSizes.iconMd),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Future<void> uploadUserProfilePicture({
    ImageSource? source,
  }) async {
    if (imageUploading.value) return;

    XFile? croppedTempFile;

    try {
      final initialContext = Get.context;
      final selectedSource = source ??
          (initialContext != null
              ? await _pickImageSource(initialContext)
              : ImageSource.gallery);
      if (selectedSource == null) return;

      // Pick original PNG/JPG without pre-compression so alpha PNGs and sharp JPGs stay intact.
      final pickedImage = await ImagePicker().pickImage(
        source: selectedSource,
      );
      if (pickedImage == null) return;

      List<int>? headerBytes;
      try {
        headerBytes = await pickedImage.openRead(0, 12).first;
      } catch (_) {}
      if (!CloudinaryService.isPngOrJpg(pickedImage, headerBytes: headerBytes)) {
        AppLoaders.warningSnackBar(
          title: 'Unsupported Format',
          message: 'Only PNG and JPG images are supported.',
        );
        return;
      }

      final XFile? imageToUpload = Get.key.currentState != null
          ? await Get.to<XFile?>(
              () => ProfileImageCropper(imageFile: pickedImage),
              fullscreenDialog: true,
            )
          : pickedImage;
      if (imageToUpload == null) return;
      if (imageToUpload != pickedImage) {
        croppedTempFile = imageToUpload;
      }

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

      final uploadResult = await uploadImageWithDetails(
        imageToUpload,
        folder: 'ecom/user/profileImages/$uid',
      );

      // Save secure_url to Firestore: Users/{uid} → ProfilePicture
      await userRepo.updateSingleField({'ProfilePicture': uploadResult.secureUrl});

      user.value.profilePicture = uploadResult.secureUrl;
      user.refresh();

      // Best-effort cleanup of previous profile image within Cloudinary's 10-min delete_token window.
      await _deletePreviousProfileImageIfPossible(uid);
      await _saveProfileDeleteToken(uid, uploadResult.deleteToken);

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
      if (!kIsWeb &&
          croppedTempFile != null &&
          croppedTempFile.path.isNotEmpty) {
        try {
          final file = File(croppedTempFile.path);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (_) {}
      }
    }
  }
}
