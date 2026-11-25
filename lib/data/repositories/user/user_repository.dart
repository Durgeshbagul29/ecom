import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:ecom/features/personalization/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save user data to Firestore.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
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
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      throw 'Unexpected error occurred while saving user data. Please try again.';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot =  await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if(documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
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
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      throw 'Unexpected error occurred while saving user data. Please try again.';
    }
  }

  /// Update userdata in firebase
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db.collection("Users").doc(updatedUser.id).update(updatedUser.toJson());
    } on FirebaseException catch (e) {
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
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      throw 'Unexpected error occurred while saving user data. Please try again.';
    }
  }

  /// Update any single field in users collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    } on FirebaseException catch (e) {
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
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      throw 'Unexpected error occurred while saving user data. Please try again.';
    }
  }

  /// Update any single field in users collection
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e) {
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
      throw 'Platform error occurred: ${e.message ?? 'Unknown platform issue.'}';
    } on FormatException {
      throw 'Invalid data format. Please check your input and try again.';
    } catch (e) {
      throw 'Unexpected error occurred while saving user data. Please try again.';
    }
  }

}