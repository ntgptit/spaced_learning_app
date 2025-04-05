// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Defines the color palette for the application themes.
/// Designed considering Fire element (Mệnh Hỏa) principles with diversity.
class AppColors {
  // --- Material Design 3 Inspired Palette - Adapted for Fire Element ---

  // --- Light Theme Colors (Fire: Red/Orange/Pink + Wood: Green) ---
  static const Color lightPrimary = Color(
    0xFFD32F2F,
  ); // Red 700 (Hỏa - Mạnh mẽ)
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFFFCDD2); // Light Red
  static const Color lightOnPrimaryContainer = Color(
    0xFF4E0002,
  ); // Dark Red for text on container

  static const Color lightSecondary = Color(
    0xFF388E3C,
  ); // Green 700 (Mộc - Tương sinh, đậm hơn)
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFC8E6C9); // Light Green
  static const Color lightOnSecondaryContainer = Color(
    0xFF0A3918,
  ); // Dark Green for text on container

  static const Color lightTertiary = Color(
    0xFFEC407A,
  ); // Pink 400 (Hỏa - Tươi tắn)
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFFCE4EC); // Light Pink
  static const Color lightOnTertiaryContainer = Color(
    0xFF5C002B,
  ); // Dark Pink for text on container

  // Accent màu Vàng (Bổ sung, có thể dùng cho highlight)
  static const Color lightAccentYellow = Color(0xFFFFC107); // Amber 500
  static const Color lightOnAccentYellow = Color(0xFF000000); // Black for text

  // Nền và Surface: Màu trắng ngà ấm, tách biệt nhẹ
  static const Color lightBackground = Color(
    0xFFFFF8F6,
  ); // Very light warm off-white (Nền chính)
  static const Color lightSurface = Color(
    0xFFFFFBF9,
  ); // Slightly lighter/brighter than background (Cho Card, Dialog)
  static const Color lightOnBackground = Color(0xFF201A18); // Near-black warm
  static const Color lightOnSurface = Color(0xFF201A18); // Near-black warm

  static const Color lightSurfaceVariant = Color(
    0xFFF0E0DB,
  ); // Light warm gray/beige
  static const Color lightOnSurfaceVariant = Color(
    0xFF504441,
  ); // Dark warm gray
  static const Color lightOutline = Color(0xFF827470); // Medium warm gray

  // Màu Error (Giữ màu đỏ tiêu chuẩn)
  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFDAD6);
  static const Color lightOnErrorContainer = Color(0xFF410002);

  // --- Dark Theme Colors (Fire: Bright Red/Orange/Pink + Wood: Green) ---
  // Nền và Surface: Màu tối ấm, tách biệt nhẹ, tránh xanh dương/đen
  static const Color darkBackground = Color(
    0xFF1F1A18,
  ); // Very dark warm gray/brownish
  static const Color darkSurface = Color(
    0xFF2A2422,
  ); // Slightly lighter warm gray

  // Màu chữ/icon chính trên nền/surface tối
  static const Color darkOnBackground = Color(0xFFECE0DD); // Light warm gray
  static const Color darkOnSurface = Color(0xFFECE0DD); // Light warm gray

  // Màu Primary: Đỏ sáng
  static const Color darkPrimary = Color(0xFFFF8A80); // Red A100 (Bright Red)
  static const Color darkOnPrimary = Color(0xFF5F0F0A); // Dark Red for text
  static const Color darkPrimaryContainer = Color(
    0xFF9B211B,
  ); // Darker Red container
  static const Color darkOnPrimaryContainer = Color(
    0xFFFFDAD6,
  ); // Light Red text

  // Màu Secondary: Xanh lá cây sáng
  static const Color darkSecondary = Color(0xFF81C784); // Green 300
  static const Color darkOnSecondary = Color(0xFF0A3918); // Dark Green for text
  static const Color darkSecondaryContainer = Color(
    0xFF2E7D32,
  ); // Green 700 container
  static const Color darkOnSecondaryContainer = Color(
    0xFFC8E6C9,
  ); // Light Green text

  // Màu Tertiary: Hồng sáng
  static const Color darkTertiary = Color(0xFFF48FB1); // Pink 200
  static const Color darkOnTertiary = Color(0xFF5C002B); // Dark Pink for text
  static const Color darkTertiaryContainer = Color(
    0xFFAD1457,
  ); // Pink 700 container
  static const Color darkOnTertiaryContainer = Color(
    0xFFFCE4EC,
  ); // Light Pink text

  // Accent màu Vàng sáng
  static const Color darkAccentYellow = Color(0xFFFFD54F); // Amber 300
  static const Color darkOnAccentYellow = Color(
    0xFF453000,
  ); // Dark Amber for text

  // Các màu khác
  static const Color darkSurfaceVariant = Color(0xFF504441); // Dark warm gray
  static const Color darkOnSurfaceVariant = Color(
    0xFFD4C3BE,
  ); // Medium-light warm gray
  static const Color darkOutline = Color(0xFF9C8D89); // Medium warm gray

  // Màu Error (Giữ màu đỏ tiêu chuẩn cho dark mode)
  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  // --- Semantic Colors (Ánh xạ phù hợp mệnh Hỏa) ---
  // Success -> Green (Mộc sinh Hỏa)
  // Warning -> Red (Hỏa)
  // Info -> Pink (Hỏa)

  // Success (Dùng tông Green - Mộc Tương Sinh)
  static const Color successLight = lightSecondary; // Green 700
  static const Color successDark = darkSecondary; // Green 300
  static const Color onSuccessLight = lightOnSecondary; // White
  static const Color onSuccessDark = darkOnSecondary; // Dark Green
  static const Color successContainerLight =
      lightSecondaryContainer; // Light Green
  static const Color successContainerDark = darkSecondaryContainer; // Green 700
  static const Color onSuccessContainerLight =
      lightOnSecondaryContainer; // Dark Green
  static const Color onSuccessContainerDark =
      darkOnSecondaryContainer; // Light Green

  // Warning (Dùng tông Primary - Hỏa Tương Hợp)
  static const Color warningLight = lightPrimary; // Red 700
  static const Color warningDark = darkPrimary; // Red A100
  static const Color onWarningLight = lightOnPrimary; // White
  static const Color onWarningDark = darkOnPrimary; // Dark Red
  static const Color warningContainerLight = lightPrimaryContainer; // Light Red
  static const Color warningContainerDark = darkPrimaryContainer; // Darker Red
  static const Color onWarningContainerLight =
      lightOnPrimaryContainer; // Dark Red text
  static const Color onWarningContainerDark =
      darkOnPrimaryContainer; // Light Red text

  // Info (Dùng tông Tertiary - Hỏa Tương Hợp)
  static const Color infoLight = lightTertiary; // Pink 400
  static const Color infoDark = darkTertiary; // Pink 200
  static const Color onInfoLight = lightOnTertiary; // White
  static const Color onInfoDark = darkOnTertiary; // Dark Pink
  static const Color infoContainerLight = lightTertiaryContainer; // Light Pink
  static const Color infoContainerDark = darkTertiaryContainer; // Pink 700
  static const Color onInfoContainerLight =
      lightOnTertiaryContainer; // Dark Pink text
  static const Color onInfoContainerDark =
      darkOnTertiaryContainer; // Light Pink text

  // --- Neutral Grays ---
  static const Color grayLight = Color(0xFFF1F3F4);
  static const Color grayMedium = Color(0xFFADB5BD);
  static const Color grayDark = Color(0xFF495057);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}
