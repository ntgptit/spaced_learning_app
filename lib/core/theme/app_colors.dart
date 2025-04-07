import 'package:flutter/material.dart';

/// Defines a comprehensive color palette for the application,
/// featuring a vibrant Teal as the primary color alongside other bright hues
/// and traditional semantic colors.
class AppColors {
  // --- Core Palette (Vibrant Teal & Blue Theme) ---

  // --- Light Theme Colors ---
  static const Color lightPrimary = Color(0xFF009688); // Vibrant Teal 500
  static const Color lightPrimaryVariant = Color(0xFF26A69A); // Teal 400
  static const Color lightOnPrimary = Color(0xFFFFFFFF); // White
  static const Color lightPrimaryContainer = Color(
    0xFFB2DFDB,
  ); // Teal 100 (Brighter)
  static const Color lightOnPrimaryContainer = Color(
    0xFF004D40,
  ); // Teal 900 (Dark for contrast)

  static const Color lightSecondary = Color(0xFF2196F3); // Bright Blue 500
  static const Color lightSecondaryVariant = Color(0xFF42A5F5); // Blue 400
  static const Color lightOnSecondary = Color(0xFFFFFFFF); // White
  static const Color lightSecondaryContainer = Color(
    0xFFBBDEFB,
  ); // Blue 100 (Brighter)
  static const Color lightOnSecondaryContainer = Color(
    0xFF0D47A1,
  ); // Blue 900 (Dark for contrast)

  static const Color lightTertiary = Color(
    0xFFFFB300,
  ); // Amber 600 (Warm & Bright)
  static const Color lightTertiaryVariant = Color(0xFFFFC107); // Amber 500
  static const Color lightOnTertiary = Color(
    0xFF000000,
  ); // Black for contrast on yellow
  static const Color lightTertiaryContainer = Color(
    0xFFFFECB3,
  ); // Amber 100 (Brighter)
  static const Color lightOnTertiaryContainer = Color(
    0xFFBF360C,
  ); // Deep Orange 900 (Darker for contrast)

  static const Color lightBackground = Color(
    0xFFFEFEFE,
  ); // Almost White (Brighter)
  static const Color lightOnBackground = Color(
    0xFF1B1B1B,
  ); // Very Dark Grey (Good Contrast)
  static const Color lightSurface = Color(0xFFFFFFFF); // White
  static const Color lightOnSurface = Color(0xFF1B1B1B); // Very Dark Grey

  static const Color lightSurfaceVariant = Color(
    0xFFE0F2F1,
  ); // Very Light Teal Tint
  static const Color lightOnSurfaceVariant = Color(0xFF424242); // Medium Grey
  static const Color lightOutline = Color(
    0xFFB0BEC5,
  ); // Blue Grey 200 (Softer than dark grey)
  static const Color lightDivider = Color(0xFFE0E0E0); // Light Grey

  // --- Dark Theme Colors ---
  static const Color darkPrimary = Color(
    0xFF4DB6AC,
  ); // Teal 300 (Lighter for Dark Theme)
  static const Color darkPrimaryVariant = Color(0xFF80CBC4); // Teal 200
  static const Color darkOnPrimary = Color(0xFF003731); // Dark Teal (Contrast)
  static const Color darkPrimaryContainer = Color(
    0xFF004D40,
  ); // Teal 800/900 (Darker Base)
  static const Color darkOnPrimaryContainer = Color(
    0xFFB2DFDB,
  ); // Teal 100 (Light text/icon)

  static const Color darkSecondary = Color(
    0xFF64B5F6,
  ); // Blue 300 (Lighter for Dark Theme)
  static const Color darkSecondaryVariant = Color(0xFF90CAF9); // Blue 200
  static const Color darkOnSecondary = Color(
    0xFF003366,
  ); // Dark Blue (Contrast)
  static const Color darkSecondaryContainer = Color(
    0xFF0D47A1,
  ); // Blue 900 (Darker Base)
  static const Color darkOnSecondaryContainer = Color(
    0xFFBBDEFB,
  ); // Blue 100 (Light text/icon)

