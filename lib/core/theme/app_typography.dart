import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography definitions for the app
class AppTypography {
  // Creates text themes based on the brightness
  static TextTheme getTextTheme(Brightness brightness) {
    final baseTextTheme = GoogleFonts.rubikTextTheme();
    final isLight = brightness == Brightness.light;
    final textColor = isLight ? Colors.black87 : Colors.white;

    return TextTheme(
      // Display styles
      displayLarge: baseTextTheme.displayLarge!.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: textColor,
      ),
      displayMedium: baseTextTheme.displayMedium!.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displaySmall: baseTextTheme.displaySmall!.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      // Headline styles
      headlineLarge: baseTextTheme.headlineLarge!.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      headlineMedium: baseTextTheme.headlineMedium!.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      headlineSmall: baseTextTheme.headlineSmall!.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      // Title styles
      titleLarge: baseTextTheme.titleLarge!.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleMedium: baseTextTheme.titleMedium!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: textColor,
      ),
      titleSmall: baseTextTheme.titleSmall!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textColor,
      ),

      // Body styles
      bodyLarge: baseTextTheme.bodyLarge!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: textColor,
      ),
      bodyMedium: baseTextTheme.bodyMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textColor,
      ),
      bodySmall: baseTextTheme.bodySmall!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: textColor.withOpacity(0.8),
      ),

      // Label styles
      labelLarge: baseTextTheme.labelLarge!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textColor,
      ),
      labelMedium: baseTextTheme.labelMedium!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textColor,
      ),
      labelSmall: baseTextTheme.labelSmall!.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textColor,
      ),
    );
  }
}
