import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/features/personalization/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save user data to Firestore.
  Future<void> saveUserRecord(UserModel user) async {
    if (kDebugMode) {
      debugPrint('==================== [USER REPO: SAVE USER REQUEST] ====================');
      debugPrint('Collection: Users | DocId: ${user.id}');
      debugPrint('Payload: ${user.toJson()}');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('========================================================================');
    }
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: SAVE USER RESPONSE] ====================');
        debugPrint('Status: Success - User record saved to Firestore');
        debugPrint('User ID: ${user.id}');
        debugPrint('=========================================================================');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: SAVE USER FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code} | Message: ${e.message}');
        debugPrint('===============================================================================');
      }
      // Handle specific Firebase Firestore errors
      switch (e.code) {
        case 'permission-denied':
          throw 'You do not have permission to save this data.';
        case 'unavailable':
          throw 'Firestore service is temporarily unavailable. Please try again later.';
        default:
          throw 'Failed to save user data: ${e.message ?? 'Unknown Firebase error.'}';
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: SAVE USER PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('================================================================================');
      }
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: SAVE USER UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('=================================================================================');
      }
      throw 'Unexpected error occurred while saving user data. Please try again.';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails() async {
    final uid = AuthenticationRepository.instance.authUser?.uid;
    if (uid == null || uid.isEmpty) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: FETCH USER REQUEST] ====================');
        debugPrint('Status: No authenticated user UID found. Returning empty UserModel.');
        debugPrint('=========================================================================');
      }
      return UserModel.empty();
    }

    if (kDebugMode) {
      debugPrint('==================== [USER REPO: FETCH USER REQUEST] ====================');
      debugPrint('Collection: Users | DocId: $uid');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('=========================================================================');
    }
    try {
      final documentSnapshot = await _db.collection("Users").doc(uid).get();
      if (documentSnapshot.exists) {
        final fetchedUser = UserModel.fromSnapshot(documentSnapshot);
        if (kDebugMode) {
          debugPrint('==================== [USER REPO: FETCH USER RESPONSE] ====================');
          debugPrint('Status: User record found');
          debugPrint('Data: ${fetchedUser.toJson()}');
          debugPrint('==========================================================================');
        }
        return fetchedUser;
      } else {
        if (kDebugMode) {
          debugPrint('==================== [USER REPO: FETCH USER RESPONSE] ====================');
          debugPrint('Status: User document does not exist in Firestore, initializing default profile from Auth');
          debugPrint('==========================================================================');
        }
        final authUser = AuthenticationRepository.instance.authUser;
        if (authUser != null) {
          final displayName = (authUser.displayName != null && authUser.displayName!.trim().isNotEmpty)
              ? authUser.displayName!.trim()
              : (authUser.email != null && authUser.email!.contains('@')
                  ? authUser.email!.split('@')[0]
                  : 'User');
          final parts = UserModel.nameParts(displayName);
          final fName = parts.isNotEmpty ? parts[0] : displayName;
          final lName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
          final uname = UserModel.generateUsername(displayName);

          final defaultUser = UserModel(
            id: authUser.uid,
            firstName: fName,
            lastName: lName,
            username: uname,
            email: authUser.email ?? '',
            phoneNumber: authUser.phoneNumber ?? '',
            profilePicture: authUser.photoURL ?? '',
          );

          try {
            await saveUserRecord(defaultUser);
          } catch (_) {}
          return defaultUser;
        }
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: FETCH USER FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code} | Message: ${e.message}');
        debugPrint('================================================================================');
      }
      // Handle specific Firebase Firestore errors
      switch (e.code) {
        case 'permission-denied':
          throw 'You do not have permission to access this data.';
        case 'unavailable':
          throw 'Firestore service is temporarily unavailable. Please try again later.';
        default:
          throw 'Failed to fetch user data: ${e.message ?? 'Unknown Firebase error.'}';
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: FETCH USER PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('================================================================================');
      }
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: FETCH USER UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('==================================================================================');
      }
      throw 'Unexpected error occurred while fetching user data. Please try again.';
    }
  }

  /// Update userdata in firebase
  Future<void> updateUserDetails(UserModel updatedUser) async {
    if (kDebugMode) {
      debugPrint('==================== [USER REPO: UPDATE USER REQUEST] ====================');
      debugPrint('Collection: Users | DocId: ${updatedUser.id}');
      debugPrint('Payload: ${updatedUser.toJson()}');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('==========================================================================');
    }
    try {
      await _db.collection("Users").doc(updatedUser.id).update(updatedUser.toJson());
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: UPDATE USER RESPONSE] ====================');
        debugPrint('Status: Success - User updated in Firestore');
        debugPrint('User ID: ${updatedUser.id}');
        debugPrint('===========================================================================');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: UPDATE USER FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code} | Message: ${e.message}');
        debugPrint('=================================================================================');
      }
      // Handle specific Firebase Firestore errors
      switch (e.code) {
        case 'permission-denied':
          throw 'You do not have permission to update this data.';
        case 'unavailable':
          throw 'Firestore service is temporarily unavailable. Please try again later.';
        default:
          throw 'Failed to update user data: ${e.message ?? 'Unknown Firebase error.'}';
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: UPDATE USER PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('=================================================================================');
      }
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: UPDATE USER UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('===================================================================================');
      }
      throw 'Unexpected error occurred while updating user data. Please try again.';
    }
  }

  /// Update any single field in users collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    final uid = AuthenticationRepository.instance.authUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw 'User is not authenticated. Cannot update field.';
    }
    if (kDebugMode) {
      debugPrint('==================== [USER REPO: UPDATE FIELD REQUEST] ====================');
      debugPrint('Collection: Users | DocId: $uid');
      debugPrint('Payload: $json');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('==========================================================================');
    }
    try {
      await _db.collection("Users").doc(uid).update(json);
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: UPDATE FIELD RESPONSE] ====================');
        debugPrint('Status: Success - Field updated in Firestore');
        debugPrint('============================================================================');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: UPDATE FIELD FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code} | Message: ${e.message}');
        debugPrint('==================================================================================');
      }
      // Handle specific Firebase Firestore errors
      switch (e.code) {
        case 'permission-denied':
          throw 'You do not have permission to update this data.';
        case 'unavailable':
          throw 'Firestore service is temporarily unavailable. Please try again later.';
        default:
          throw 'Failed to update user data: ${e.message ?? 'Unknown Firebase error.'}';
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: UPDATE FIELD PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('==================================================================================');
      }
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: UPDATE FIELD UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('====================================================================================');
      }
      throw 'Unexpected error occurred while updating user data. Please try again.';
    }
  }

  /// Update any single field in users collection
  Future<void> removeUserRecord(String userId) async {
    if (kDebugMode) {
      debugPrint('==================== [USER REPO: REMOVE USER REQUEST] ====================');
      debugPrint('Collection: Users | DocId: $userId');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
      debugPrint('==========================================================================');
    }
    try {
      await _db.collection("Users").doc(userId).delete();
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: REMOVE USER RESPONSE] ====================');
        debugPrint('Status: Success - User record removed from Firestore');
        debugPrint('User ID: $userId');
        debugPrint('===========================================================================');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: REMOVE USER FIREBASE ERROR] ====================');
        debugPrint('Code: ${e.code} | Message: ${e.message}');
        debugPrint('=================================================================================');
      }
      // Handle specific Firebase Firestore errors
      switch (e.code) {
        case 'permission-denied':
          throw 'You do not have permission to delete this data.';
        case 'unavailable':
          throw 'Firestore service is temporarily unavailable. Please try again later.';
        default:
          throw 'Failed to delete user data: ${e.message ?? 'Unknown Firebase error.'}';
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: REMOVE USER PLATFORM ERROR] ====================');
        debugPrint('Error: ${e.message}');
        debugPrint('=================================================================================');
      }
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('==================== [USER REPO: REMOVE USER UNEXPECTED ERROR] ====================');
        debugPrint('Error: $e');
        debugPrint('===================================================================================');
      }
      throw 'Unexpected error occurred while saving user data. Please try again.';
    }
  }

}
