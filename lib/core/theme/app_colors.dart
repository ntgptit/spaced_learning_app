// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF2E7D32);
  static const Color lightPrimaryVariant = Color(0xFF1B5E20);
  static const Color lightSecondary = Color(0xFF1565C0);
  static const Color lightSecondaryVariant = Color(0xFF0D47A1);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Colors.white;
  static const Color lightError = Color(0xFFB00020);
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.white;
  static const Color lightOnBackground = Color(0xFF121212);
  static const Color lightOnSurface = Color(0xFF121212);
  static const Color lightOnError = Colors.white;

  // Dark Theme Colors - Improved contrast
  static const Color darkPrimary = Color(
    0xFF81C784,
  ); // Brighter green for better visibility
  static const Color darkPrimaryVariant = Color(0xFF4CAF50); // Mid-tone green
  static const Color darkSecondary = Color(0xFF90CAF9); // Brighter blue
  static const Color darkSecondaryVariant = Color(0xFF64B5F6); // Mid-tone blue
  static const Color darkBackground = Color(0xFF121212); // Near black
  static const Color darkSurface = Color(0xFF1E1E1E); // Dark grey
  static const Color darkError = Color(
    0xFFEF5350,
  ); // Brighter red for better visibility
  static const Color darkOnPrimary = Color(0xFF000000); // Black on light colors
  static const Color darkOnSecondary = Color(
    0xFF000000,
  ); // Black on light colors
  static const Color darkOnBackground = Color(
    0xFFE0E0E0,
  ); // Light grey (not pure white for reduced eye strain)
  static const Color darkOnSurface = Color(0xFFE0E0E0); // Light grey
  static const Color darkOnError = Color(0xFF000000); // Black on error

  // Accent colors with better contrast
  static const Color successLight = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF81C784);
  static const Color warningLight = Color(0xFFFFC107);
  static const Color warningDark = Color(0xFFFFD54F);
  static const Color infoLight = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF64B5F6);

  // Gray scale
  static const Color grayLight = Color(0xFFEEEEEE);
  static const Color grayMedium = Color(0xFF9E9E9E);
  static const Color grayDark = Color(0xFF616161);

  // Additional colors for UI enhancement
  static const Color accentPurpleLight = Color(0xFF9C27B0);
  static const Color accentPurpleDark = Color(0xFFCE93D8);
  static const Color accentAmberLight = Color(0xFFFFC107);
  static const Color accentAmberDark = Color(0xFFFFD54F);
}
