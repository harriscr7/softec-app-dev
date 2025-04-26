import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF3F51B5);
  static const Color secondary = Color(0xFF7986CB);
  static const Color accent = Color(0xFFFFC107);
  static const Color background = Color(0xFFF5F5F5);
  static const Color darkBackground = Color(0xFF121212);
  static const Color text = Colors.black87;
  static const Color lightText = Colors.white70;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.secondary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.text),
      bodyMedium: GoogleFonts.poppins(color: AppColors.text),
      headlineMedium: GoogleFonts.poppins(
        color: AppColors.text,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.lightText),
      bodyMedium: GoogleFonts.poppins(color: AppColors.lightText),
      headlineMedium: GoogleFonts.poppins(
        color: AppColors.lightText,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(secondary: AppColors.accent),
  );
}
