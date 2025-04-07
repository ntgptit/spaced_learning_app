import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart'; // Đảm bảo import AppColors đã cập nhật
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/core/theme/app_typography.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    // Sử dụng các màu sáng từ AppColors đã cập nhật (Teal/Blue/Amber theme)
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimaryContainer: AppColors.lightOnPrimaryContainer,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      onSecondaryContainer: AppColors.lightOnSecondaryContainer,
      tertiary: AppColors.lightTertiary,
      onTertiary: AppColors.lightOnTertiary,
      tertiaryContainer: AppColors.lightTertiaryContainer,
      onTertiaryContainer: AppColors.lightOnTertiaryContainer,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      errorContainer: AppColors.lightErrorContainer,
      onErrorContainer: AppColors.lightOnErrorContainer,
      surface:
          AppColors
              .lightSurface, // == surfaceContainerLowest trong AppColors mới
      onSurface: AppColors.lightOnSurface, // Sử dụng đúng surfaceVariant
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      outline: AppColors.lightOutline,
      // outlineVariant: // Có thể thêm nếu định nghĩa trong AppColors
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: AppColors.almostBlack, // Hoặc màu tối tương phản khác
      onInverseSurface: AppColors.neutralLight, // Hoặc màu sáng tương phản khác
      inversePrimary:
          AppColors.darkPrimary, // Thường là màu primary của theme đối lập
      surfaceTint: AppColors.lightPrimary, // Thường là màu primary
      // M3 Surface Container Levels (Map từ AppColors mới)
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      surfaceDim: AppColors.surfaceDim, // Thêm nếu có
    );

    return _createTheme(colorScheme);
  }

  static ThemeData getDarkTheme() {
    // Sử dụng các màu tối từ AppColors đã cập nhật (Teal/Blue/Amber theme)
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkOnSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkOnTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      onTertiaryContainer: AppColors.darkOnTertiaryContainer,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      errorContainer: AppColors.darkErrorContainer,
      onErrorContainer: AppColors.darkOnErrorContainer,
      surface:
          AppColors
              .darkSurface, // == darkSurfaceContainerLowest trong AppColors mới
      onSurface: AppColors.darkOnSurface, // Sử dụng đúng surfaceVariant
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOutline,
      // outlineVariant: // Có thể thêm nếu định nghĩa trong AppColors
      shadow: Colors.black, // Shadow thường vẫn là màu tối
      scrim: Colors.black54,
      inverseSurface: AppColors.neutralLight, // Hoặc màu sáng tương phản khác
      onInverseSurface: AppColors.almostBlack, // Hoặc màu tối tương phản khác
      inversePrimary:
          AppColors.lightPrimary, // Thường là màu primary của theme đối lập
      surfaceTint: AppColors.darkPrimary, // Thường là màu primary
      // M3 Surface Container Levels (Map từ AppColors mới)
      surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
      surfaceContainerLow: AppColors.darkSurfaceContainerLow,
      surfaceContainer: AppColors.darkSurfaceContainer,
      surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
      surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
      surfaceDim: AppColors.darkSurfaceDim, // Thêm nếu có
    );

    return _createTheme(colorScheme);
  }

  // Phương thức _createTheme giữ nguyên cấu trúc,
  // nhưng giờ sẽ nhận ColorScheme đã được cập nhật với màu tươi sáng.
  // Các tham chiếu trực tiếp đến AppColors bên trong sẽ dùng giá trị mới.
  static ThemeData _createTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = AppTypography.getTextTheme(colorScheme.brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      // Sử dụng colorScheme cho các thuộc tính gốc nếu có thể
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: AppDimens.elevationS,
        centerTitle: false,
        // AppBar có thể dùng surface hoặc surface container tùy thiết kế
        // Mã gốc dùng AppColors, giữ nguyên để apply trực tiếp
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerHighest
                : AppColors.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface, // Tốt hơn là dùng colorScheme
        titleTextStyle: textTheme.titleLarge,
        shadowColor: isDark ? Colors.black26 : Colors.black12,
        iconTheme: IconThemeData(
          // Mã gốc dùng AppColors, giữ nguyên
          color:
              isDark ? AppColors.iconPrimaryDark : AppColors.iconPrimaryLight,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: AppDimens.elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ),
        // Card thường dùng surface hoặc surface container thấp
        // Mã gốc dùng AppColors, giữ nguyên
        color:
            isDark
                ? AppColors.darkSurfaceContainerLow
                : AppColors.surfaceContainerLowest,
        surfaceTintColor:
            Colors.transparent, // M3 thường dùng colorScheme.surfaceTint ở đây
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
        shadowColor: isDark ? Colors.black : Colors.black26,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppDimens.elevationS,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXL,
            vertical: AppDimens.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          foregroundColor: colorScheme.onPrimary, // Đúng chuẩn M3
          backgroundColor: colorScheme.primary, // Đúng chuẩn M3
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXL,
            vertical: AppDimens.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          side: BorderSide(
            color:
                colorScheme.outline, // M3 thường dùng colorScheme.outline ở đây
            width: AppDimens.outlineButtonBorderWidth,
          ),
          foregroundColor: colorScheme.primary, // Đúng chuẩn M3
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary, // Đúng chuẩn M3
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingL,
            vertical: AppDimens.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Mã gốc dùng AppColors, giữ nguyên.
        // M3 thường dùng colorScheme.surfaceContainerHighest hoặc tương tự
        fillColor:
            isDark
                ? AppColors.darkSurfaceContainerLow
                : AppColors.lightOnSurface.withValues(
                  alpha: AppDimens.opacityLight,
                ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingXL,
          vertical: AppDimens.paddingL,
        ),
        // Sử dụng colorScheme.outline cho border sẽ chuẩn M3 hơn
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(color: colorScheme.outline), // Chuẩn M3
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(color: colorScheme.outline), // Chuẩn M3
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.primary, // Đúng chuẩn M3
            width: AppDimens.elevationS, // Có thể là 2.0
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.error, // Đúng chuẩn M3
            width: AppDimens.dividerThickness,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.error, // Đúng chuẩn M3
            width: AppDimens.elevationS, // Có thể là 2.0
          ),
        ),
        // Sử dụng onSurface hoặc onSurfaceVariant cho label/hint
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant, // Chuẩn M3
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant, // Chuẩn M3
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onErrorContainer,
        ), // Chuẩn M3
        floatingLabelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.primary, // Đúng chuẩn M3
        ),
      ),
      dividerTheme: DividerThemeData(
        // M3 thường dùng colorScheme.outlineVariant
        color: colorScheme.outlineVariant, // Dùng outlineVariant nếu có
        thickness: AppDimens.dividerThickness,
        space: AppDimens.dividerThickness, // space thường lớn hơn thickness
      ),
      dialogTheme: DialogThemeData(
        // M3 dùng colorScheme.surfaceContainerHigh hoặc tương tự
        // Mã gốc dùng AppColors, giữ nguyên
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerHighest
                : AppColors.surfaceContainerLowest,
        elevation:
            AppDimens
                .elevationXXL, // M3 thường dùng elevation thấp hơn (e.g., 6)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.radiusXL,
          ), // M3 thường là 28.0
        ),
        titleTextStyle: textTheme.headlineSmall, // Đúng chuẩn M3
        contentTextStyle: textTheme.bodyMedium, // Đúng chuẩn M3
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL,
          vertical: AppDimens.paddingS,
        ),
        minLeadingWidth: AppDimens.iconL,
        minVerticalPadding: AppDimens.paddingL,
        iconColor: colorScheme.primary, // Chuẩn M3
        textColor: colorScheme.onSurface, // Chuẩn M3
        titleTextStyle: textTheme.bodyLarge, // Chuẩn M3
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant, // Chuẩn M3
        ),
      ),
      chipTheme: ChipThemeData(
        // M3 dùng colorScheme.secondaryContainer hoặc surfaceContainerLow/etc.
        // Mã gốc dùng AppColors, giữ nguyên
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerLow
                : AppColors.surfaceContainerLow,
        selectedColor: colorScheme.primaryContainer, // Chuẩn M3 hơn
        secondarySelectedColor:
            colorScheme.primary, // Thường là primaryContainer hoặc primary
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingS,
        ),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant, // Chuẩn M3
        ),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onPrimaryContainer, // Chuẩn M3 hơn
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.radiusXL,
          ), // M3 thường là 8.0
          side: BorderSide(
            // M3 dùng colorScheme.outline
            color: colorScheme.outline, // Chuẩn M3
          ),
        ),
        elevation: AppDimens.elevationNone,
        pressElevation: AppDimens.elevationXS,
      ),
      iconTheme: IconThemeData(
        // Nên dùng colorScheme.onSurface hoặc onSurfaceVariant
        color:
            isDark
                ? AppColors.iconPrimaryDark
                : AppColors.iconPrimaryLight, // Giữ nguyên mã gốc
        size: AppDimens.iconL,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // M3 dùng colorScheme.surfaceContainer hoặc surface
        // Mã gốc dùng AppColors, giữ nguyên
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerHighest
                : AppColors.surfaceContainerHighest,
        selectedItemColor: colorScheme.onSurface, // M3 dùng onSurface
        unselectedItemColor:
            colorScheme.onSurfaceVariant, // M3 dùng onSurfaceVariant
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimens.elevationL, // M3 thường là 0 hoặc 3
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary, // Chuẩn M3
        unselectedLabelColor: colorScheme.onSurfaceVariant, // Chuẩn M3
        labelStyle: textTheme.titleSmall, // Chuẩn M3
        unselectedLabelStyle: textTheme.titleSmall, // Chuẩn M3
        indicatorColor: colorScheme.primary, // Chuẩn M3
        indicatorSize: TabBarIndicatorSize.tab, // Chuẩn M3
        // Bỏ BoxDecoration cũ, dùng thuộc tính M3
        // indicator: BoxDecoration(
        //   border: Border(
        //     bottom: BorderSide(
        //       color: colorScheme.primary,
        //       width: AppDimens.tabIndicatorThickness,
        //     ),
        //   ),
        // ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor:
            colorScheme.primaryContainer, // M3 thường dùng primaryContainer
        foregroundColor:
            colorScheme.onPrimaryContainer, // M3 dùng onPrimaryContainer
        elevation: AppDimens.elevationL, // M3 là 6
        hoverElevation: AppDimens.elevationXL,
        focusElevation: AppDimens.elevationL,
        highlightElevation: AppDimens.elevationXL,
        shape: RoundedRectangleBorder(
          // M3 dùng hình dạng khác nhau tùy loại FAB (Circular, Small, Large, Extended)
          // Giữ hình tròn cơ bản
          borderRadius: BorderRadius.circular(AppDimens.radiusCircular),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary, // Chuẩn M3
        linearTrackColor: colorScheme.surfaceContainerHighest, // Chuẩn M3
        circularTrackColor: colorScheme.surfaceContainerHighest, // Chuẩn M3
        refreshBackgroundColor: colorScheme.surfaceContainerLow, // Chuẩn M3
      ),
      snackBarTheme: SnackBarThemeData(
        // M3 dùng inverseSurface
        backgroundColor: colorScheme.inverseSurface, // Chuẩn M3
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface, // Chuẩn M3
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusS), // M3 là 4.0
        ),
        actionTextColor: colorScheme.inversePrimary, // Chuẩn M3
        behavior: SnackBarBehavior.floating,
      ),
      tooltipTheme: TooltipThemeData(
        // M3 dùng màu khác (thường là inverseSurface hoặc màu trung tính đậm/nhạt)
        // Giữ nguyên mã gốc
        decoration: BoxDecoration(
          color:
              isDark
                  ? AppColors.darkSurfaceContainerHighest
                  : AppColors.neutralDark,
          borderRadius: BorderRadius.circular(AppDimens.radiusS), // M3 là 4.0
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          // Phụ thuộc vào màu nền tooltip
          color: isDark ? AppColors.textPrimaryDark : AppColors.white,
        ),
      ),
    );
  }
}
