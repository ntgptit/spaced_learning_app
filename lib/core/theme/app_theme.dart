import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart'; // Import AppDimens
import 'package:spaced_learning_app/core/theme/app_typography.dart';

class AppTheme {
  // Create the light theme
  static ThemeData getLightTheme() {
    const colorScheme = ColorScheme(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryVariant,
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryVariant,
      surface: AppColors.lightSurface,
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onSurface: AppColors.lightOnSurface,
      onError: AppColors.lightOnError,
      brightness: Brightness.light,
    );

    return _createTheme(colorScheme);
  }

  // Create the dark theme with higher contrast
  static ThemeData getDarkTheme() {
    const colorScheme = ColorScheme(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryVariant,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryVariant,
      surface: AppColors.darkSurface,
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onSurface: AppColors.darkOnSurface,
      onError: AppColors.darkOnError,
      brightness: Brightness.dark,
    );

    return _createTheme(colorScheme);
  }

  // Helper method to create themes with shared properties
  static ThemeData _createTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.getTextTheme(colorScheme.brightness),
      scaffoldBackgroundColor: colorScheme.surface,

      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: AppDimens.elevationNone, // 0.0
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle:
            AppTypography.getTextTheme(colorScheme.brightness).titleLarge,
        shadowColor: isDark ? Colors.black26 : Colors.black12,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: AppDimens.elevationS, // 2.0
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusL), // 16.0
        ),
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(
          vertical: AppDimens.paddingS, // 8.0
          horizontal: 0,
        ),
        shadowColor: isDark ? Colors.black : Colors.black26,
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppDimens.elevationS, // 2.0
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXL, // 20.0
            vertical: AppDimens.paddingM, // 12.0 (gần với 14)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          ),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXL, // 20.0
            vertical: AppDimens.paddingM, // 12.0 (gần với 14)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          ),
          side: BorderSide(
            color: colorScheme.primary,
            width: AppDimens.dividerThickness * 1.5, // 1.5 (gần đúng)
          ),
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingL, // 16.0
            vertical: AppDimens.paddingM, // 12.0
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusS), // 8.0
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            isDark
                ? colorScheme.onSurface.withValues(
                  alpha: AppDimens.opacityLight,
                ) // 0.04
                : colorScheme.onSurface.withValues(
                  alpha: AppDimens.opacityLight,
                ), // 0.04
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingXL, // 20.0
          vertical: AppDimens.paddingL, // 16.0
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(
              alpha: AppDimens.opacitySemi,
            ), // 0.20
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(
              alpha: AppDimens.opacitySemi,
            ), // 0.20
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppDimens.elevationS, // 2.0
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppDimens.dividerThickness, // 1.0
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppDimens.elevationS, // 2.0
          ),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurface.withValues(
            alpha: AppDimens.opacityHigh,
          ), // 0.70
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(
            alpha: 0.5,
          ), // Không có giá trị chính xác, giữ nguyên
        ),
        errorStyle: TextStyle(
          color: colorScheme.error,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colorScheme.onSurface.withValues(
          alpha: AppDimens.opacityMedium,
        ), // 0.12
        thickness: AppDimens.dividerThickness, // 1.0
        space: AppDimens.dividerThickness, // 1.0
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: AppDimens.elevationXXL, // 24.0
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL), // 20.0
        ),
      ),

      // ListTile theme
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusS), // 8.0
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL, // 16.0
          vertical: AppDimens.paddingS, // 8.0
        ),
        minLeadingWidth: AppDimens.iconL, // 24.0
        minVerticalPadding: AppDimens.paddingL, // 16.0
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary.withValues(
          alpha: AppDimens.opacitySemi,
        ), // 0.20
        secondarySelectedColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM, // 12.0
          vertical: AppDimens.paddingS, // 8.0
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL), // 20.0
          side: BorderSide(
            color: colorScheme.primary.withValues(
              alpha: 0.5,
            ), // Không có giá trị chính xác, giữ nguyên
          ),
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface.withValues(
          alpha: 0.8,
        ), // Không có giá trị chính xác, giữ nguyên
        size: AppDimens.iconL, // 24.0
      ),

      // Bottom navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(
          alpha: 0.6,
        ), // Không có giá trị chính xác, giữ nguyên
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimens.elevationL, // 8.0
      ),

      // Tab bar theme
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withValues(
          alpha: AppDimens.opacityHigh,
        ), // 0.70
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.primary,
              width: 3.0, // Không có giá trị chính xác, giữ nguyên
            ),
          ),
        ),
      ),
    );
  }
}
