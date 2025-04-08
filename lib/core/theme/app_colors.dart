// import 'package:flutter/material.dart';

// /// Defines a comprehensive and modern color palette for the application,
// /// featuring a sophisticated Steel Blue/Indigo as the primary color,
// /// complemented by muted Teal and soft Coral accents.
// /// Adheres to Material Design 3 principles for light and dark themes.
// class AppColors {
//   // --- Core Palette (Sophisticated Blue & Muted Accents) ---

//   // --- Light Theme Colors ---
//   static const Color lightPrimary = Color(0xFF4A69BD); // Steel Blue / Indigo
//   static const Color lightOnPrimary = Color(0xFFFFFFFF); // White
//   static const Color lightPrimaryContainer = Color(
//     0xFFD8E2FF,
//   ); // Light Blue Tint
//   static const Color lightOnPrimaryContainer = Color(
//     0xFF001A42,
//   ); // Very Dark Blue

//   static const Color lightSecondary = Color(0xFF4DB6AC); // Muted Teal
//   static const Color lightOnSecondary = Color(0xFFFFFFFF); // White
//   static const Color lightSecondaryContainer = Color(
//     0xFFB0F1E5,
//   ); // Very Light Teal
//   static const Color lightOnSecondaryContainer = Color(0xFF00382F); // Dark Teal

//   static const Color lightTertiary = Color(0xFFF48A6F); // Soft Coral
//   static const Color lightOnTertiary = Color(0xFFFFFFFF); // White
//   static const Color lightTertiaryContainer = Color(0xFFFFDAD4); // Pale Coral
//   static const Color lightOnTertiaryContainer = Color(
//     0xFF4A1A11,
//   ); // Dark Brownish Red

//   static const Color lightBackground = Color(0xFFFAFDFE); // Almost White (Cool)
//   static const Color lightOnBackground = Color(
//     0xFF191C1E,
//   ); // Very Dark Blue/Gray
//   static const Color lightSurface = Color(0xFFFAFDFE); // Same as Background
//   static const Color lightOnSurface = Color(0xFF191C1E); // Very Dark Blue/Gray

//   static const Color lightSurfaceVariant = Color(
//     0xFFE1E2EC,
//   ); // Light Grayish Blue
//   static const Color lightOnSurfaceVariant = Color(0xFF44474F); // Medium Gray
//   static const Color lightOutline = Color(0xFF74777F); // Medium Gray
//   static const Color lightOutlineVariant = Color(0xFFC4C6CF); // Light Gray

//   // --- Dark Theme Colors ---
//   static const Color darkPrimary = Color(0xFFADC6FF); // Lighter Blue for Dark
//   static const Color darkOnPrimary = Color(0xFF002F65); // Dark Blue
//   static const Color darkPrimaryContainer = Color(
//     0xFF2A4F89,
//   ); // Darker Blue Base
//   static const Color darkOnPrimaryContainer = Color(
//     0xFFD8E2FF,
//   ); // Light Blue Tint

//   static const Color darkSecondary = Color(0xFF6EDDCF); // Lighter Teal for Dark
//   static const Color darkOnSecondary = Color(0xFF00382F); // Dark Teal
//   static const Color darkSecondaryContainer = Color(
//     0xFF245B50,
//   ); // Darker Teal Base
//   static const Color darkOnSecondaryContainer = Color(
//     0xFFB0F1E5,
//   ); // Very Light Teal

//   static const Color darkTertiary = Color(0xFFFFB5A1); // Lighter Coral for Dark
//   static const Color darkOnTertiary = Color(0xFF5F1700); // Dark Brownish Red
//   static const Color darkTertiaryContainer = Color(
//     0xFF7D3720,
//   ); // Darker Coral Base
//   static const Color darkOnTertiaryContainer = Color(0xFFFFDAD4); // Pale Coral

//   static const Color darkBackground = Color(0xFF191C1E); // Very Dark Blue/Gray
//   static const Color darkOnBackground = Color(0xFFE2E2E6); // Light Gray
//   static const Color darkSurface = Color(0xFF111416); // Slightly Darker Surface
//   static const Color darkOnSurface = Color(0xFFE2E2E6); // Light Gray

//   static const Color darkSurfaceVariant = Color(0xFF44474F); // Medium Gray
//   static const Color darkOnSurfaceVariant = Color(0xFFC4C6CF); // Light Gray
//   static const Color darkOutline = Color(0xFF8E9099); // Lighter Medium Gray
//   static const Color darkOutlineVariant = Color(0xFF44474F); // Medium Gray

//   // --- Semantic Colors (Material 3 Defaults - Adjusted for Consistency) ---

//   // Error
//   static const Color lightError = Color(0xFFB3261E); // M3 Error Red
//   static const Color lightOnError = Color(0xFFFFFFFF);
//   static const Color lightErrorContainer = Color(0xFFF9DEDC);
//   static const Color lightOnErrorContainer = Color(0xFF410E0B);

//   static const Color darkError = Color(0xFFF2B8B5);
//   static const Color darkOnError = Color(0xFF601410);
//   static const Color darkErrorContainer = Color(0xFF8C1D18);
//   static const Color darkOnErrorContainer = Color(0xFFF9DEDC);

//   // Success (Using standard Green)
//   static const Color successLight = Color(0xFF4CAF50); // Green 500
//   static const Color onSuccessLight = Color(0xFFFFFFFF);
//   static const Color successContainerLight = Color(0xFFC8E6C9); // Green 100
//   static const Color onSuccessContainerLight = Color(0xFF1B5E20); // Green 900

