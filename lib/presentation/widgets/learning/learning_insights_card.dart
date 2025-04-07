import 'package:flutter/material.dart';
// Import lại AppColors để sử dụng các màu ngữ nghĩa (success, warning, info)
// vì chúng không nằm trong ColorScheme gốc của Flutter.
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_insight.dart'; // Đảm bảo đường dẫn này đúng

/// Card widget hiển thị learning insights, sử dụng AppTheme đã được áp dụng.
class LearningInsightsCard extends StatelessWidget {
  final List<LearningInsightDTO> insights;
  final String? title;
  final VoidCallback? onViewMorePressed;
  final ThemeData? theme; // Optional theme override

  const LearningInsightsCard({
    super.key,
    required this.insights,
    this.title,
    this.onViewMorePressed,
    this.theme, // Added optional theme parameter
  });

  @override
  Widget build(BuildContext context) {
    // Sử dụng theme được truyền vào hoặc lấy từ context
    final currentTheme = theme ?? Theme.of(context);
    final colorScheme =
        currentTheme.colorScheme; // Truy cập ColorScheme cho tiện
    final textTheme = currentTheme.textTheme; // Truy cập TextTheme cho tiện

    // Sắp xếp và giới hạn insights
    final sortedInsights = List<LearningInsightDTO>.from(insights)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    final displayInsights =
        sortedInsights.length > 4
            ? sortedInsights.sublist(0, 4)
            : sortedInsights;

    return Card(
      // CardTheme (color, shape, elevation, etc.) được áp dụng tự động từ currentTheme.
      // Không cần set elevation và shape ở đây nữa vì Card widget sẽ tự lấy từ currentTheme.cardTheme.
      // elevation: currentTheme.cardTheme.elevation ?? AppDimens.elevationS, // Bỏ đi, Card tự xử lý
      // shape: currentTheme.cardTheme.shape ?? // Bỏ đi, Card tự xử lý
      //         RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(AppDimens.radiusL),
      //         ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Truyền theme vào header
            _buildHeader(currentTheme),
            const SizedBox(height: AppDimens.spaceS),
            // Divider sẽ tự động sử dụng màu từ currentTheme.dividerTheme
            const Divider(),
            const SizedBox(height: AppDimens.spaceS),
            if (displayInsights.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.paddingL,
                  ),
                  // Sử dụng text style và màu từ theme
                  child: Text(
                    'No insights available',
                    style: textTheme.bodyMedium?.copyWith(
                      // Sử dụng onSurfaceVariant hoặc màu onSurface với alpha giảm
                      color: colorScheme.onSurfaceVariant,
                      // Hoặc: color: colorScheme.onSurface.withValues(alpha:0.7), // Giữ nguyên cách cũ nếu muốn
                    ),
                  ),
                ),
              )
            else
              // Truyền theme vào item builder
              ...displayInsights.map(
                (insight) => _buildInsightItem(context, insight, currentTheme),
              ),
            if (onViewMorePressed != null && insights.length > 4) ...[
              const SizedBox(height: AppDimens.spaceS),
              Align(
                alignment: Alignment.centerRight,
                // TextButton sẽ tự động sử dụng style từ currentTheme.textButtonTheme
                child: TextButton(
                  onPressed: onViewMorePressed,
                  child: const Text('View More'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    // Sử dụng màu từ ColorScheme cho icon header.
    // Chọn màu phù hợp với ngữ nghĩa của icon (ví dụ: tertiary, secondary hoặc info)
    final Color headerIconColor =
        theme.colorScheme.tertiary; // Ví dụ dùng màu tertiary

    return Row(
      children: [
        Icon(
          Icons.lightbulb_outline,
          color: headerIconColor, // Sử dụng màu từ theme
          size: AppDimens.iconM,
        ),
        const SizedBox(width: AppDimens.spaceS),
        // Sử dụng text style từ theme
        Text(
          title ?? 'Learning Insights',
          // Đảm bảo style phù hợp và có màu rõ ràng trên nền card
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem(
    BuildContext context,
    LearningInsightDTO insight,
    ThemeData theme,
  ) {
    // Lấy màu và icon sử dụng theme
    // _getColorFromString giờ đây sẽ lấy màu ngữ nghĩa từ AppColors dựa trên theme
    final Color color = _getColorFromString(insight.color, theme);
    final IconData icon = _getIconFromString(insight.icon);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color, // Sử dụng màu đã được xử lý qua theme
            size: AppDimens.iconM,
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            // Sử dụng text style từ theme
            child: Text(
              insight.message,
              // Đảm bảo style phù hợp và có màu rõ ràng
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Ánh xạ tên màu sang màu dựa trên theme, bao gồm các màu ngữ nghĩa từ AppColors.
  Color _getColorFromString(String colorName, ThemeData theme) {
    final bool isDark = theme.brightness == Brightness.dark;

    switch (colorName.toLowerCase()) {
      // Lấy màu trực tiếp từ ColorScheme của theme
      case 'primary':
      case 'blue': // Giả sử blue thường là primary
        return theme.colorScheme.primary;
      case 'secondary':
      case 'purple': // Giả sử purple thường là secondary
        return theme.colorScheme.secondary;
      case 'tertiary':
        return theme.colorScheme.tertiary;
      case 'error':
      case 'red': // Giả sử red là error
        return theme.colorScheme.error;
      case 'surface':
        return theme.colorScheme.surface;
      case 'onSurface':
        return theme.colorScheme.onSurface;
      case 'neutral':
        return theme
            .colorScheme
            .onSurfaceVariant; // Dùng onSurfaceVariant cho neutral

      // Lấy các màu ngữ nghĩa từ AppColors (đã định nghĩa trong theme tổng)
      case 'success':
      case 'green':
      case 'teal': // Giả sử teal map sang success/green
        return isDark ? AppColors.successDark : AppColors.successLight;
      case 'warning':
      case 'orange':
      case 'amber':
        return isDark ? AppColors.warningDark : AppColors.warningLight;
      case 'info':
      case 'indigo':
        return isDark ? AppColors.infoDark : AppColors.infoLight;

      // Màu dự phòng
      default:
        return theme
            .colorScheme
            .onSurfaceVariant; // Fallback dùng màu trung tính hơn
      // return theme.colorScheme.onSurface.withValues(alpha:0.7); // Hoặc giữ nguyên cách cũ
    }
  }

  /// Ánh xạ tên icon sang IconData (giữ nguyên)
  IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      // Đã có toLowerCase
      case 'trending_up':
        return Icons.trending_up;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'menu_book':
        return Icons.menu_book;
      case 'today':
        return Icons.today;
      case 'check_circle':
        return Icons.check_circle;
      case 'star':
        return Icons.star;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'info':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      default:
        return Icons.info_outline; // Default fallback icon
    }
  }
}

// Assume LearningInsightDTO structure remains the same:
/*
class LearningInsightDTO {
  final String message;
  final String color; // e.g., 'primary', 'red', 'warning', 'success'
  final String icon;  // e.g., 'trending_up', 'error', 'lightbulb'
  final int priority;
  // ... other fields

  LearningInsightDTO({
    required this.message,
    required this.color,
    required this.icon,
    required this.priority,
  });
}
*/
