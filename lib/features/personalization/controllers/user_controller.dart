import 'package:ecom/data/repositories/user/user_repository.dart';
import 'package:ecom/features/personalization/models/user_model.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance =>
      Get.isRegistered<UserController>() ? Get.find<UserController>() : Get.put(UserController());

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepo = Get.isRegistered<UserRepository>() ? Get.find<UserRepository>() : Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// Fetch user record
  Future<void> fetchUserRecord() async {
    try {
      // Don't attempt to fetch if user is not authenticated
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
    } catch(e) {
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

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      if (userCredential != null) {
        // Convert Name to first and last name
        final nameParts = UserModel.nameParts(
          userCredential.user!.displayName ?? '',
        );
        final userName = UserModel.generateUsername(
          userCredential.user!.displayName ?? '',
        );

        // Map Data
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

        // Save user data
        await userRepo.saveUserRecord(user);

        if (kDebugMode) {
          debugPrint('==================== [USER CONTROLLER - SAVE RECORD RESPONSE] ====================');
          debugPrint('Status: User record saved');
          debugPrint('==================================================================================');
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
}
