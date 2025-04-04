// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Defines the color palette for the application themes.
/// Inspired by Material Design 3 principles with Green as primary.
class AppColors {
  // --- Material Design 3 Inspired Palette ---

  // --- Light Theme Colors ---
  static const Color lightPrimary = Color(
    0xFF388E3C,
  ); // Green 600 - Main action color
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(
    0xFFC8E6C9,
  ); // Green 100 - Lighter background for primary elements
  static const Color lightOnPrimaryContainer = Color(
    0xFF0A3918,
  ); // Dark Green - Text/icons on primary container

  static const Color lightSecondary = Color(
    0xFF1976D2,
  ); // Blue 700 - Secondary actions/highlights
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(
    0xFFBBDEFB,
  ); // Blue 100 - Lighter background for secondary elements
  static const Color lightOnSecondaryContainer = Color(
    0xFF002A6F,
  ); // Dark Blue - Text/icons on secondary container

  static const Color lightTertiary = Color(
    0xFFFFA000,
  ); // Amber 700 - Tertiary accents
  static const Color lightOnTertiary = Color(0xFF000000);
  static const Color lightTertiaryContainer = Color(
    0xFFFFECB3,
  ); // Amber 100 - Lighter background for tertiary elements
  static const Color lightOnTertiaryContainer = Color(
    0xFF4C3B00,
  ); // Dark Amber - Text/icons on tertiary container

  static const Color lightBackground = Color(
    0xFFFAFDF6,
  ); // Slightly off-white with a hint of green
  static const Color lightOnBackground = Color(
    0xFF1A1C19,
  ); // Near-black for text on background
  static const Color lightSurface = Color(
    0xFFFAFDF6,
  ); // Can be same as background or slightly different (e.g., white)
  static const Color lightOnSurface = Color(
    0xFF1A1C19,
  ); // Near-black for text on surface

  static const Color lightSurfaceVariant = Color(
    0xFFE0E3DD,
  ); // Subtle gray/greenish background variant
  static const Color lightOnSurfaceVariant = Color(
    0xFF434840,
  ); // Text/icons on surface variant
  static const Color lightOutline = Color(0xFF747970); // Borders, dividers

  static const Color lightError = Color(0xFFBA1A1A); // M3 Error Red
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(
    0xFFFFDAD6,
  ); // Background for error messages/elements
  static const Color lightOnErrorContainer = Color(
    0xFF410002,
  ); // Text/icons on error container

  // --- Dark Theme Colors ---
  static const Color darkPrimary = Color(
    0xFF81C784,
  ); // Green 300 - Brighter Green for dark mode
  static const Color darkOnPrimary = Color(0xFF003A1A); // Dark Green
  static const Color darkPrimaryContainer = Color(
    0xFF2E7D32,
  ); // Green 700 - Background for primary elements
  static const Color darkOnPrimaryContainer = Color(
    0xFFC8E6C9,
  ); // Light Green - Text/icons on primary container

  static const Color darkSecondary = Color(
    0xFF82B1FF,
  ); // Blue A100 - Brighter Blue
  static const Color darkOnSecondary = Color(0xFF002F6C); // Dark Blue
  static const Color darkSecondaryContainer = Color(
    0xFF1565C0,
  ); // Blue 800 - Background for secondary elements
  static const Color darkOnSecondaryContainer = Color(
    0xFFBBDEFB,
  ); // Light Blue - Text/icons on secondary container

  static const Color darkTertiary = Color(
    0xFFFFD54F,
  ); // Amber 300 - Brighter Amber
  static const Color darkOnTertiary = Color(0xFF4C3B00); // Dark Amber
  static const Color darkTertiaryContainer = Color(
    0xFFFFB300,
  ); // Amber 800 - Background for tertiary elements
  static const Color darkOnTertiaryContainer = Color(
    0xFF4C3B00,
  ); // Dark Amber (Can adjust if needed contrast)

