// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Defines a comprehensive color palette for the application, optimized for Fire-element individuals.
/// Dominant colors: Red, Orange, Pink, Purple, Green (Wood), and supportive Earth tones (Beige, Brown).
/// Includes variations for UI components, gradients, and semantic states.
class AppColors {
  // --- Core Palette (Fire Element Optimized) ---

  // --- Light Theme Colors ---
  static const Color lightPrimary = Color(
    0xFFE53935,
  ); // Red 600 - Primary Fire color
  static const Color lightPrimaryVariant = Color(
    0xFFD81B60,
  ); // Pink 600 - Fire variant
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(
    0xFFFF8A80,
  ); // Coral Red 400 - Softer shade
  static const Color lightOnPrimaryContainer = Color(0xFF4F0000); // Dark red

  static const Color lightSecondary = Color(
    0xFFE65100,
  ); // Deep Orange 900 - Supportive Fire
  static const Color lightSecondaryVariant = Color(
    0xFFFF7043,
  ); // Orange 400 - Lighter variant
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(
    0xFFFFE0B2,
  ); // Orange 100 - Light background
  static const Color lightOnSecondaryContainer = Color(
    0xFF572800,
  ); // Dark orange

  static const Color lightTertiary = Color(
    0xFF7B1FA2,
  ); // Purple 700 - Wood supports Fire
  static const Color lightTertiaryVariant = Color(
    0xFFAB47BC,
  ); // Purple 400 - Lighter Wood
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(
    0xFFE1BEE7,
  ); // Purple 100 - Light background
  static const Color lightOnTertiaryContainer = Color(
    0xFF3E0055,
  ); // Dark purple

  static const Color lightBackground = Color(
    0xFFF8EDEB,
  ); // Warm beige - Earth support
  static const Color lightOnBackground = Color(0xFF3E2723); // Warm dark brown
  static const Color lightSurface = Color(0xFFF8EDEB); // Warm beige
  static const Color lightOnSurface = Color(0xFF3E2723); // Warm dark brown

  static const Color lightSurfaceVariant = Color(
    0xFFEBDFD3,
  ); // Darker beige - Earth
  static const Color lightOnSurfaceVariant = Color(0xFF52443C); // Earthy brown
  static const Color lightOutline = Color(
    0xFF7D6E64,
  ); // Light earthy brown - Earth
  static const Color lightDivider = Color(
    0xFFB0A197,
  ); // Medium earthy brown - Subtle divider

