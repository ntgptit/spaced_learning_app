import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';

class ThemeHelpers {
  /// Lấy màu score dựa trên giá trị điểm và theme hiện tại
  static Color getScoreColor(double score, ColorScheme colorScheme) {
    if (score >= 90) return Colors.green.shade700;
    if (score >= 75) return colorScheme.primary;
    if (score >= 60) return colorScheme.secondary;
    if (score >= 40) return Colors.orange.shade700;
    return colorScheme.error;
  }

  /// Lấy màu text có độ tương phản tốt với màu nền đã cho
  static Color getContrastTextColor(Color backgroundColor) {
    // Tính độ sáng của màu
    final brightness = backgroundColor.computeLuminance();
    // Nếu màu nền tối, trả về màu text sáng và ngược lại
    return brightness > 0.5 ? Colors.black : Colors.white;
  }

  /// Tạo background màu nhạt dựa trên màu chính
  static Color getLightBackgroundColor(Color color, {double alpha = 0.2}) {
    return color.withValues(alpha: alpha);
  }

  /// Lấy màu dựa trên trạng thái hoàn thành
  static Color getCompletionColor(
    bool isCompleted,
    bool isOverdue,
    ColorScheme colorScheme,
  ) {
    if (isOverdue) return colorScheme.error;
    if (isCompleted) return colorScheme.success;
    return colorScheme.primary;
  }
}
