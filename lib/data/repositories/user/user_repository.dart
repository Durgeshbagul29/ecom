import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/features/personaliation/models/userModel.dart';
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

}