import 'package:flutter/material.dart';

/// Bộ màu lấy cảm hứng từ Google Gemini - Chi tiết các màu sắc thường xuất hiện.
/// Lưu ý: Đây là bảng màu được tạo ra dựa trên quan sát, không phải mã màu chính thức.
class GeminiColors {
  // Màu chính - Brand colors (Tập trung vào xanh dương)
  static const Color primaryBlue = Color(
    0xFF1A73E8,
  ); // Xanh dương chính của Google
  static const Color deepBlue = Color(
    0xFF1967D2,
  ); // Xanh dương đậm hơn cho buttons, actions
  static const Color lightBlue = Color(
    0xFF89B9F5,
  ); // Xanh dương nhạt cho highlights, accents
  static const Color paleBlue = Color(
    0xFFE8F0FE,
  ); // Nền xanh rất nhạt (blue tint)

  // Màu UI chính
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Nền trắng tinh
  static const Color backgroundLightGrey = Color(
    0xFFF8F9FA,
  ); // Nền xám rất nhạt (off-white)
  static const Color surfaceGrey = Color(
    0xFFF1F3F4,
  ); // Màu bề mặt thẻ, input (hơi xám nhẹ)

  // Màu text
  static const Color textPrimary = Color(0xFF202124); // Text chính (xám đen)
  static const Color textSecondary = Color(0xFF5F6368); // Text phụ (xám vừa)
  static const Color textTertiary = Color(
    0xFF80868B,
  ); // Text ít quan trọng (xám nhạt hơn)
  static const Color textPlaceholder = Color(
    0xFFBDC1C6,
  ); // Placeholder text (xám rất nhạt)
  static const Color textLink = Color(
    0xFF1A0DAB,
  ); // Màu link truyền thống (tím xanh)

  // Màu viền và đường kẻ
  static const Color borderLight = Color(0xFFDADCE0); // Viền nhạt
  static const Color borderMedium = Color(0xFFBDC1C6); // Viền trung bình
  static const Color divider = Color(0xFFDADCE0); // Đường kẻ, phân chia

  // Màu tương tác
  static const Color hoverGrey = Color(
    0xFFF1F3F4,
  ); // Màu nền khi hover (xám rất nhạt)
  static const Color hoverBlue = Color(
    0xFFE8F0FE,
  ); // Màu nền xanh nhạt khi hover
  static const Color activeGrey = Color(
    0xFFE8EAED,
  ); // Màu nền khi active/selected (xám)
  static const Color activeBlue = Color(
    0xFFD2E3FC,
  ); // Màu nền xanh khi active/selected
  static const Color disabledBackground = Color(
    0xFFF1F3F4,
  ); // Nền của thành phần bị vô hiệu hóa
  static const Color disabledContent = Color(
    0xFFBDC1C6,
  ); // Màu nội dung (text/icon) bị vô hiệu hóa

  // Màu biểu thị trạng thái (Google Material Colors)
  static const Color successGreen = Color(0xFF1E8E3E); // Thành công (xanh lá)
  static const Color errorRed = Color(0xFFD93025); // Lỗi (đỏ)
  static const Color warningOrange = Color(0xFFF9AB00); // Cảnh báo (vàng/cam)
  static const Color infoBlue = Color(
    0xFF1A73E8,
  ); // Thông tin (xanh dương - giống primary)

  // Màu giao diện tối - Dark mode colors
  static const Color darkBackground = Color(0xFF202124); // Nền tối (xám đen)
  static const Color darkSurface = Color(
    0xFF303134,
  ); // Bề mặt tối (xám đậm hơn nền)
  static const Color darkSurfaceVariant = Color(
    0xFF44474C,
  ); // Bề mặt biến thể (xám trung tính)
  static const Color darkTextPrimary = Color(
    0xFFE8EAED,
  ); // Text sáng (gần trắng)
  static const Color darkTextSecondary = Color(
    0xFFBDC1C6,
  ); // Text phụ sáng (xám sáng)
  static const Color darkBorder = Color(0xFF5F6368); // Viền tối (xám)

  // Màu xanh đặc trưng cho dark mode
  static const Color brightBlue = Color(
    0xFF89B9F5,
  ); // Xanh sáng cho dark mode (tương phản tốt)
  static const Color darkAccentBlue = Color(
    0xFF004A8F,
  ); // Xanh đậm hơn làm container

  // Màu gradient - có thể dùng cho backgrounds hoặc hiệu ứng
  static final List<Color> blueGradient = [
    const Color(0xFF1A73E8),
    const Color(0xFF89B9F5),
  ];

  static final List<Color> greyGradient = [
    const Color(0xFFF8F9FA),
    const Color(0xFFF1F3F4),
  ];

  // Màu khi hiển thị giá trị alpha
  static const Color blueAlpha10 = Color(0x1A1A73E8); // 10% alpha
  static const Color blueAlpha20 = Color(0x331A73E8); // 20% alpha
  static const Color greyAlpha10 = Color(0x1A5F6368); // 10% alpha
}