  static const Color darkTertiary = Color(
    0xFFFFD54F,
  ); // Amber 300 (Lighter for Dark Theme)
  static const Color darkTertiaryVariant = Color(0xFFFFE082); // Amber 200
  static const Color darkOnTertiary = Color(
    0xFF3E2723,
  ); // Dark Brown (Contrast on Yellow)
  static const Color darkTertiaryContainer = Color(
    0xFFBF360C,
  ); // Deep Orange 900 (Darker Base)
  static const Color darkOnTertiaryContainer = Color(
    0xFFFFECB3,
  ); // Amber 100 (Light text/icon)

  static const Color darkBackground = Color(
    0xFF121212,
  ); // Standard Dark Background
  static const Color darkOnBackground = Color(
    0xFFE2E2E6,
  ); // Light Grey (Good Contrast)
  static const Color darkSurface = Color(0xFF1E1E1E); // Slightly lighter dark
  static const Color darkOnSurface = Color(0xFFE2E2E6); // Light Grey

  static const Color darkSurfaceVariant = Color(
    0xFF004D40,
  ); // Dark Teal for subtle variant
  static const Color darkOnSurfaceVariant = Color(0xFFB0BEC5); // Blue Grey 200
  static const Color darkOutline = Color(0xFF78909C); // Blue Grey 400
  static const Color darkDivider = Color(0xFF546E7A); // Blue Grey 600

  // --- Traditional Semantic Colors (Adjusted Containers for Brightness) ---

  // Error
  static const Color lightError = Color(0xFFF44336); // Material Red 500
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(
    0xFFFFCDD2,
  ); // Red 100 (Brighter)
  static const Color lightOnErrorContainer = Color(0xFFB71C1C); // Red 900

  static const Color darkError = Color(
    0xFFEF9A9A,
  ); // Red 200 (Lighter for Dark)
  static const Color darkOnError = Color(0xFF690005); // Dark Red for contrast
  static const Color darkErrorContainer = Color(0xFFB71C1C); // Red 900
  static const Color darkOnErrorContainer = Color(0xFFFFCDD2); // Red 100

  // Success
  static const Color successLight = Color(0xFF4CAF50); // Material Green 500
  static const Color successLightVariant = Color(0xFF66BB6A); // Green 400
  static const Color successDark = Color(
    0xFFA5D6A7,
  ); // Green 200 (Lighter for Dark)
  static const Color successDarkVariant = Color(0xFFC8E6C9); // Green 100
  static const Color onSuccessLight = Color(0xFFFFFFFF);
  static const Color onSuccessDark = Color(
    0xFF003300,
  ); // Dark Green for contrast
  static const Color successContainerLight = Color(
    0xFFC8E6C9,
  ); // Green 100 (Brighter)
  static const Color successContainerDark = Color(0xFF1B5E20); // Green 900
  static const Color onSuccessContainerLight = Color(0xFF1B5E20); // Green 900
  static const Color onSuccessContainerDark = Color(0xFFC8E6C9); // Green 100

  // Warning
  static const Color warningLight = Color(0xFFFFC107); // Material Amber 500
  static const Color warningLightVariant = Color(0xFFFFCA28); // Amber 400
  static const Color warningDark = Color(
    0xFFFFE082,
  ); // Amber 200 (Lighter for Dark)
  static const Color warningDarkVariant = Color(0xFFFFECB3); // Amber 100
  static const Color onWarningLight = Color(0xFF000000);
  static const Color onWarningDark = Color(
    0xFF3E2723,
  ); // Dark Brown for contrast
  static const Color warningContainerLight = Color(
    0xFFFFECB3,
  ); // Amber 100 (Brighter)
  static const Color warningContainerDark = Color(
    0xFFBF360C,
  ); // Deep Orange 900
  static const Color onWarningContainerLight = Color(
    0xFFBF360C,
  ); // Deep Orange 900
  static const Color onWarningContainerDark = Color(0xFFFFECB3); // Amber 100

