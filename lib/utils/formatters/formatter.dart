import 'package:intl/intl.dart';

class AppFormatter {
  /// Format a Date into a readable string (e.g., 05-Sep-2025)
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  /// Format a double into currency (default: USD)
  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  /// Format phone number (basic US style: (123) 456-7890)
  static String formatPhoneNumber(String phoneNumber) {
    // Assuming a 10-digit US phone number
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    }
    // If 11 digits (e.g., country code + local number)
    else if (phoneNumber.length == 11) {
      return '${phoneNumber.substring(0, 4)} ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }
    // Default: return unformatted
    return phoneNumber;
  }

  /// Format an international phone number with country code
  /// Example: +1 123 456 7890  or  +91 98765 43210
  static String internationalFormatPhoneNumber(String phoneNumber) {
  // Remove any non-digit characters
  var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // Extract country code (first 2 digits, e.g. "91" for India)
  String countryCode = '+${digitsOnly.substring(0, 2)}';
  digitsOnly = digitsOnly.substring(2);

  // Build formatted number
  final formattedNumber = StringBuffer();
  formattedNumber.write('$countryCode ');

  int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;

      // Special handling for US numbers
      if (i == 0 && countryCode == '+1') {
        groupLength = 3;
      }

      int end = i + groupLength;
      // if (end > digitsOnly.length) end = digitsOnly.length;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }
      i = end;
    }
    return formattedNumber.toString();
  }





}
