import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';

extension ColorExtensions on Color {
  /// Creates a variant of the color with custom transparency
  Color withValues({int? red, int? green, int? blue, double? alpha}) {
    return Color.fromRGBO(
      red ?? (r * 255.0).round() & 0xff,
      green ?? (g * 255.0).round() & 0xff,
      blue ?? (b * 255.0).round() & 0xff,
      alpha ?? a,
    );
  }

  /// Creates a lighter version of the color
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Creates a darker version of the color
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Creates a color variant with a different saturation level
  Color withSaturation(double saturation) {
    assert(saturation >= 0 && saturation <= 1);

    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation(saturation).toColor();
  }

  /// Increases the saturation of the color
  Color saturate([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final saturation = (hsl.saturation + amount).clamp(0.0, 1.0);

    return hsl.withSaturation(saturation).toColor();
  }

  /// Decreases the saturation of the color
  Color desaturate([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final saturation = (hsl.saturation - amount).clamp(0.0, 1.0);

    return hsl.withSaturation(saturation).toColor();
  }
}

extension CustomColorScheme on ColorScheme {
  /// Success color - Uses Google's green shade
  Color get success => successGreen; // Defined in app_color_scheme.dart

  /// Text/icon color on success background
  Color get onSuccess => Colors.white;

  /// Container color for success
  Color get successContainer =>
      const Color(0xFFE0F2E3); // Light green container

  /// Text/icon color on success container
  Color get onSuccessContainer => const Color(0xFF00472A); // Dark green text

  /// Warning color - Uses Google's yellow/orange shade
  Color get warning => warningOrange; // Defined in app_color_scheme.dart

  /// Text/icon color on warning background
  Color get onWarning => Colors.black;

  /// Container color for warning
  Color get warningContainer =>
      const Color(0xFFFFF0D3); // Light orange container

  /// Text/icon color on warning container
  Color get onWarningContainer => const Color(0xFF3D2900); // Dark orange text

  /// Info color - Uses blue shade from geminiLightColorScheme
  Color get info =>
      geminiLightColorScheme.primary; // 0xff65558f (light primary)

  /// Text/icon color on info background
  Color get onInfo => Colors.white;

  /// Container color for info
  Color get infoContainer =>
      geminiLightColorScheme.primaryContainer; // 0xffe9ddff

  /// Text/icon color on info container
  Color get onInfoContainer =>
      geminiLightColorScheme.onPrimaryContainer; // 0xff4d3d75
}