  static const Color lightError = Color(0xFFD32F2F); // Red 700 - Error (Fire)
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFEBEE); // Light red
  static const Color lightOnErrorContainer = Color(0xFF450A0A); // Dark red

  // --- Dark Theme Colors ---
  static const Color darkPrimary = Color(
    0xFFFF6E6E,
  ); // Bright red - Fire in dark mode
  static const Color darkPrimaryVariant = Color(
    0xFFF06292,
  ); // Pink 300 - Fire variant
  static const Color darkOnPrimary = Color(0xFF4F0000); // Dark red
  static const Color darkPrimaryContainer = Color(
    0xFFB71C1C,
  ); // Red 900 - Darker
  static const Color darkOnPrimaryContainer = Color(
    0xFFFFDADA,
  ); // Very light red

  static const Color darkSecondary = Color(
    0xFFFFB74D,
  ); // Orange 300 - Bright Fire
  static const Color darkSecondaryVariant = Color(
    0xFFFF8A65,
  ); // Orange 400 - Variant
  static const Color darkOnSecondary = Color(0xFF572800); // Dark orange
  static const Color darkSecondaryContainer = Color(
    0xFFBF360C,
  ); // Deep Orange 900
  static const Color darkOnSecondaryContainer = Color(
    0xFFFFDCC3,
  ); // Very light orange

  static const Color darkTertiary = Color(
    0xFFCE93D8,
  ); // Purple 200 - Bright Wood
  static const Color darkTertiaryVariant = Color(
    0xFFBA68C8,
  ); // Purple 300 - Variant
  static const Color darkOnTertiary = Color(0xFF3E0055); // Dark purple
  static const Color darkTertiaryContainer = Color(0xFF6A1B9A); // Purple 900
  static const Color darkOnTertiaryContainer = Color(
    0xFFF3D9FF,
  ); // Very light purple

  static const Color darkBackground = Color(
    0xFF3C2F2F,
  ); // Warm reddish-brown - Earth
  static const Color darkOnBackground = Color(0xFFEDE0D9); // Light beige
  static const Color darkSurface = Color(0xFF3C2F2F); // Warm reddish-brown
  static const Color darkOnSurface = Color(0xFFEDE0D9); // Light beige

  static const Color darkSurfaceVariant = Color(
    0xFF52443C,
  ); // Dark earthy brown
  static const Color darkOnSurfaceVariant = Color(
    0xFFE5D8CE,
  ); // Very light beige
  static const Color darkOutline = Color(0xFF9E8E82); // Light brown
  static const Color darkDivider = Color(
    0xFF6D5A52,
  ); // Darker earthy brown - Subtle divider

  static const Color darkError = Color(
    0xFFD32F2F,
  ); // Red 700 - Intense Fire error
  static const Color darkOnError = Color(0xFF690505); // Very dark red
  static const Color darkErrorContainer = Color(
    0xFFC62828,
  ); // Red 800 - Dark red
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6); // Very light red

  // --- Semantic Colors ---

  // Success (Wood - Green to fuel Fire)
  static const Color successLight = Color(0xFF388E3C); // Green 700 - Wood
  static const Color successLightVariant = Color(
    0xFF4CAF50,
  ); // Green 500 - Lighter Wood
  static const Color successDark = Color(
    0xFF66BB6A,
  ); // Green 400 - Bright green
  static const Color successDarkVariant = Color(
    0xFF81C784,
  ); // Green 300 - Variant
  static const Color onSuccessLight = Color(0xFFFFFFFF);
  static const Color onSuccessDark = Color(0xFF1B3E1D); // Dark green
  static const Color successContainerLight = Color(0xFFC8E6C9); // Green 100
  static const Color successContainerDark = Color(0xFF2E7D32); // Green 800
  static const Color onSuccessContainerLight = Color(0xFF1B3E1D);
  static const Color onSuccessContainerDark = Color(0xFFE8F5E9);

  // Warning (Fire - Orange)
  static const Color warningLight = Color(0xFFFF9800); // Orange 500
  static const Color warningLightVariant = Color(
    0xFFFFB300,
  ); // Amber 500 - Variant
  static const Color warningDark = Color(0xFFFFB74D); // Orange 300
  static const Color warningDarkVariant = Color(
    0xFFFFCC80,
  ); // Orange 200 - Variant
  static const Color onWarningLight = Color(0xFF3E2723); // Warm dark brown
  static const Color onWarningDark = Color(0xFF3D2200);
  static const Color warningContainerLight = Color(0xFFFFE0B2); // Orange 100
  static const Color warningContainerDark = Color(0xFFE65100); // Orange 900
  static const Color onWarningContainerLight = Color(0xFF3D2200);
  static const Color onWarningContainerDark = Color(0xFFFFF2E2);

  // Info (Wood - Purple)
  static const Color infoLight = Color(0xFF7B1FA2); // Purple 700
  static const Color infoLightVariant = Color(
    0xFF9C27B0,
  ); // Purple 500 - Variant
  static const Color infoDark = Color(0xFFCE93D8); // Purple 200
  static const Color infoDarkVariant = Color(
    0xFFE1BEE7,
  ); // Purple 100 - Lighter variant
  static const Color onInfoLight = Color(0xFFFFFFFF);
  static const Color onInfoDark = Color(0xFF3E0055);
  static const Color infoContainerLight = Color(0xFFE1BEE7); // Purple 100
  static const Color infoContainerDark = Color(0xFF6A1B9A); // Purple 900
  static const Color onInfoContainerLight = Color(0xFF3E0055);
  static const Color onInfoContainerDark = Color(0xFFF3D9FF);

  // --- Additional UI Colors ---

  // Accent Colors (Fire and Wood inspired)
  static const Color accentRed = Color(
    0xFFFF5252,
  ); // Red 400 - Vibrant Fire accent
  static const Color accentOrange = Color(
    0xFFFFA726,
  ); // Orange 600 - Warm Fire accent
  static const Color accentPink = Color(
    0xFFF06292,
  ); // Pink 400 - Soft Fire accent
  static const Color accentPurple = Color(
    0xFFBA68C8,
  ); // Purple 300 - Wood accent
  static const Color accentGreen = Color(0xFF66BB6A); // Green 400 - Wood accent

  // Text Colors
  static const Color textPrimaryLight = Color(
    0xFF3E2723,
  ); // Warm dark brown - High contrast
  static const Color textPrimaryDark = Color(
    0xFFEDE0D9,
  ); // Light beige - High contrast
  static const Color textSecondaryLight = Color(
    0xFF7D6E64,
  ); // Light earthy brown - Medium contrast
  static const Color textSecondaryDark = Color(
    0xFFB0A197,
  ); // Medium earthy brown - Medium contrast
  static const Color textDisabledLight = Color(
    0xFFB0A197,
  ); // Medium earthy brown - Low contrast
  static const Color textDisabledDark = Color(
    0xFF6D5A52,
  ); // Darker earthy brown - Low contrast

  // Icon Colors
  static const Color iconPrimaryLight = Color(0xFFE53935); // Red 600 - Fire
  static const Color iconPrimaryDark = Color(0xFFFF6E6E); // Bright red - Fire
  static const Color iconSecondaryLight = Color(
    0xFF7D6E64,
  ); // Light earthy brown
  static const Color iconSecondaryDark = Color(0xFF9E8E82); // Light brown

  // Gradients (Fire and Wood inspired)
  static const LinearGradient gradientPrimary = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFD81B60)], // Red to Pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradientSecondary = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFFF7043)], // Deep Orange to Orange
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradientTertiary = LinearGradient(
    colors: [
      Color(0xFF7B1FA2),
      Color(0xFF388E3C),
    ], // Purple to Green (Wood harmony)
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Neutral Colors ---
  static const Color neutralLight = Color(0xFFF8EDEB); // Warm beige
  static const Color neutralMedium = Color(0xFFB0A197); // Medium earthy brown
  static const Color neutralDark = Color(0xFF52443C); // Dark earthy brown
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF3E2723); // Warm dark brown

  // --- Extended Palette (Used in UI Widgets like LearningInsightsCard etc.) ---

  // Primary Blue Group (cool blue tone)
  static const Color primaryBlue = Color(0xFF2196F3); // Blue 500
  static const Color primaryBlueDark = Color(0xFF1976D2); // Blue 700
  static const Color primaryBlueLight = Color(0xFFBBDEFB); // Blue 100
  static const Color onPrimaryBlue = Color(0xFFFFFFFF); // White
  static const Color onPrimaryBlueDark = Color(
    0xFFE3F2FD,
  ); // Light BG for dark mode

  // Extended Error group
  static const Color errorDark = Color(0xFFB71C1C); // Red 900
  static const Color errorBright = Color(0xFFFF5252); // Red A200
  static const Color errorLight = Color(0xFFFFCDD2); // Red 100
  static const Color onErrorDark = Color(0xFFFFDADA);
  static const Color onErrorLight = Color(0xFF450A0A);

  // Surface container elevations
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // White
  static const Color surfaceContainerLow = Color(0xFFF7F4F3); // Very light warm
  static const Color surfaceContainer = Color(0xFFECE5E3); // Base container
  static const Color surfaceContainerHigh = Color(
    0xFFDED5D2,
  ); // Slightly darker
  static const Color surfaceContainerHighest = Color(
    0xFFEBE3E0,
  ); // For cards/panels

  // Chip and tag backgrounds
  static const Color chipBackground = Color(0xFFF1E6E6); // Neutral pinkish base
  static const Color chipSelectedBackground = Color(0xFFE1BEE7); // Light purple
  static const Color chipSuccessBackground = Color(0xFFC8E6C9); // Green 100
  static const Color chipErrorBackground = Color(0xFFFFEBEE); // Red 50
  static const Color chipWarningBackground = Color(0xFFFFF3E0); // Orange 50

  // Additional UI element helpers
  static const Color dividerLight = Color(0xFFEEE0DA); // Very soft beige
  static const Color tooltipBackground = Color(0xFF3E2723); // Dark brown
  static const Color scrollbarThumb = Color(0xFFBCAAA4); // Muted brown
  static const Color highlightOverlay = Color(0x33E53935); // Red overlay 20%
}

extension ColorAlpha on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withOpacity(alpha);
    }
    return this;
  }
}
