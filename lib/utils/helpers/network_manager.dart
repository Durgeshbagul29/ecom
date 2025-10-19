// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:ecom/utils/popups/loaders.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// /// Manages the network connectivity status and provides methods
// /// to check and handle connectivity changes.
// class NetworkManager extends GetxController {
//   static NetworkManager get instance => Get.find();
//
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;
//   final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;
//
//   /// Initialize the network manager and set up a stream to continually check the connection status.
//   @override
//   void onInit() {
//     super.onInit();
//     _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>;
//   }
//
//   /// Update the connection status based on changes in connectivity
//   /// and show a relevant popup for no internet connection.
//   Future<void> _updateConnectionStatus(ConnectivityResult result) async {
//     _connectionStatus.value = result;
//     if (_connectionStatus.value == ConnectivityResult.none) {
//       AppLoaders.warningSnackBar(title: 'No Internet Connection');
//     }
//   }
//
//   /// Check the internet connection status.
//   /// Returns `true` if connected, `false` otherwise.
//   Future<bool> isConnected() async {
//     try {
//       final result = await _connectivity.checkConnectivity();
//       if (result == ConnectivityResult.none) {
//         return false;
//       } else {
//         return true;
//       }
//     } on PlatformException catch (_) {
//       return false;
//     }
//   }
//
//   /// Dispose or close the active connectivity stream.
//   @override
//   void onClose() {
//     super.onClose();
//     _connectivitySubscription.cancel();
//   }
// }
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecom/utils/popups/loaders.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// ---------------------------------------------------------------------------
/// NetworkManager
/// ---------------------------------------------------------------------------
/// Manages network connectivity status in the app.
/// - Monitors real-time connection changes.
/// - Displays warning popup when the connection is lost.
/// - Provides a method to manually check connection status.
/// ---------------------------------------------------------------------------
class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  /// Called when the controller is initialized.
  /// Subscribes to connectivity changes and updates status accordingly.
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
          final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
          _updateConnectionStatus(result);
        });
  }

  /// Handles connectivity updates and displays warning if disconnected.
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus.value = result;

    if (_connectionStatus.value == ConnectivityResult.none) {
      AppLoaders.warningSnackBar(title: 'No Internet Connection');
    }
  }

  /// Checks internet connection manually.
  /// Returns `true` if connected, `false` otherwise.
  Future<bool> isConnected() async {
    try {
      final results = await _connectivity.checkConnectivity();

      // New API returns a list, so check first element.
      if (results.isEmpty || results.first == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Cancels active connectivity subscription.
  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