/// ColorScheme sáng lấy cảm hứng từ Gemini
const ColorScheme geminiLightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Màu chính - primary colors
  primary: GeminiColors.primaryBlue,
  // Xanh dương chính
  onPrimary: GeminiColors.backgroundWhite,
  // Trắng trên nền xanh
  primaryContainer: GeminiColors.paleBlue,
  // Container xanh nhạt
  onPrimaryContainer: Color(0xFF0D3E6C),
  // Xanh đậm trên nền nhạt

  // Màu thứ hai - secondary colors (thường dùng màu trung tính)
  secondary: GeminiColors.textSecondary,
  // Xám vừa
  onSecondary: GeminiColors.backgroundWhite,
  // Trắng trên xám
  secondaryContainer: GeminiColors.surfaceGrey,
  // Container xám nhạt
  onSecondaryContainer: GeminiColors.textPrimary,
  // Đen/xám đen trên xám nhạt

  // Màu bổ sung - tertiary colors (có thể dùng xanh nhạt hơn)
  tertiary: GeminiColors.lightBlue,
  // Xanh dương nhạt
  onTertiary: GeminiColors.textPrimary,
  // Đen/xám đen trên xanh nhạt
  tertiaryContainer: Color(0xFFD2E3FC),
  // Container xanh rất nhạt
  onTertiaryContainer: Color(0xFF001D35),
  // Xanh rất đậm trên nền rất nhạt

  // Màu lỗi - error colors
  error: GeminiColors.errorRed,
  onError: GeminiColors.backgroundWhite,
  errorContainer: Color(0xFFFCE8E6),
  // Container đỏ nhạt
  onErrorContainer: Color(0xFFA50E0E),
  // Đỏ đậm trên nền nhạt

  // Màu nền và bề mặt
  background: GeminiColors.backgroundLightGrey,
  // Nền xám rất nhạt
  onBackground: GeminiColors.textPrimary,
  // Text đen/xám đen
  surface: GeminiColors.backgroundWhite,
  // Bề mặt thẻ/dialog (trắng)
  onSurface: GeminiColors.textPrimary,
  // Text đen/xám đen trên nền trắng
  surfaceVariant: GeminiColors.surfaceGrey,
  // Bề mặt biến thể (xám nhạt)
  onSurfaceVariant: GeminiColors.textSecondary,
  // Text xám vừa trên xám nhạt

  // Màu phác thảo
  outline: GeminiColors.borderMedium,
  // Viền vừa
  outlineVariant: GeminiColors.borderLight,
  // Viền nhạt

  // Màu bóng
  shadow: Color(0xFF000000),
  scrim: Color(0x99000000),
  // Lớp phủ mờ (thường là đen với alpha)

  // Màu đảo ngược (dùng cho các thành phần trên nền tối trong theme sáng)
  inverseSurface: GeminiColors.darkBackground,
  // Nền tối
  onInverseSurface: GeminiColors.darkTextPrimary,
  // Text sáng trên nền tối
  inversePrimary: GeminiColors.brightBlue,
  // Màu chính đảo ngược (xanh sáng)

  // Màu tint bề mặt
  surfaceTint: GeminiColors.primaryBlue, // Màu phủ lên surface khi có elevation
);

/// ColorScheme tối lấy cảm hứng từ Gemini
const ColorScheme geminiDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Màu chính - primary colors
  primary: GeminiColors.brightBlue,
  // Xanh sáng cho dark mode
  onPrimary: Color(0xFF002B5A),
  // Xanh rất đậm trên nền sáng
  primaryContainer: GeminiColors.darkAccentBlue,
  // Container xanh đậm
  onPrimaryContainer: Color(0xFFD2E3FC),
  // Xanh rất nhạt trên nền đậm

  // Màu thứ hai - secondary colors
  secondary: GeminiColors.darkTextSecondary,
  // Xám sáng
  onSecondary: GeminiColors.darkSurface,
  // Xám đậm trên xám sáng
  secondaryContainer: GeminiColors.darkSurfaceVariant,
  // Container xám trung tính
  onSecondaryContainer: GeminiColors.darkTextPrimary,
  // Text sáng trên xám

  // Màu bổ sung - tertiary colors
  tertiary: Color(0xFFA8CCFD),
  // Xanh sáng khác (hơi khác primary)
  onTertiary: Color(0xFF003355),
  // Xanh rất đậm
  tertiaryContainer: Color(0xFF004A77),
  // Container xanh đậm hơn
  onTertiaryContainer: Color(0xFFD4E3FF),
  // Xanh rất nhạt

  // Màu lỗi - error colors
  error: Color(0xFFF2B8B5),
  // Đỏ sáng
  onError: Color(0xFF601410),
  // Đỏ rất đậm
  errorContainer: Color(0xFF8C1D18),
  // Container đỏ đậm
  onErrorContainer: Color(0xFFFCE8E6),
  // Đỏ rất nhạt

  // Màu nền và bề mặt
  background: GeminiColors.darkBackground,
  // Nền xám đen
  onBackground: GeminiColors.darkTextPrimary,
  // Text sáng
  surface: GeminiColors.darkBackground,
  // Bề mặt (có thể giống nền hoặc hơi khác)
  onSurface: GeminiColors.darkTextPrimary,
  // Text sáng trên bề mặt
  surfaceVariant: GeminiColors.darkSurfaceVariant,
  // Bề mặt biến thể xám
  onSurfaceVariant: GeminiColors.darkTextSecondary,
  // Text xám sáng trên bề mặt biến thể

  // Màu phác thảo
  outline: GeminiColors.darkBorder,
  // Viền xám
  outlineVariant: GeminiColors.darkSurfaceVariant,
  // Viền xám đậm hơn

  // Màu bóng
  shadow: Color(0xFF000000),
  scrim: Color(0x99000000),

  // Màu đảo ngược (dùng cho các thành phần trên nền sáng trong theme tối)
  inverseSurface: GeminiColors.darkTextPrimary,
  // Nền sáng (gần trắng)
  onInverseSurface: GeminiColors.darkBackground,
  // Text tối trên nền sáng
  inversePrimary: GeminiColors.primaryBlue,
  // Màu chính đảo ngược (xanh dương gốc)

  // Màu tint bề mặt
  surfaceTint: GeminiColors
      .brightBlue, // Màu phủ lên surface khi có elevation (xanh sáng)
);
