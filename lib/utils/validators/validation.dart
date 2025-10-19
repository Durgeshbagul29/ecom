class AppValidator {
  // Empty text validation
  static String? validatedEmptyText(String? fieldName, String? value){
    if(value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  // Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Email regex
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null; // valid
  }

  // Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Min length check
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    return null; // valid
  }

  // Validate Phone Number (10 digits)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Phone regex (10 digits)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null; // valid
  }
}
