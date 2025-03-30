// lib/core/extensions/color_extensions.dart
import 'package:flutter/material.dart';

/// Extensions on Color for easier manipulation
extension ColorExtensions on Color {
  /// Creates a color with the specified opacity value
  Color withValues({int? red, int? green, int? blue, double? alpha}) {
    return Color.fromRGBO(
      red ?? (this.red * 255.0).round() & 0xff,
      green ?? (this.green * 255.0).round() & 0xff,
      blue ?? (this.blue * 255.0).round() & 0xff,
      alpha ?? opacity,
    );
  }

  /// Returns a lighter version of this color
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Returns a darker version of this color
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }
}
