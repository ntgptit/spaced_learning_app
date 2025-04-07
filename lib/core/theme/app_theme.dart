import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/core/theme/app_typography.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    const colorScheme = ColorScheme(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      tertiary: AppColors.lightTertiary,
      tertiaryContainer: AppColors.lightTertiaryContainer,
      surface: AppColors.lightSurface,
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onTertiary: AppColors.lightOnTertiary,
      onSurface: AppColors.lightOnSurface,
      onError: AppColors.lightOnError,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      outline: AppColors.lightOutline,
      brightness: Brightness.light,
      inverseSurface: AppColors.black,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.lightPrimaryVariant,
      shadow: Colors.black,
      scrim: Colors.black54,
    );

    return _createTheme(colorScheme);
  }

  static ThemeData getDarkTheme() {
    const colorScheme = ColorScheme(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      surface: AppColors.darkSurface,
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onTertiary: AppColors.darkOnTertiary,
      onSurface: AppColors.darkOnSurface,
      onError: AppColors.darkOnError,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOutline,
      brightness: Brightness.dark,
      inverseSurface: AppColors.white,
      onInverseSurface: AppColors.black,
      inversePrimary: AppColors.darkPrimaryVariant,
      shadow: Colors.black,
      scrim: Colors.black54,
    );

    return _createTheme(colorScheme);
  }

  static ThemeData _createTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = AppTypography.getTextTheme(colorScheme.brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: AppDimens.elevationS,
        centerTitle: false,
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerHighest
                : AppColors.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge,
        shadowColor: isDark ? Colors.black26 : Colors.black12,
        iconTheme: IconThemeData(
          color:
              isDark ? AppColors.iconPrimaryDark : AppColors.iconPrimaryLight,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: AppDimens.elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ),
        color:
            isDark
                ? AppColors.darkSurfaceContainerLow
                : AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
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
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
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
            color: colorScheme.primary,
            width: AppDimens.outlineButtonBorderWidth,
          ),
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppDimens.elevationS,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppDimens.dividerThickness,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppDimens.elevationS,
          ),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: AppDimens.opacityHigh),
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface.withValues(
            alpha: AppDimens.opacityMediumHigh,
          ),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
        floatingLabelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        thickness: AppDimens.dividerThickness,
        space: AppDimens.dividerThickness,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerHighest
                : AppColors.surfaceContainerLowest,
        elevation: AppDimens.elevationXXL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
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
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerLow
                : AppColors.surfaceContainerLow,
        selectedColor: colorScheme.primary.withValues(
          alpha: AppDimens.opacitySemi,
        ),
        secondarySelectedColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingS,
        ),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          side: BorderSide(
            color: colorScheme.primary.withValues(
              alpha: AppDimens.opacityMediumHigh,
            ),
          ),
        ),
        elevation: AppDimens.elevationNone,
        pressElevation: AppDimens.elevationXS,
      ),
      iconTheme: IconThemeData(
        color: isDark ? AppColors.iconPrimaryDark : AppColors.iconPrimaryLight,
        size: AppDimens.iconL,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerHighest
                : AppColors.surfaceContainerHighest,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(
          alpha: AppDimens.opacityUnselected,
        ),
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimens.elevationL,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withValues(
          alpha: AppDimens.opacityHigh,
        ),
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.primary,
              width: AppDimens.tabIndicatorThickness,
            ),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: AppDimens.elevationL,
        hoverElevation: AppDimens.elevationXL,
        focusElevation: AppDimens.elevationL,
        highlightElevation: AppDimens.elevationXL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusCircular),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primary.withValues(
          alpha: AppDimens.opacitySemi,
        ),
        circularTrackColor: colorScheme.primary.withValues(
          alpha: AppDimens.opacitySemi,
        ),
        refreshBackgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerLow
                : AppColors.surfaceContainerLow,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceContainerHighest
                : AppColors.neutralDark,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
        ),
        actionTextColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color:
              isDark
                  ? AppColors.darkSurfaceContainerHighest
                  : AppColors.neutralDark,
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.white,
        ),
      ),
    );
  }
}
