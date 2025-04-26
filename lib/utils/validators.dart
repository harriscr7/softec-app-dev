import 'package:softec_project/constants/app_constants.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < AppConstants.minUsernameLength) {
      return 'Username must be at least ${AppConstants.minUsernameLength} characters';
    }
    if (value.length > AppConstants.maxUsernameLength) {
      return 'Username must be less than ${AppConstants.maxUsernameLength} characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }
}
