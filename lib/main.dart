import 'package:ecom/data/repositories/AuthenticationRepository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecom/ecom_app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Firebase Configuration Package
import 'firebase_options.dart';

/// ---------- Entry Point Of Flutter App ----------
Future<void> main() async {
  /// Widgets flutter binding
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// System UI Mode Edge-to-Edge for modern Android & iOS
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  /// GetX Local Storage
  await GetStorage.init();

  /// Flutter Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Initialize Firebase & Authentication Repository
  /// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  runApp(const EComApp());
}
