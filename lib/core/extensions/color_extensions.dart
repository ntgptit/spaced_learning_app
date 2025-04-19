import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';

extension ColorExtensions on Color {
  /// Tạo biến thể của màu với độ trong suốt tùy chỉnh
  Color withValues({int? red, int? green, int? blue, double? alpha}) {
    return Color.fromRGBO(
      red ?? (this.red * 255.0).round() & 0xff,
      green ?? (this.green * 255.0).round() & 0xff,
      blue ?? (this.blue * 255.0).round() & 0xff,
      alpha ?? opacity,
    );
  }

  /// Tạo màu sáng hơn
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Tạo màu tối hơn
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Tạo biến thể màu với độ bão hòa khác
  Color withSaturation(double saturation) {
    assert(saturation >= 0 && saturation <= 1);

    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation(saturation).toColor();
  }

  /// Tăng độ bão hòa của màu
  Color saturate([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final saturation = (hsl.saturation + amount).clamp(0.0, 1.0);

    return hsl.withSaturation(saturation).toColor();
  }

  /// Giảm độ bão hòa của màu
  Color desaturate([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final saturation = (hsl.saturation - amount).clamp(0.0, 1.0);

    return hsl.withSaturation(saturation).toColor();
  }
}

extension CustomColorScheme on ColorScheme {
  /// Màu thành công (success) - Sử dụng màu xanh lá của Google
  Color get success => GeminiColors.successGreen;

  /// Màu chữ trên nền success
  Color get onSuccess => Colors.white;

  /// Màu container cho success
  Color get successContainer => const Color(0xFFE0F2E3);

  /// Màu chữ trên nền successContainer
  Color get onSuccessContainer => const Color(0xFF00472A);

  /// Màu cảnh báo (warning) - Sử dụng màu vàng/cam của Google
  Color get warning => GeminiColors.warningOrange;

  /// Màu chữ trên nền warning
  Color get onWarning => Colors.black;

  /// Màu container cho warning
  Color get warningContainer => const Color(0xFFFFF0D3);

  /// Màu chữ trên nền warningContainer
  Color get onWarningContainer => const Color(0xFF3D2900);

  /// Màu thông tin (info) - Sử dụng màu xanh dương của Google
  Color get info => GeminiColors.infoBlue;

  /// Màu chữ trên nền info
  Color get onInfo => Colors.white;

  /// Màu container cho info
  Color get infoContainer => GeminiColors.paleBlue;

  /// Màu chữ trên nền infoContainer
  Color get onInfoContainer => const Color(0xFF002D56);
}