//   static const Color successDark = Color(0xFFA5D6A7); // Green 200
//   static const Color onSuccessDark = Color(0xFF003300);
//   static const Color successContainerDark = Color(0xFF1B5E20); // Green 900
//   static const Color onSuccessContainerDark = Color(0xFFC8E6C9); // Green 100

//   // Warning (Using standard Amber/Orange)
//   static const Color warningLight = Color(0xFFFFB300); // Amber 600
//   static const Color onWarningLight = Color(0xFF000000);
//   static const Color warningContainerLight = Color(0xFFFFECB3); // Amber 100
//   static const Color onWarningContainerLight = Color(
//     0xFFBF360C,
//   ); // Deep Orange 900

//   static const Color warningDark = Color(0xFFFFD54F); // Amber 300
//   static const Color onWarningDark = Color(0xFF3E2723); // Dark Brown
//   static const Color warningContainerDark = Color(
//     0xFFBF360C,
//   ); // Deep Orange 900
//   static const Color onWarningContainerDark = Color(0xFFFFECB3); // Amber 100

//   // Info (Using a slightly adjusted blue for consistency)
//   static const Color infoLight = Color(0xFF42A5F5); // Blue 400
//   static const Color onInfoLight = Color(0xFFFFFFFF);
//   static const Color infoContainerLight = Color(0xFFBBDEFB); // Blue 100
//   static const Color onInfoContainerLight = Color(0xFF0D47A1); // Blue 900

//   static const Color infoDark = Color(0xFF90CAF9); // Blue 200
//   static const Color onInfoDark = Color(0xFF003366);
//   static const Color infoContainerDark = Color(0xFF0D47A1); // Blue 900
//   static const Color onInfoContainerDark = Color(0xFFBBDEFB); // Blue 100

//   // --- Additional UI Colors (Aligned with New Theme) ---

//   // Text Colors
//   static const Color textPrimaryLight = Color(0xFF191C1E); // Match OnBackground
//   static const Color textPrimaryDark = Color(
//     0xFFE2E2E6,
//   ); // Match OnBackground Dark
//   static const Color textSecondaryLight = Color(
//     0xFF44474F,
//   ); // Match OnSurfaceVariant
//   static const Color textSecondaryDark = Color(
//     0xFFC4C6CF,
//   ); // Match OnSurfaceVariant Dark
//   static const Color textDisabledLight = Color(0xFFB0B3BC); // Lighter Gray
//   static const Color textDisabledDark = Color(0xFF71747B); // Darker Gray

//   // Icon Colors (Derived from OnSurface/OnSurfaceVariant)
//   static const Color iconPrimaryLight = Color(0xFF191C1E);
//   static const Color iconPrimaryDark = Color(0xFFE2E2E6);
//   static const Color iconSecondaryLight = Color(0xFF44474F);
//   static const Color iconSecondaryDark = Color(0xFFC4C6CF);

//   // Gradients (Using new core colors)
//   static LinearGradient gradientPrimary = const LinearGradient(
//     colors: [lightPrimary, Color(0xFF3A5FCD)], // Adjusted slightly darker end
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
//   static LinearGradient gradientSecondary = const LinearGradient(
//     colors: [lightSecondary, Color(0xFF26A69A)], // Teal 400 from original
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
//   static LinearGradient gradientTertiary = const LinearGradient(
//     colors: [lightTertiary, Color(0xFFE57373)], // A slightly redder coral
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   // --- Neutral Colors ---
//   static const Color white = Color(0xFFFFFFFF);
//   static const Color black = Color(0xFF000000);
//   static const Color neutralLight = Color(0xFFF1F0F4); // Light Gray
//   static const Color neutralMedium = Color(0xFF74777F); // Medium Gray (Outline)
//   static const Color neutralDark = Color(0xFF44474F); // Darker Gray

//   // Surface Tints/Containers (Derived from primary for elevation)
//   // Light Theme
//   static const Color surfaceDim = Color(0xFFDADADD); // Grayish Dim
//   static const Color surfaceBright = Color(0xFFFAFDFE); // Same as background
//   static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // Pure White
//   static const Color surfaceContainerLow = Color(0xFFF4F7F8); // Very Light tint
//   static const Color surfaceContainer = Color(0xFFEEF1F2); // Light tint
//   static const Color surfaceContainerHigh = Color(0xFFE8EBED); // Medium tint
//   static const Color surfaceContainerHighest = Color(0xFFE2E5E7); // High tint

//   // Dark Theme
//   static const Color darkSurfaceDim = Color(0xFF111416); // Dark Dim
//   static const Color darkSurfaceBright = Color(0xFF37393B); // Lighter Dark
//   static const Color darkSurfaceContainerLowest = Color(0xFF141719); // Darkest
//   static const Color darkSurfaceContainerLow = Color(0xFF1C1F21); // Dark + tint
//   static const Color darkSurfaceContainer = Color(
//     0xFF202325,
//   ); // Dark + more tint
//   static const Color darkSurfaceContainerHigh = Color(
//     0xFF2B2E30,
//   ); // Dark + high tint
//   static const Color darkSurfaceContainerHighest = Color(
//     0xFF36393B,
//   ); // Dark + highest tint
// }

// // Extension remains the same
// extension ColorAlpha on Color {
//   Color withValues({double? alpha}) {
//     if (alpha != null) {
//       return withOpacity(alpha.clamp(0.0, 1.0)); // Ensure alpha is valid
//     }
//     return this;
//   }
// }
