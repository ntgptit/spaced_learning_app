/// Class quản lý các kích thước, padding, margin thường dùng trong ứng dụng
/// Giúp đảm bảo tính nhất quán về kích thước trong toàn bộ ứng dụng
class AppDimens {
  // Padding & Margin
  static const double paddingXXS = 2.0;
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXL = 20.0; // Thêm để khớp với padding 20
  static const double paddingXXL = 24.0;
  static const double paddingXXXL = 32.0;
  static const double paddingSection = 40.0; // Khoảng cách giữa các section lớn
  static const double paddingPage = 48.0; // Padding cho toàn trang

  // Border Radius
  static const double radiusXXS = 2.0; // Thêm để hỗ trợ radius nhỏ hơn
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0; // Thêm để khớp với radius 20
  static const double radiusXXL = 24.0;
  static const double radiusXXXL = 32.0;
  static const double radiusCircular = 100.0;

  // Icon Sizes
  static const double iconXXS = 10.0;
  static const double iconXS = 12.0;
  static const double iconS = 16.0;
  static const double iconM = 20.0;
  static const double iconL = 24.0;
  static const double iconXL = 32.0;
  static const double iconXXL = 48.0;
  static const double iconXXXL = 64.0;

  // Widget heights
  static const double buttonHeightXS = 24.0; // Thêm để hỗ trợ nút nhỏ hơn
  static const double buttonHeightS = 28.0;
  static const double buttonHeightM = 36.0;
  static const double buttonHeightL = 48.0;
  static const double buttonHeightXL = 56.0;
  static const double textFieldHeightS = 36.0;
  static const double textFieldHeight = 48.0;
  static const double textFieldHeightL =
      56.0; // Thêm để hỗ trợ text field lớn hơn
  static const double appBarHeight = 56.0;
  static const double tabBarHeight = 48.0;
  static const double bottomNavBarHeight = 56.0;
  static const double listTileHeightS = 48.0;
  static const double listTileHeight = 56.0;
  static const double listTileHeightL =
      72.0; // Thêm để hỗ trợ list tile lớn hơn
  static const double bottomSheetMinHeight = 120.0;
  static const double bottomSheetHeaderHeight = 56.0;
  static const double badgeHeight = 24.0;
  static const double chipHeight = 32.0;
  static const double snackbarHeight = 48.0; // Thêm cho snackbar
  static const double fabSize = 56.0; // Floating Action Button size
  static const double fabSizeSmall = 40.0; // FAB nhỏ
  static const double dividerThickness = 1.0;
  static const double thickDividerHeight = 4.0;

  // Width values
  static const double buttonMinWidth = 64.0;
  static const double dialogMinWidth = 280.0;
  static const double dialogMaxWidth = 560.0;
  static const double menuMaxWidth = 320.0;
  static const double tooltipMinWidth = 40.0; // Thêm cho tooltip

  // Elevations
  static const double elevationNone = 0.0; // Thêm để rõ ràng
  static const double elevationXS = 1.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;
  static const double elevationXXL =
      24.0; // Thêm để khớp với dialog elevation 24

  // Shadow properties
  static const double shadowRadiusS = 2.0; // Thêm để tùy chỉnh bóng đổ
  static const double shadowRadiusM = 4.0;
  static const double shadowRadiusL = 8.0;
  static const double shadowOffsetS = 1.0; // Offset cho bóng đổ
  static const double shadowOffsetM = 2.0;

  // Font sizes (đồng bộ với app_typography.dart)
  static const double fontXXS = 8.0;
  static const double fontXS = 10.0;
  static const double fontS = 11.0; // Thay vì 12 để khớp với labelSmall
  static const double fontM = 12.0;
  static const double fontL = 14.0;
  static const double fontXL = 16.0;
  static const double fontXXL = 18.0;
  static const double fontXXXL = 20.0;
  static const double fontTitle = 22.0; // Thêm để khớp với titleLarge
  static const double fontHeadlineS = 24.0; // headlineSmall
  static const double fontHeadlineM = 28.0; // headlineMedium
  static const double fontHeadlineL = 32.0; // headlineLarge
  static const double fontDisplayS = 36.0; // displaySmall
  static const double fontDisplayM = 45.0; // displayMedium
  static const double fontDisplayL = 57.0; // displayLarge

