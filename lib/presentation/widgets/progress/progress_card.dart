import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

/// A card widget displaying progress summary for a module, styled with AppTheme.
class ProgressCard extends StatelessWidget {
  final ProgressSummary progress;
  final String moduleTitle;
  final bool isDue;
  final String? subtitle;
  final VoidCallback? onTap;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.moduleTitle,
    this.isDue = false,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy theme và colorScheme một lần ở đây
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme; // Lấy cả textTheme nếu dùng nhiều

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: AppDimens.spaceXS,
        horizontal: AppDimens.spaceXXS,
      ),
      // Màu nền Card thay đổi dựa trên isDue, sử dụng màu từ theme
      color: isDue ? colorScheme.surfaceDim : colorScheme.surface,
      // CardTheme (shape, elevation) sẽ được áp dụng tự động
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppDimens.radiusL,
        ), // Đồng bộ bo góc với Card (nếu Card có)
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Các hàm build không cần truyền theme nữa
              _buildHeaderRow(colorScheme, textTheme),
              if (progress.repetitionCount > 0) ...[
                const SizedBox(height: AppDimens.spaceS),
                _buildRepetitionCountBadge(colorScheme, textTheme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the header row with progress indicator and details
  // Loại bỏ tham số theme không cần thiết
  Widget _buildHeaderRow(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressIndicator(colorScheme), // Truyền colorScheme
        const SizedBox(width: AppDimens.spaceL),
        // Truyền colorScheme và textTheme vào _buildProgressDetails
        _buildProgressDetails(colorScheme, textTheme),
        if (isDue) _buildDueIndicator(colorScheme), // Truyền colorScheme
      ],
    );
  }

  /// Builds the circular progress indicator
  // Loại bỏ tham số theme
  Widget _buildProgressIndicator(ColorScheme colorScheme) {
    return SizedBox(
      width: AppDimens.circularProgressSizeL,
      height: AppDimens.circularProgressSizeL,
      child: CircularProgressIndicator(
        value: progress.percentComplete / 100,
        // Dùng màu nền phù hợp từ theme
        backgroundColor: colorScheme.surfaceContainerHighest,
        strokeWidth: AppDimens.lineProgressHeight,
        // Màu của tiến trình (value) là màu primary
        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
      ),
    );
  }

  /// Builds the module title and progress details
  // Loại bỏ tham số theme, nhận colorScheme và textTheme
  Widget _buildProgressDetails(ColorScheme colorScheme, TextTheme textTheme) {
    final dateFormat = DateFormat('MMM dd, yyyy'); // Định dạng ngày tháng
    final nextStudyText =
        progress.nextStudyDate != null
            ? dateFormat.format(progress.nextStudyDate!)
            : 'Not scheduled';

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            moduleTitle,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface, // Đặt màu rõ ràng
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimens.spaceXS),
            Text(
              subtitle!,
              style: textTheme.bodyMedium?.copyWith(
                color:
                    colorScheme.onSurfaceVariant, // Đặt màu rõ ràng cho phụ đề
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            'Next study: $nextStudyText',
            style: textTheme.bodySmall?.copyWith(
              // Màu và font weight thay đổi dựa trên isDue, dùng màu theme
              color: isDue ? colorScheme.primary : colorScheme.onSurfaceVariant,
              fontWeight: isDue ? FontWeight.bold : null,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            'Progress: ${progress.percentComplete.toInt()}%',
            // Dùng màu phụ cho thông tin này
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the due indicator icon
  // Loại bỏ tham số theme, nhận colorScheme
  Widget _buildDueIndicator(ColorScheme colorScheme) {
    // Dùng màu error từ theme cho icon cảnh báo
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.spaceS,
      ), // Thêm padding nếu cần
      child: Icon(Icons.notifications_active, color: colorScheme.error),
    );
  }

  /// Builds the repetition count badge
  // Loại bỏ tham số theme, nhận colorScheme và textTheme
  Widget _buildRepetitionCountBadge(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS,
        vertical: AppDimens.paddingXS,
      ),
      decoration: BoxDecoration(
        // Dùng màu nền container từ theme
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimens.radiusXS),
      ),
      child: Text(
        'Repetitions: ${progress.repetitionCount}',
        style: textTheme.bodySmall?.copyWith(
          // Dùng màu onSurfaceVariant cho text trên nền surfaceContainerHigh
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

// Giả định ProgressSummary model
/*
class ProgressSummary {
  final double percentComplete;
  final DateTime? nextStudyDate;
  final int repetitionCount;

  ProgressSummary({
    required this.percentComplete,
    this.nextStudyDate,
    required this.repetitionCount,
  });
}
*/
