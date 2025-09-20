import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppHelperFunctions {
  // Private Constructor
  AppHelperFunctions._();

  /// Returns a Color based on a string value
  static Color? getColor(String value) {
    switch (value.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      case 'grey':
        return Colors.grey;
      case 'purple':
        return Colors.purple;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'Brown':
        return Colors.brown;
      case 'Teal':
        return Colors.teal;
      case 'Indigo':
        return Colors.indigo;
      default:
        return null; // If no match found
    }
  }

  /// Show a SnackBar message
  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Show an Alert Dialog
  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Navigate to another screen
  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Truncate text if it's longer than maxLength
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  /// Check if dark mode is enabled
  static bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get full screen size
  static Size screenSize() {
  return MediaQuery.of(Get.context!).size;
  }

  /// Get screen height
  static double screenHeight() {
  return MediaQuery.of(Get.context!).size.height;
  }

  /// Get screen width
  static double screenWidth() {
  return MediaQuery.of(Get.context!).size.width;
  }

  /// Format date
  static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Remove duplicates from a list
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  /// Wrap widgets into rows of given size
  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
        i,
        i + rowSize > widgets.length ? widgets.length : i + rowSize,
      );
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

}
