// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Định nghĩa bảng màu cho ứng dụng, tối ưu cho người mệnh Hỏa.
/// Chủ đạo: Đỏ, Cam, Hồng, Tím và các màu trung tính.
class AppColors {
  // --- Material Design 3 Inspired Palette (Fire Element Optimized) ---

  // --- Light Theme Colors ---
  static const Color lightPrimary = Color(
    0xFFE53935,
  ); // Red 600 - Màu chính mệnh Hỏa
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(
    0xFFFFCDD2,
  ); // Red 100 - Background nhẹ
  static const Color lightOnPrimaryContainer = Color(0xFF4F0000); // Đỏ đậm

  static const Color lightSecondary = Color(
    0xFFE65100,
  ); // Deep Orange 900 - Màu phụ tương sinh
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(
    0xFFFFE0B2,
  ); // Orange 100 - Background nhẹ
  static const Color lightOnSecondaryContainer = Color(
    0xFF572800,
  ); // Orange đậm

  static const Color lightTertiary = Color(
    0xFF7B1FA2,
  ); // Purple 700 - Màu thứ 3 tương sinh
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(
    0xFFE1BEE7,
  ); // Purple 100 - Background nhẹ
  static const Color lightOnTertiaryContainer = Color(0xFF3E0055); // Purple đậm

  // Điều chỉnh background tối hơn - Sử dụng tông màu hồng-vàng nhạt
  static const Color lightBackground = Color(
    0xFFF5EFEA,
  ); // Trắng ấm tối hơn (beige nhạt)
  static const Color lightOnBackground = Color(0xFF1A1A1A); // Gần đen
  static const Color lightSurface = Color(
    0xFFF5EFEA,
  ); // Trắng ấm tối hơn (beige nhạt)
  static const Color lightOnSurface = Color(0xFF1A1A1A); // Gần đen

  // Điều chỉnh các màu bề mặt tương ứng
  static const Color lightSurfaceVariant = Color(
    0xFFEBDFD3,
  ); // Beige đậm hơn - Thổ hỗ trợ Hỏa
  static const Color lightOnSurfaceVariant = Color(0xFF52443C); // Nâu đất
  static const Color lightOutline = Color(0xFF7D6E64); // Nâu đất nhạt - Thổ

  static const Color lightError = Color(0xFFD32F2F); // Đỏ error
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFEBEE); // Đỏ nhạt
  static const Color lightOnErrorContainer = Color(0xFF450A0A); // Đỏ đậm

  // --- Dark Theme Colors ---
  static const Color darkPrimary = Color(0xFFFF6E6E); // Đỏ sáng cho dark mode
  static const Color darkOnPrimary = Color(0xFF4F0000); // Đỏ đậm
  static const Color darkPrimaryContainer = Color(
    0xFFB71C1C,
  ); // Red 900 - Đậm hơn
  static const Color darkOnPrimaryContainer = Color(0xFFFFDADA); // Đỏ rất nhạt

  static const Color darkSecondary = Color(0xFFFFB74D); // Orange 300 - Cam sáng
  static const Color darkOnSecondary = Color(0xFF572800); // Orange đậm
  static const Color darkSecondaryContainer = Color(
    0xFFBF360C,
  ); // Deep Orange 900
  static const Color darkOnSecondaryContainer = Color(
    0xFFFFDCC3,
  ); // Cam rất nhạt

  static const Color darkTertiary = Color(0xFFCE93D8); // Purple 200 - Tím sáng
  static const Color darkOnTertiary = Color(0xFF3E0055); // Tím đậm
  static const Color darkTertiaryContainer = Color(0xFF6A1B9A); // Purple 900
  static const Color darkOnTertiaryContainer = Color(
    0xFFF3D9FF,
  ); // Tím rất nhạt

  static const Color darkBackground = Color(
    0xFF241816,
  ); // Nâu đậm - Thổ hỗ trợ Hỏa
  static const Color darkOnBackground = Color(0xFFEDE0D9); // Beige sáng
  static const Color darkSurface = Color(
    0xFF241816,
  ); // Nâu đậm - Thổ hỗ trợ Hỏa
  static const Color darkOnSurface = Color(0xFFEDE0D9); // Beige sáng

  static const Color darkSurfaceVariant = Color(0xFF52443C); // Nâu đất đậm
  static const Color darkOnSurfaceVariant = Color(0xFFE5D8CE); // Beige rất sáng
  static const Color darkOutline = Color(0xFF9E8E82); // Nâu nhạt

  static const Color darkError = Color(0xFFEF9A9A); // Red 200 - Đỏ sáng
  static const Color darkOnError = Color(0xFF690505); // Đỏ rất đậm
  static const Color darkErrorContainer = Color(0xFFC62828); // Red 800 - Đỏ đậm
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6); // Đỏ rất nhạt

  // --- Semantic Colors ---

  // Success (Sử dụng màu Thổ - vàng đất - hỗ trợ Hỏa)
  static const Color successLight = Color(0xFFFF8F00); // Amber 800
  static const Color successDark = Color(0xFFFFCA28); // Amber 400
  static const Color onSuccessLight = Color(0xFF000000);
  static const Color onSuccessDark = Color(0xFF3D3100);
  static const Color successContainerLight = Color(0xFFFFECB3); // Amber 100
  static const Color successContainerDark = Color(0xFFBF6D00); // Amber 900
  static const Color onSuccessContainerLight = Color(0xFF3D3100);
  static const Color onSuccessContainerDark = Color(0xFFFFF8E2);

  // Warning (Giữ nguyên màu cam)
  static const Color warningLight = Color(0xFFFF9800); // Orange 500
  static const Color warningDark = Color(0xFFFFB74D); // Orange 300
  static const Color onWarningLight = Color(0xFF000000);
  static const Color onWarningDark = Color(0xFF3D2200);
  static const Color warningContainerLight = Color(0xFFFFE0B2); // Orange 100
  static const Color warningContainerDark = Color(0xFFE65100); // Orange 900
  static const Color onWarningContainerLight = Color(0xFF3D2200);
  static const Color onWarningContainerDark = Color(0xFFFFF2E2);

  // Info (Sử dụng màu Tím thay vì xanh dương)
  static const Color infoLight = Color(0xFF7B1FA2); // Purple 700
  static const Color infoDark = Color(0xFFCE93D8); // Purple 200
  static const Color onInfoLight = Color(0xFFFFFFFF);
  static const Color onInfoDark = Color(0xFF3E0055);
  static const Color infoContainerLight = Color(0xFFE1BEE7); // Purple 100
  static const Color infoContainerDark = Color(0xFF6A1B9A); // Purple 900
  static const Color onInfoContainerLight = Color(0xFF3E0055);
  static const Color onInfoContainerDark = Color(0xFFF3D9FF);

  // --- Neutral Grays ---
  static const Color grayLight = Color(
    0xFFF0F0F0,
  ); // Light neutral gray điều chỉnh tối hơn
  static const Color grayMedium = Color(0xFFBDBDBD); // Medium neutral gray
  static const Color grayDark = Color(0xFF616161); // Dark neutral gray
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

extension ColorAlpha on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withOpacity(alpha);
    }
    return this;
  }
}
