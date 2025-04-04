import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart'; // Import AppDimens

class AppTypography {
  static TextTheme getTextTheme(Brightness brightness) {
    final baseTextTheme = GoogleFonts.interTextTheme();
    final isLight = brightness == Brightness.light;
    final textColor = isLight ? Colors.black87 : Colors.white;

    return TextTheme(
      // Display styles
      displayLarge: baseTextTheme.displayLarge!.copyWith(
        fontSize: AppDimens.fontDisplayL, // 57.0
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: textColor,
        height: 1.2,
      ),
      displayMedium: baseTextTheme.displayMedium!.copyWith(
        fontSize: AppDimens.fontDisplayM, // 45.0
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.2,
      ),
      displaySmall: baseTextTheme.displaySmall!.copyWith(
        fontSize: AppDimens.fontDisplayS, // 36.0
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.2,
      ),

      // Headline styles
      headlineLarge: baseTextTheme.headlineLarge!.copyWith(
        fontSize: AppDimens.fontHeadlineL, // 32.0
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.25,
      ),
      headlineMedium: baseTextTheme.headlineMedium!.copyWith(
        fontSize: AppDimens.fontHeadlineM, // 28.0
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.25,
      ),
      headlineSmall: baseTextTheme.headlineSmall!.copyWith(
        fontSize: AppDimens.fontHeadlineS, // 24.0
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.25,
      ),

      // Title styles
      titleLarge: baseTextTheme.titleLarge!.copyWith(
        fontSize: AppDimens.fontTitle, // 22.0
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleMedium: baseTextTheme.titleMedium!.copyWith(
        fontSize: AppDimens.fontXL, // 16.0
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: textColor,
      ),
      titleSmall: baseTextTheme.titleSmall!.copyWith(
        fontSize: AppDimens.fontL, // 14.0
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textColor,
      ),

      // Body styles
      bodyLarge: baseTextTheme.bodyLarge!.copyWith(
        fontSize: AppDimens.fontXL, // 16.0
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: baseTextTheme.bodyMedium!.copyWith(
        fontSize: AppDimens.fontL, // 14.0
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textColor,
        height: 1.5,
      ),
      bodySmall: baseTextTheme.bodySmall!.copyWith(
        fontSize: AppDimens.fontM, // 12.0
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: textColor.withValues(alpha: 0.9),
        height: 1.5,
      ),

      // Label styles with improved readability
      labelLarge: baseTextTheme.labelLarge!.copyWith(
        fontSize: AppDimens.fontL, // 14.0
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textColor,
      ),
      labelMedium: baseTextTheme.labelMedium!.copyWith(
        fontSize: AppDimens.fontM, // 12.0
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: textColor,
      ),
      labelSmall: baseTextTheme.labelSmall!.copyWith(
        fontSize: AppDimens.fontS, // 11.0
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: textColor,
      ),
    );
  }
}
