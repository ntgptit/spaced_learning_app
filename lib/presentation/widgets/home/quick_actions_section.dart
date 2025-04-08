import 'package:flutter/material.dart';
// Assuming AppDimens is available
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

// Bỏ M3ColorPair typedef nếu không dùng ở đâu khác

/// Widget for displaying quick action buttons on the home screen, styled with AppTheme.
class QuickActionsSection extends StatelessWidget {
  final VoidCallback onBrowseBooksPressed;
  final VoidCallback onTodaysLearningPressed;
  final VoidCallback onProgressReportPressed;
  final VoidCallback onVocabularyStatsPressed;

  const QuickActionsSection({
    super.key,
    required this.onBrowseBooksPressed,
    required this.onTodaysLearningPressed,
    required this.onProgressReportPressed,
    required this.onVocabularyStatsPressed,
  });

  @override
  Widget build(BuildContext context) {
    // GridView configuration seems fine
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppDimens.gridSpacingL,
      mainAxisSpacing: AppDimens.gridSpacingL,
      childAspectRatio: 1.1, // Adjust if needed
      children: _buildActionItems(context),
    );
  }

  // Build the list of action cards with uniform background and distinct content colors
  List<Widget> _buildActionItems(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define actions, specifying the content color for icon/text for each
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'Browse Books',
        'icon': Icons.menu_book_outlined,
        'onTap': onBrowseBooksPressed,
        // Màu nội dung (icon & text) là Primary
        'contentColor': colorScheme.primary,
      },
      {
        'title': 'Today\'s Learning',
        'icon': Icons.assignment_turned_in_outlined,
        'onTap': onTodaysLearningPressed,
        // Màu nội dung (icon & text) là Secondary
        'contentColor': colorScheme.secondary,
      },
      {
        'title': 'Progress Report',
        'icon': Icons.bar_chart_outlined,
        'onTap': onProgressReportPressed,
        // Màu nội dung (icon & text) là Tertiary
        'contentColor': colorScheme.error,
      },
      {
        'title': 'Vocabulary Stats',
        'icon': Icons.translate_outlined, // Or Icons.assessment_outlined
        'onTap': onVocabularyStatsPressed,
        // Chọn màu cho action thứ 4.
        // Có thể dùng lại Tertiary, hoặc Primary/Secondary nếu muốn.
        // Dùng lại Tertiary là lựa chọn phổ biến và an toàn.
        'contentColor': colorScheme.onSecondaryContainer,
      },
    ];

    // Map action data to widgets
    return actions.map((action) {
      return _buildActionCard(
        context,
        title: action['title'] as String,
        icon: action['icon'] as IconData,
        onTap: action['onTap'] as VoidCallback,
        // Pass the specific content color for this card
        contentColor: action['contentColor'] as Color,
      );
    }).toList();
  }

  /// Builds a single action card with a uniform light background
  /// and specific content color for icon/text.
  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color contentColor, // Màu này sẽ áp dụng cho Icon và Text
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Lấy bo góc từ CardTheme hoặc fallback
    final borderRadius =
        (theme.cardTheme.shape is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                as BorderRadius?
            : null) ??
        BorderRadius.circular(AppDimens.radiusM); // Use AppDimens if needed

    return Card(
      // Elevation và shape sẽ được lấy từ CardTheme (do FlexColorScheme cấu hình)
      // elevation: theme.cardTheme.elevation,
      // shape: theme.cardTheme.shape,

      // *** THAY ĐỔI CHÍNH: Sử dụng màu nền sáng, đồng nhất cho tất cả Card ***
      // surfaceContainerHighest là lựa chọn tốt, tách biệt nhẹ nhàng khỏi nền chính.
      // Các lựa chọn khác: surfaceContainerLow, surfaceContainer, surface.
      color: colorScheme.surfaceContainerHighest,
      clipBehavior: Clip.antiAlias, // Tốt cho InkWell
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius, // Đảm bảo khớp với shape của Card
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimens.iconXL,
                // *** Áp dụng màu nội dung được truyền vào cho Icon ***
                color: contentColor,
              ),
              const SizedBox(height: AppDimens.spaceM),
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  // Hoặc bodyLarge tùy thẩm mỹ
                  // *** Áp dụng màu nội dung được truyền vào cho Text ***
                  color: contentColor,
                  // fontWeight: FontWeight.w600, // Bỏ hoặc giữ tùy thuộc vào theme
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
