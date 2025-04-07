import 'package:flutter/material.dart';
// Import AppColors để sử dụng màu semantic (success, warning)
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Widget to display learning insights on the home screen using AppTheme.
class LearningInsightsWidget extends StatelessWidget {
  final double vocabularyRate;
  final int streakDays;
  final int pendingWords;
  final int dueToday;
  final ThemeData? theme; // Optional theme override

  const LearningInsightsWidget({
    super.key,
    required this.vocabularyRate,
    required this.streakDays,
    required this.pendingWords,
    required this.dueToday,
    this.theme, // Added optional theme parameter
  });

  @override
  Widget build(BuildContext context) {
    // Sử dụng theme được truyền vào hoặc lấy từ context
    final currentTheme = theme ?? Theme.of(context);
    // Lấy các thành phần theme cần thiết một lần
    final colorScheme = currentTheme.colorScheme;
    final textTheme = currentTheme.textTheme;
    final isDark = currentTheme.brightness == Brightness.dark;

    return Card(
      // CardTheme được áp dụng tự động
      margin: EdgeInsets.zero, // Giữ margin tùy chỉnh
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Các hàm build không cần truyền theme nữa
            _buildHeader(colorScheme, textTheme),
            const SizedBox(height: AppDimens.spaceM),
            // Divider tự lấy theme
            const Divider(),
            const SizedBox(height: AppDimens.spaceS),
            // Truyền các thành phần theme cần thiết vào list builder
            _buildInsightsList(context, colorScheme, textTheme, isDark),
          ],
        ),
      ),
    );
  }

  // Loại bỏ tham số theme, nhận colorScheme và textTheme
  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Icon(
          Icons.insights_outlined, // Cân nhắc dùng icon outlined
          // Dùng màu tertiary từ theme
          color: colorScheme.tertiary,
          size: AppDimens.iconM,
        ),
        const SizedBox(width: AppDimens.spaceS),
        // Dùng text style từ theme và đặt màu rõ ràng
        Text(
          'Learning Insights',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface, // Đảm bảo màu chữ trên nền Card
          ),
        ),
      ],
    );
  }

  // Loại bỏ tham số theme, nhận các thành phần theme cần thiết
  Widget _buildInsightsList(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDark,
  ) {
    // Define semantic colors using the theme's color scheme and AppColors
    final Color rateColor = colorScheme.secondary; // OK
    // Sửa lỗi màu cứng: Dùng AppColors (có dark/light) cho warning/streak
    final Color streakColor =
        isDark
            ? AppColors.warningDark
            : AppColors.warningLight; // Hoặc dùng tertiary nếu muốn
    // Sửa lỗi màu cứng: Dùng AppColors (có dark/light) cho success/pending
    final Color pendingColor =
        isDark ? AppColors.successDark : AppColors.successLight;
    final Color dueColor = colorScheme.primary; // OK

    return Column(
      children: [
        _buildInsightItem(
          context,
          textTheme, // Chỉ cần textTheme
          colorScheme, // Truyền colorScheme để lấy onSurfaceVariant
          'You learn ${vocabularyRate.toStringAsFixed(1)}% new vocabulary each week',
          Icons.trending_up,
          rateColor, // Màu đã được xác định từ theme
        ),
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'Your current streak is $streakDays days - keep going!',
          Icons.local_fire_department_outlined, // Outlined icon
          streakColor, // Màu warning từ AppColors (theo theme)
        ),
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'You have $pendingWords words pending to learn',
          Icons.hourglass_empty_outlined, // Icon khác?
          pendingColor, // Màu success từ AppColors (theo theme)
        ),
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'Complete today\'s $dueToday sessions to maintain your streak',
          Icons.today_outlined, // Outlined icon
          dueColor, // Màu primary từ theme
        ),
      ],
    );
  }

  // Loại bỏ tham số theme, nhận textTheme và colorScheme
  Widget _buildInsightItem(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme, // Nhận colorScheme để lấy màu text phụ
    String message,
    IconData icon,
    Color color, // Màu nhấn cho icon (đã được xác định ở trên)
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingM,
      ), // Tăng padding dọc
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn trên nếu text dài
        children: [
          // Dùng màu nhấn cho icon
          Icon(icon, color: color, size: AppDimens.iconM),
          const SizedBox(width: AppDimens.spaceM), // Tăng khoảng cách
          Expanded(
            // Dùng text style từ theme và đặt màu phụ rõ ràng
            child: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant, // Dùng màu phụ cho text
              ),
            ),
          ),
        ],
      ),
    );
  }
}
