/// Class quản lý các kích thước, padding, margin thường dùng trong ứng dụng
/// Giúp đảm bảo tính nhất quán về kích thước trong toàn bộ ứng dụng
class AppDimens {
  // Padding & Margin
  static const double paddingXXS = 2.0;
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXL = 24.0;
  static const double paddingXXL = 32.0;
  static const double paddingXXXL = 48.0;

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  static const double radiusCircular = 100.0; // Cho circular element

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
  static const double buttonHeightS = 28.0;
  static const double buttonHeightM = 36.0;
  static const double buttonHeightL = 48.0;
  static const double buttonHeightXL = 56.0;
  static const double textFieldHeight = 48.0;
  static const double textFieldHeightS = 36.0;
  static const double appBarHeight = 56.0;
  static const double tabBarHeight = 48.0;
  static const double bottomNavBarHeight = 56.0;
  static const double listTileHeight = 56.0;
  static const double listTileHeightS = 48.0;
  static const double bottomSheetMinHeight = 120.0;
  static const double bottomSheetHeaderHeight = 56.0;
  static const double badgeHeight = 24.0;
  static const double chipHeight = 32.0;
  static const double dividerThickness = 1.0;
  static const double thickDividerHeight = 4.0;

  // Width values
  static const double buttonMinWidth = 64.0;
  static const double dialogMinWidth = 280.0;
  static const double dialogMaxWidth = 560.0;
  static const double menuMaxWidth = 320.0;

  // Elevations
  static const double elevationXS = 1.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;

  // Font sizes - thường được định nghĩa trong TextTheme, nhưng để đầy đủ
  static const double fontXXS = 8.0;
  static const double fontXS = 10.0;
  static const double fontS = 12.0;
  static const double fontM = 14.0;
  static const double fontL = 16.0;
  static const double fontXL = 18.0;
  static const double fontXXL = 20.0;
  static const double fontXXXL = 24.0;
  static const double display1 = 34.0;
  static const double display2 = 45.0;
  static const double display3 = 56.0;

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

  // Grid system
  static const double gridSpacingXS = 2.0;
  static const double gridSpacingS = 4.0;
  static const double gridSpacingM = 8.0;
  static const double gridSpacingL = 16.0;
  static const double gridItemMinWidth = 120.0;
  static const double gridItemMaxWidth = 180.0;

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

  // Animation durations
  static const int durationXS = 100; // milliseconds
  static const int durationS = 200;
  static const int durationM = 300;
  static const int durationL = 500;
  static const int durationXL = 800;

  // Specific UI elements
  static const double moduleIndicatorSize = 36.0;
  static const double circularProgressSize = 24.0;
  static const double circularProgressSizeL = 48.0;
  static const double lineProgressHeight = 4.0;
  static const double lineProgressHeightL = 8.0;
  static const double badgeIconPadding = 2.0;
  static const double shimmerHeight = 16.0;

  // Layout constants
  static const double maxContentWidth =
      1200.0; // Maximum width for content on large screens
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
  static const double safeAreaTop = 44.0; // For iOS safe area
  static const double safeAreaBottom = 34.0; // For iOS safe area

  // Opacity constants
  static const double opacityDisabled = 0.38;
  static const double opacityLight = 0.05;
  static const double opacityMedium = 0.1;
  static const double opacitySemi = 0.2;
  static const double opacityHigh = 0.6;
}