  // Info
  static const Color infoLight = Color(0xFF2196F3); // Material Blue 500
  static const Color infoLightVariant = Color(0xFF42A5F5); // Blue 400
  static const Color infoDark = Color(
    0xFF90CAF9,
  ); // Blue 200 (Lighter for Dark)
  static const Color infoDarkVariant = Color(0xFFBBDEFB); // Blue 100
  static const Color onInfoLight = Color(0xFFFFFFFF);
  static const Color onInfoDark = Color(0xFF003366); // Dark Blue for contrast
  static const Color infoContainerLight = Color(
    0xFFBBDEFB,
  ); // Blue 100 (Brighter)
  static const Color infoContainerDark = Color(0xFF0D47A1); // Blue 900
  static const Color onInfoContainerLight = Color(0xFF0D47A1); // Blue 900
  static const Color onInfoContainerDark = Color(0xFFBBDEFB); // Blue 100

  // --- Additional UI Colors (Aligned with New Theme) ---

  // Accent Colors now reflect primary, secondary, tertiary, etc.
  static const Color accentPrimary = lightPrimary;
  static const Color accentSecondary = lightSecondary;
  static const Color accentTertiary = lightTertiary;
  static const Color accentError = lightError;
  static const Color accentSuccess = successLight;
  static const Color accentWarning = warningLight;
  static const Color accentInfo = infoLight;

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1B1B1B); // Dark for light bg
  static const Color textPrimaryDark = Color(0xFFE2E2E6); // Light for dark bg
  static const Color textSecondaryLight = Color(0xFF5F5F5F); // Medium Grey
  static const Color textSecondaryDark = Color(0xFFB0BEC5); // Light Blue Grey
  static const Color textDisabledLight = Color(0xFFBDBDBD); // Light Grey
  static const Color textDisabledDark = Color(0xFF757575); // Medium Grey

  // Icon Colors
  static const Color iconPrimaryLight = Color(0xFF37474F); // Blue Grey 800
  static const Color iconPrimaryDark = Color(0xFFCFD8DC); // Blue Grey 100
  static const Color iconSecondaryLight = Color(0xFF607D8B); // Blue Grey 500
  static const Color iconSecondaryDark = Color(0xFFB0BEC5); // Blue Grey 200

  // Gradients (Updated with new core colors)
  static const LinearGradient gradientPrimary = LinearGradient(
    colors: [lightPrimary, lightPrimaryVariant], // Teal gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradientSecondary = LinearGradient(
    colors: [lightSecondary, lightSecondaryVariant], // Blue gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradientTertiary = LinearGradient(
    colors: [lightTertiary, lightTertiaryVariant], // Amber gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Neutral Colors ---
  static const Color neutralLight = Color(0xFFF5F5F5); // Grey 100
  static const Color neutralMedium = Color(0xFF9E9E9E); // Grey 500
  static const Color neutralDark = Color(0xFF616161); // Grey 700
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000); // Pure Black
  static const Color almostBlack = Color(0xFF1B1B1B); // Used for text

  // Surface container elevations (Light Theme - Brighter Tints)
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // White
  static const Color surfaceContainerLow = Color(
    0xFFF5FDFA,
  ); // Very light Teal tint
  static const Color surfaceContainer = Color(
    0xFFE0F2F1,
  ); // Light Teal tint (match primary container)
  static const Color surfaceContainerHigh = Color(
    0xFFC1E0DD,
  ); // Slightly darker Teal tint
  static const Color surfaceContainerHighest = Color(
    0xFFA8D5D0,
  ); // More saturated Teal tint

  // Dark mode surface container elevations (Using dark primary tints)
  static const Color darkSurfaceContainerLowest = Color(
    0xFF1F2121,
  ); // Slightly off black
  static const Color darkSurfaceContainerLow = Color(
    0xFF003731,
  ); // Dark Teal base
  static const Color darkSurfaceContainer = Color(
    0xFF004D40,
  ); // Darker Teal base
  static const Color darkSurfaceContainerHigh = Color(
    0xFF00695C,
  ); // Slightly Lighter Dark Teal
  static const Color darkSurfaceContainerHighest = Color(
    0xFF00796B,
  ); // Teal 700

  // Utility colors
  static const Color surfaceDim = Color(0xFFDCDCDC); // Lighter Dim
  static const Color darkSurfaceDim = Color(0xFF101010); // Darker Dim
}

// Extension remains the same
extension ColorAlpha on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withOpacity(alpha.clamp(0.0, 1.0)); // Ensure alpha is valid
    }
    return this;
  }
}