  // Spaces (for SizedBox)
  static const double spaceXXS = 2.0;
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 12.0;
  static const double spaceL = 16.0;
  static const double spaceXL = 24.0;
  static const double spaceXXL = 32.0;
  static const double spaceXXXL = 48.0;
  static const double spaceSectionGap = 40.0;
  static const double spacePageGap = 64.0; // Thêm cho khoảng cách lớn hơn

  // Grid system
  static const double gridSpacingXS = 2.0;
  static const double gridSpacingS = 4.0;
  static const double gridSpacingM = 8.0;
  static const double gridSpacingL = 16.0;
  static const double gridItemMinWidth = 120.0;
  static const double gridItemMaxWidth = 180.0;
  static const double gridGutter = 16.0; // Khoảng cách giữa các cột/lưới

  // Image sizes
  static const double avatarSizeXS = 24.0;
  static const double avatarSizeS = 32.0;
  static const double avatarSizeM = 40.0;
  static const double avatarSizeL = 48.0;
  static const double avatarSizeXL = 64.0;
  static const double avatarSizeXXL = 96.0;
  static const double thumbnailSizeS = 80.0;
  static const double thumbnailSizeM = 120.0;
  static const double thumbnailSizeL = 160.0;

  // Animation durations (milliseconds)
  static const int durationXXS = 50; // Thêm cho hiệu ứng rất nhanh
  static const int durationXS = 100;
  static const int durationS = 200;
  static const int durationM = 300;
  static const int durationL = 500;
  static const int durationXL = 800;
  static const int durationFade = 250; // Thêm cho fade animation
  static const int durationSlide = 400; // Thêm cho slide animation

  // Specific UI elements
  static const double moduleIndicatorSize = 36.0;
  static const double circularProgressSize = 24.0;
  static const double circularProgressSizeL = 48.0;
  static const double lineProgressHeight = 4.0;
  static const double lineProgressHeightL = 8.0;
  static const double badgeIconPadding = 2.0;
  static const double shimmerHeight = 16.0;
  static const double touchTargetMinSize =
      48.0; // Thêm để đảm bảo accessibility

  // Layout constants
  static const double maxContentWidth = 1200.0;
  static const double sideMenuWidth = 280.0;
  static const double compactSideMenuWidth = 80.0;
  static const double bannerHeight = 200.0;
  static const double cardMinHeight = 80.0;

  // Screen breakpoints
  static const double breakpointXS = 360.0;
  static const double breakpointS = 480.0;
  static const double breakpointM = 768.0;
  static const double breakpointL = 1024.0;
  static const double breakpointXL = 1440.0;

  // Insets
  static const double keyboardInset = 80.0;
  static const double safeAreaTop = 44.0;
  static const double safeAreaBottom = 34.0;

  // Opacity constants
  static const double opacityDisabled = 0.38;
  static const double opacityLight =
      0.04; // Điều chỉnh để khớp với inputDecorationTheme
  static const double opacityMedium = 0.12; // Điều chỉnh để khớp với divider
  static const double opacitySemi = 0.20; // Điều chỉnh để khớp với border
  static const double opacityHigh = 0.70; // Điều chỉnh để khớp với labelStyle
  static const double opacityFull = 1.0; // Thêm để rõ ràng

  // Responsive scaling factors (optional)
  static const double scaleFactorSmall = 0.85; // Cho màn hình nhỏ
  static const double scaleFactorLarge = 1.15; // Cho màn hình lớn
}
