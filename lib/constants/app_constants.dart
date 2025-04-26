class AppConstants {
  // Firebase Collections
  static const String usersCollection = 'users';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxUsernameLength = 20;
  static const int minUsernameLength = 3;

  // Error Messages
  static const String genericError =
      'An unexpected error occurred. Please try again.';
  static const String networkError =
      'Please check your internet connection and try again.';

  // Success Messages
  static const String passwordResetSent = 'Password reset email has been sent.';
  static const String profileUpdated = 'Profile updated successfully.';
}
