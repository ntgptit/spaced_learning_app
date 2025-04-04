import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart'; // Import AppDimens
import 'package:spaced_learning_app/core/theme/app_typography.dart';

class AppTheme {
  // Create the light theme
  static ThemeData getLightTheme() {
    const colorScheme = ColorScheme(
      primary: AppColors.lightPrimary,
      primaryContainer:
          AppColors.lightPrimaryContainer, // Or a lighter shade if needed
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer, // Or lighter shade
      surface: AppColors.lightSurface, // Use defined background
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onSurface: AppColors.lightOnSurface, // Use defined onBackground
      onError: AppColors.lightOnError,
      brightness: Brightness.light,
    );

    return _createTheme(colorScheme);
  }

  // Create the dark theme with higher contrast
  static ThemeData getDarkTheme() {
    const colorScheme = ColorScheme(
      primary: AppColors.darkPrimary,
      primaryContainer:
          AppColors.darkOnPrimaryContainer, // Or a darker shade if needed
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer, // Or darker shade
      surface: AppColors.darkSurface, // Use defined background
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onSurface: AppColors.darkOnSurface, // Use defined onBackground
      onError: AppColors.darkOnError,
      brightness: Brightness.dark,
    );

    return _createTheme(colorScheme);
  }

  // Helper method to create themes with shared properties
  static ThemeData _createTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = AppTypography.getTextTheme(colorScheme.brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface, // Use background color
      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: AppDimens.elevationNone, // 0.0
        centerTitle: false,
        backgroundColor: colorScheme.surface, // Keep AppBar surface colored
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge, // Use textTheme
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
        surfaceTintColor: Colors.transparent, // Prevent M3 tinting
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
            vertical: AppDimens.paddingM, // 12.0
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          ),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge, // Use appropriate text style
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXL, // 20.0
            vertical: AppDimens.paddingM, // 12.0
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          ),
          side: BorderSide(
            color: colorScheme.primary,
            width: AppDimens.outlineButtonBorderWidth, // Updated: Use constant
          ),
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge, // Use appropriate text style
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
          textStyle: textTheme.labelLarge, // Use appropriate text style
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Updated: Use constant opacity
        fillColor: colorScheme.onSurface.withValues(
          alpha: AppDimens.opacityLight,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingXL, // 20.0
          vertical:
              AppDimens
                  .paddingL, // 16.0 (adjust if needed for text field height)
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          borderSide: BorderSide(
            // Updated: Use constant opacity
            color: colorScheme.onSurface.withValues(
              alpha: AppDimens.opacitySemi,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          borderSide: BorderSide(
            // Updated: Use constant opacity
            color: colorScheme.onSurface.withValues(
              alpha: AppDimens.opacitySemi,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12.0
          borderSide: BorderSide(
            color: colorScheme.primary,
            width:
                AppDimens
                    .elevationS, // 2.0 (Consider a specific border width constant?)
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
            width:
                AppDimens
                    .elevationS, // 2.0 (Consider a specific border width constant?)
          ),
        ),
        // Updated: Use constant opacity and textTheme
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: AppDimens.opacityHigh),
        ),
        // Updated: Use constant opacity and textTheme
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface.withValues(
            alpha: AppDimens.opacityMediumHigh,
          ),
        ),
        // Use textTheme
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
        // Use textTheme and primary color
        floatingLabelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600, // Make it stand out
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        // Updated: Use constant opacity
        color: colorScheme.onSurface.withValues(alpha: AppDimens.opacityMedium),
        thickness: AppDimens.dividerThickness, // 1.0
        space:
            AppDimens
                .dividerThickness, // 1.0 (Often better to use larger space like paddingS)
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: AppDimens.elevationXXL, // 24.0
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.radiusXL,
          ), // 20.0 (M3 default is 28)
        ),
        titleTextStyle:
            textTheme.headlineSmall, // Suitable style for dialog titles
        contentTextStyle: textTheme.bodyMedium, // Suitable for dialog content
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
        minLeadingWidth:
            AppDimens.iconL, // 24.0 (Adjust based on typical leading widget)
        minVerticalPadding: AppDimens.paddingL, // 16.0
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface, // Use onSurface
        titleTextStyle: textTheme.bodyLarge, // Match default text
        subtitleTextStyle: textTheme.bodyMedium, // Match default subtitle
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        // Updated: Use constant opacity
        selectedColor: colorScheme.primary.withValues(
          alpha: AppDimens.opacitySemi,
        ),
        secondarySelectedColor:
            colorScheme.primary, // Keep as primary for selected state
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM, // 12.0
          vertical: AppDimens.paddingS, // 8.0
        ),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface, // Use onSurface for unselected
        ),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color:
              colorScheme
                  .onPrimary, // Use onPrimary for selected (if secondarySelectedColor is primary)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.radiusXL,
          ), // 20.0 (M3 uses 8)
          side: BorderSide(
            // Updated: Use constant opacity
            color: colorScheme.primary.withValues(
              alpha: AppDimens.opacityMediumHigh,
            ),
          ),
        ),
        elevation:
            AppDimens.elevationNone, // Usually chips don't have elevation
        pressElevation: AppDimens.elevationXS, // Slight elevation on press
      ),

      // Icon theme
      iconTheme: IconThemeData(
        // Updated: Use constant opacity
        color: colorScheme.onSurface.withValues(
          alpha: AppDimens.opacityVeryHigh,
        ),
        size: AppDimens.iconL, // 24.0
      ),

      // Bottom navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface, // Can also use background
        selectedItemColor: colorScheme.primary,
        // Updated: Use constant opacity
        unselectedItemColor: colorScheme.onSurface.withValues(
          alpha: AppDimens.opacityUnselected,
        ),
        selectedLabelStyle: textTheme.labelSmall, // Use appropriate text style
        unselectedLabelStyle:
            textTheme.labelSmall, // Use appropriate text style
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimens.elevationL, // 8.0
      ),

      // Tab bar theme
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        // Updated: Use constant opacity
        unselectedLabelColor: colorScheme.onSurface.withValues(
          alpha: AppDimens.opacityHigh,
        ),
        labelStyle: textTheme.titleSmall, // Suitable style for tabs
        unselectedLabelStyle: textTheme.titleSmall,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.primary,
              width: AppDimens.tabIndicatorThickness, // Updated: Use constant
            ),
          ),
        ),
        // M3 uses indicatorSize: TabBarIndicatorSize.tab or .label
        // indicatorSize: TabBarIndicatorSize.label, // Example M3 style
        // indicatorColor: colorScheme.primary, // Example M3 style for indicator
        // overlayColor: MaterialStateProperty.all(colorScheme.primary.withValues(alpha:0.1)), // Ripple
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: AppDimens.elevationL,
        hoverElevation: AppDimens.elevationXL,
        focusElevation: AppDimens.elevationL,
        highlightElevation: AppDimens.elevationXL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ), // M3 default is 16
      ),
    );
  }
}

// Ensure the ColorAlpha extension from app_colors.dart is accessible
// or remove its usage if preferring standard .withValues(alpha:)