  static const Color darkBackground = Color(
    0xFF1A1C19,
  ); // Very dark (near black) green tint
  static const Color darkOnBackground = Color(
    0xFFE2E3DD,
  ); // Light Gray for text on background
  static const Color darkSurface = Color(
    0xFF1A1C19,
  ); // Can be same as background or slightly lighter M3 gray like #252823
  static const Color darkOnSurface = Color(
    0xFFE2E3DD,
  ); // Light Gray for text on surface

  static const Color darkSurfaceVariant = Color(
    0xFF434840,
  ); // Darker gray/greenish background variant
  static const Color darkOnSurfaceVariant = Color(
    0xFFC4C8BE,
  ); // Text/icons on dark surface variant
  static const Color darkOutline = Color(
    0xFF8D9289,
  ); // Borders, dividers in dark mode

  static const Color darkError = Color(
    0xFFFFB4AB,
  ); // Lighter Error Red for dark mode
  static const Color darkOnError = Color(0xFF690005); // Dark Red
  static const Color darkErrorContainer = Color(
    0xFF93000A,
  ); // Background for error messages/elements
  static const Color darkOnErrorContainer = Color(
    0xFFFFDAD6,
  ); // Light Red - Text/icons on error container

  // --- Semantic Colors (Consistent naming with previous version) ---
  // Using primary/tertiary colors for consistency with M3 roles

  // Success (Using Primary Tones)
  static const Color successLight = lightPrimary; // Green 600
  static const Color successDark = darkPrimary; // Green 300
  static const Color onSuccessLight = lightOnPrimary;
  static const Color onSuccessDark = darkOnPrimary;
  static const Color successContainerLight = lightPrimaryContainer;
  static const Color successContainerDark = darkPrimaryContainer;
  static const Color onSuccessContainerLight = lightOnPrimaryContainer;
  static const Color onSuccessContainerDark = darkOnPrimaryContainer;

  // Warning (Using Tertiary Tones - Amber)
  static const Color warningLight = lightTertiary; // Amber 700
  static const Color warningDark = darkTertiary; // Amber 300
  static const Color onWarningLight = lightOnTertiary;
  static const Color onWarningDark = darkOnTertiary;
  static const Color warningContainerLight = lightTertiaryContainer;
  static const Color warningContainerDark = darkTertiaryContainer;
  static const Color onWarningContainerLight = lightOnTertiaryContainer;
  static const Color onWarningContainerDark = darkOnTertiaryContainer;

  // Info (Using Secondary Tones - Blue)
  static const Color infoLight = lightSecondary; // Blue 700
  static const Color infoDark = darkSecondary; // Blue A100
  static const Color onInfoLight = lightOnSecondary;
  static const Color onInfoDark = darkOnSecondary;
  static const Color infoContainerLight = lightSecondaryContainer;
  static const Color infoContainerDark = darkSecondaryContainer;
  static const Color onInfoContainerLight = lightOnSecondaryContainer;
  static const Color onInfoContainerDark = darkOnSecondaryContainer;

  // --- Neutral Grays ---
  static const Color grayLight = Color(0xFFF1F3F4); // Light neutral gray
  static const Color grayMedium = Color(0xFFADB5BD); // Medium neutral gray
  static const Color grayDark = Color(0xFF495057); // Dark neutral gray
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Deprecated/Legacy (Can be removed if not used, kept for compatibility check)
  // static const Color lightPrimaryVariant = Color(0xFF1B5E20); // Replaced by Containers
  // static const Color lightSecondaryVariant = Color(0xFF0D47A1); // Replaced by Containers
  // static const Color darkPrimaryVariant = Color(0xFF4CAF50); // Replaced by Containers
  // static const Color darkSecondaryVariant = Color(0xFF64B5F6); // Replaced by Containers
}

// Helper extension (Keep if used, otherwise remove and use .withOpacity directly)
extension ColorAlpha on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withValues(alpha: alpha);
    }
    return this;
  }
}
