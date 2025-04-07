import 'package:flutter/material.dart';
// Assuming AppDimens and ColorAlpha extension are available
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

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
    // GridView cấu hình đã ổn
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppDimens.gridSpacingL,
      mainAxisSpacing: AppDimens.gridSpacingL,
      childAspectRatio: 1.1, // Giữ nguyên hoặc điều chỉnh nếu cần
      children: _buildActionItems(context),
    );
  }

  // Build the list of action cards using theme colors without unnecessary alpha
  List<Widget> _buildActionItems(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define actions using theme colors directly
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'Browse Books',
        'icon': Icons.menu_book_outlined,
        'onTap': onBrowseBooksPressed,
        'contentColor': colorScheme.primary, // OK
      },
      {
        'title': 'Today\'s Learning',
        'icon': Icons.assignment_turned_in_outlined,
        'onTap': onTodaysLearningPressed,
        'contentColor': colorScheme.secondary, // OK
      },
      {
        'title': 'Progress Report',
        'icon': Icons.bar_chart_outlined,
        'onTap': onProgressReportPressed,
        // Dùng tertiary trực tiếp, không cần alpha
        'contentColor': colorScheme.tertiary,
      },
      {
        'title': 'Vocabulary Stats',
        'icon': Icons.translate_outlined, // Hoặc Icons.assessment_outlined
        'onTap': onVocabularyStatsPressed,
        // Thay thế error bằng một màu khác phù hợp hơn, ví dụ tertiary hoặc secondary
        'contentColor':
            colorScheme
                .tertiary, // Sử dụng lại tertiary (hoặc secondary nếu muốn)
      },
    ];

    // Map action data to widgets
    return actions.map((action) {
      return _buildActionCard(
        context,
        title: action['title'] as String,
        icon: action['icon'] as IconData,
        onTap: action['onTap'] as VoidCallback,
        // Pass the direct theme-based content color
        contentColor: action['contentColor'] as Color,
      );
    }).toList();
  }

  /// Builds a single action card with theme-aware styling (M3 compliant).
  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color contentColor, // Use this for icon and text directly
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      // Card sẽ tự lấy elevation và shape từ CardTheme trong AppTheme
      // Nếu muốn override, có thể làm ở đây, nhưng nên định nghĩa trong AppTheme
      // elevation: AppDimens.elevationS, // Có thể bỏ nếu cardTheme đã định nghĩa
      // Sử dụng màu nền container M3 đục, không dùng alpha
      color: colorScheme.surfaceContainerHighest, // Màu nền tách biệt nhẹ nhàng
      // shape: RoundedRectangleBorder( // Có thể bỏ nếu cardTheme đã định nghĩa shape
      //   borderRadius: BorderRadius.circular(AppDimens.radiusM),
      //   // Bỏ border sử dụng alpha
      //   // side: BorderSide.none, // Hoặc dùng outlineVariant nếu muốn
      // ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        // borderRadius nên khớp với shape của Card
        borderRadius:
            (theme.cardTheme.shape is RoundedRectangleBorder
                ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                    as BorderRadius?
                : null) ??
            BorderRadius.circular(
              AppDimens.radiusM,
            ), // Lấy từ theme hoặc fallback
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimens.iconXL,
                // Dùng contentColor trực tiếp
                color: contentColor,
              ),
              const SizedBox(
                height: AppDimens.spaceM,
              ), // Tăng khoảng cách một chút
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  // Dùng titleSmall có thể hợp lý hơn cho card nhỏ
                  // Dùng contentColor trực tiếp, không cần alpha
                  color: contentColor,
                  fontWeight: FontWeight.w600, // Tăng độ đậm nếu muốn
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

// Giả định extension ColorAlpha đã được định nghĩa ở AppColors
// extension ColorAlpha on Color { ... }
