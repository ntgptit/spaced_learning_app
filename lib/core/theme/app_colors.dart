import 'package:flutter/material.dart';

/// Defines a comprehensive color palette for the application,
/// with smoky grey as the primary color and traditional semantic colors.
class AppColors {
  // --- Core Palette (Smoky Grey Theme) ---

  // --- Light Theme Colors ---
  static const Color lightPrimary = Color(0xFF5D5D5D); // Smoky Grey
  static const Color lightPrimaryVariant = Color(0xFF7D7D7D); // Lighter Grey
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFE0E0E0); // Light Grey
  static const Color lightOnPrimaryContainer = Color(0xFF2D2D2D); // Dark Grey

  static const Color lightSecondary = Color(0xFF757575); // Material Grey 600
  static const Color lightSecondaryVariant = Color(
    0xFF9E9E9E,
  ); // Material Grey 500
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(
    0xFFF5F5F5,
  ); // Light Grey background
  static const Color lightOnSecondaryContainer = Color(0xFF424242); // Dark Grey

  static const Color lightTertiary = Color(0xFF607D8B); // Blue Grey 500
  static const Color lightTertiaryVariant = Color(0xFF78909C); // Blue Grey 400
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFECEFF1); // Blue Grey 50
  static const Color lightOnTertiaryContainer = Color(
    0xFF263238,
  ); // Blue Grey 900

  static const Color lightBackground = Color(0xFFF8F9FA); // Very light grey
  static const Color lightOnBackground = Color(0xFF212121); // Almost black
  static const Color lightSurface = Color(0xFFFFFFFF); // White
  static const Color lightOnSurface = Color(0xFF212121); // Almost black

  static const Color lightSurfaceVariant = Color(0xFFEEEEEE); // Light grey
  static const Color lightOnSurfaceVariant = Color(0xFF616161); // Medium grey
  static const Color lightOutline = Color(0xFFBDBDBD); // Light grey
  static const Color lightDivider = Color(0xFFE0E0E0); // Very light grey

  // --- Dark Theme Colors ---
  static const Color darkPrimary = Color(0xFF9E9E9E); // Material Grey 500
  static const Color darkPrimaryVariant = Color(
    0xFFBDBDBD,
  ); // Material Grey 400
  static const Color darkOnPrimary = Color(0xFF212121); // Almost black
  static const Color darkPrimaryContainer = Color(
    0xFF424242,
  ); // Material Grey 800
  static const Color darkOnPrimaryContainer = Color(0xFFEEEEEE); // Light grey

  static const Color darkSecondary = Color(0xFFB0BEC5); // Blue Grey 200
  static const Color darkSecondaryVariant = Color(0xFF78909C); // Blue Grey 400
  static const Color darkOnSecondary = Color(0xFF37474F); // Blue Grey 800
  static const Color darkSecondaryContainer = Color(
    0xFF455A64,
  ); // Blue Grey 700
  static const Color darkOnSecondaryContainer = Color(
    0xFFCFD8DC,
  ); // Blue Grey 100

  static const Color darkTertiary = Color(0xFF90A4AE); // Blue Grey 300
  static const Color darkTertiaryVariant = Color(0xFF78909C); // Blue Grey 400
  static const Color darkOnTertiary = Color(0xFF263238); // Blue Grey 900
  static const Color darkTertiaryContainer = Color(0xFF546E7A); // Blue Grey 600
  static const Color darkOnTertiaryContainer = Color(
    0xFFECEFF1,
  ); // Blue Grey 50

  static const Color darkBackground = Color(0xFF303030); // Dark grey
  static const Color darkOnBackground = Color(0xFFEEEEEE); // Light grey
  static const Color darkSurface = Color(0xFF424242); // Material Grey 800
  static const Color darkOnSurface = Color(0xFFEEEEEE); // Light grey

  static const Color darkSurfaceVariant = Color(0xFF616161); // Medium grey
  static const Color darkOnSurfaceVariant = Color(
    0xFFE0E0E0,
  ); // Very light grey
  static const Color darkOutline = Color(0xFF757575); // Medium dark grey
  static const Color darkDivider = Color(0xFF616161); // Medium grey

  // --- Traditional Semantic Colors ---

  // Error
  static const Color lightError = Color(0xFFF44336); // Material Red 500
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFEBEE); // Red 50
  static const Color lightOnErrorContainer = Color(0xFFB71C1C); // Red 900

  static const Color darkError = Color(0xFFEF5350); // Material Red 400
  static const Color darkOnError = Color(0xFF000000);
  static const Color darkErrorContainer = Color(0xFFB71C1C); // Red 900
  static const Color darkOnErrorContainer = Color(0xFFFFCDD2); // Red 100

  // Success (Wood - Green to fuel Fire)
  static const Color successLight = Color(0xFF4CAF50); // Material Green 500
  static const Color successLightVariant = Color(0xFF66BB6A); // Green 400
  static const Color successDark = Color(0xFF81C784); // Green 300
  static const Color successDarkVariant = Color(0xFFA5D6A7); // Green 200
  static const Color onSuccessLight = Color(0xFFFFFFFF);
  static const Color onSuccessDark = Color(0xFF1B5E20); // Green 900
  static const Color successContainerLight = Color(0xFFE8F5E9); // Green 50
  static const Color successContainerDark = Color(0xFF2E7D32); // Green 800
  static const Color onSuccessContainerLight = Color(0xFF1B5E20); // Green 900
  static const Color onSuccessContainerDark = Color(0xFFC8E6C9); // Green 100

  // Warning (Amber/Orange)
  static const Color warningLight = Color(0xFFFFC107); // Material Amber 500
  static const Color warningLightVariant = Color(0xFFFFCA28); // Amber 400
  static const Color warningDark = Color(0xFFFFD54F); // Amber 300
  static const Color warningDarkVariant = Color(0xFFFFE082); // Amber 200
  static const Color onWarningLight = Color(0xFF000000);
  static const Color onWarningDark = Color(0xFF000000);
  static const Color warningContainerLight = Color(0xFFFFF8E1); // Amber 50
  static const Color warningContainerDark = Color(0xFFF57F17); // Amber 900
  static const Color onWarningContainerLight = Color(0xFFFF6F00); // Amber 900
  static const Color onWarningContainerDark = Color(0xFFFFECB3); // Amber 100

  // Info (Blue)
  static const Color infoLight = Color(0xFF2196F3); // Material Blue 500
  static const Color infoLightVariant = Color(0xFF42A5F5); // Blue 400
  static const Color infoDark = Color(0xFF64B5F6); // Blue 300
  static const Color infoDarkVariant = Color(0xFF90CAF9); // Blue 200
  static const Color onInfoLight = Color(0xFFFFFFFF);
  static const Color onInfoDark = Color(0xFF0D47A1); // Blue 900
  static const Color infoContainerLight = Color(0xFFE3F2FD); // Blue 50
  static const Color infoContainerDark = Color(0xFF1565C0); // Blue 800
  static const Color onInfoContainerLight = Color(0xFF0D47A1); // Blue 900
  static const Color onInfoContainerDark = Color(0xFFBBDEFB); // Blue 100

  // --- Additional UI Colors ---

  // Accent Colors
  static const Color accentGrey = Color(0xFF9E9E9E); // Grey 500
  static const Color accentBlue = Color(0xFF2196F3); // Blue 500
  static const Color accentGreen = Color(0xFF4CAF50); // Green 500
  static const Color accentRed = Color(0xFFF44336); // Red 500
  static const Color accentAmber = Color(0xFFFFC107); // Amber 500

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121); // Grey 900
  static const Color textPrimaryDark = Color(0xFFF5F5F5); // Grey 100
  static const Color textSecondaryLight = Color(0xFF757575); // Grey 600
  static const Color textSecondaryDark = Color(0xFFBDBDBD); // Grey 400
  static const Color textDisabledLight = Color(0xFFBDBDBD); // Grey 400
  static const Color textDisabledDark = Color(0xFF757575); // Grey 600

  // Icon Colors
  static const Color iconPrimaryLight = Color(0xFF616161); // Grey 700
  static const Color iconPrimaryDark = Color(0xFFE0E0E0); // Grey 300
  static const Color iconSecondaryLight = Color(0xFF9E9E9E); // Grey 500
  static const Color iconSecondaryDark = Color(0xFFBDBDBD); // Grey 400

  // Gradients
  static const LinearGradient gradientPrimary = LinearGradient(
    colors: [Color(0xFF757575), Color(0xFF9E9E9E)], // Grey 600 to Grey 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradientSecondary = LinearGradient(
    colors: [
      Color(0xFF607D8B),
      Color(0xFF90A4AE),
    ], // Blue Grey 500 to Blue Grey 300
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradientTertiary = LinearGradient(
    colors: [Color(0xFF9E9E9E), Color(0xFF607D8B)], // Grey 500 to Blue Grey 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Neutral Colors ---
  static const Color neutralLight = Color(0xFFF5F5F5); // Grey 100
  static const Color neutralMedium = Color(0xFF9E9E9E); // Grey 500
  static const Color neutralDark = Color(0xFF616161); // Grey 700
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF212121); // Grey 900

  // Surface container elevations
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // White
  static const Color surfaceContainerLow = Color(0xFFFAFAFA); // Grey 50
  static const Color surfaceContainer = Color(0xFFF5F5F5); // Grey 100
  static const Color surfaceContainerHigh = Color(0xFFEEEEEE); // Grey 200
  static const Color surfaceContainerHighest = Color(0xFFE0E0E0); // Grey 300

  // Dark mode surface container elevations
  static const Color darkSurfaceContainerLowest = Color(0xFF424242); // Grey 800
  static const Color darkSurfaceContainerLow = Color(
    0xFF484848,
  ); // Slightly lighter
  static const Color darkSurfaceContainer = Color(
    0xFF505050,
  ); // Base dark container
  static const Color darkSurfaceContainerHigh = Color(
    0xFF5A5A5A,
  ); // Slightly lighter
  static const Color darkSurfaceContainerHighest = Color(
    0xFF656565,
  ); // For cards/panels

  // Utility colors
  static const Color surfaceDim = Color(0xFFE0E0E0); // Light mode dim surface
  static const Color darkSurfaceDim = Color(
    0xFF353535,
  ); // Dark mode dim surface
}

extension ColorAlpha on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withOpacity(alpha);
    }
    return this;
  }
}
