// lib/presentation/widgets/module_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Giả định theme-aware
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart'; // Giả định theme-aware
import 'package:spaced_learning_app/presentation/widgets/common/app_progress_indicator.dart'; // Giả định theme-aware

class ModuleCard extends StatelessWidget {
  final ModuleSummary module;
  final double? progress; // Progress value between 0.0 and 1.0
  final VoidCallback? onTap;
  final VoidCallback? onStudyPressed;

  const ModuleCard({
    super.key,
    required this.module,
    this.progress,
    this.onTap,
    this.onStudyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Validate progress value
    final validProgress = progress?.clamp(0.0, 1.0);

    return AppCard(
      onTap: onTap,
      title: Text(
        'Module ${module.moduleNo}: ${module.title}',
        style: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface, // Đặt màu rõ ràng cho title
        ),
        maxLines: 2, // Giới hạn dòng cho tiêu đề dài
        overflow: TextOverflow.ellipsis,
      ),
      leading: Container(
        width: AppDimens.avatarSizeL,
        height: AppDimens.avatarSizeL,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer, // Nền container M3
          borderRadius: BorderRadius.circular(AppDimens.radiusM), // Bo góc
        ),
        child: Center(
          child: Text(
            '${module.moduleNo}',
            style: textTheme.titleLarge!.copyWith(
              color:
                  colorScheme
                      .onPrimaryContainer, // Màu chữ trên nền container M3
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      subtitle:
          module.wordCount != null && module.wordCount! > 0
              ? Text(
                '${module.wordCount} words',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant, // Màu phụ M3
                ),
              )
              : null,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chỉ hiển thị phần progress nếu progress có giá trị hợp lệ
          if (validProgress != null) ...[
            const SizedBox(
              height: AppDimens.spaceL,
            ), // Khoảng cách trước progress
            Row(
              children: [
                Expanded(
                  // Giả định AppProgressIndicator tự lấy màu value từ theme (primary)
                  child: AppProgressIndicator(
                    type: ProgressType.linear,
                    value: validProgress,
                    strokeWidth: AppDimens.lineProgressHeightL,
                    // Màu nền track lấy từ theme, nhất quán với các widget khác
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(
                  width: AppDimens.spaceL,
                ), // Khoảng cách giữa progress và text %
                Text(
                  '${(validProgress * 100).toInt()}%', // Hiển thị %
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        colorScheme.primary, // Dùng màu primary để nhấn mạnh %
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        if (onStudyPressed != null)
          AppButton(
            text: 'Study',
            onPressed: onStudyPressed,
            type: AppButtonType.primary, // AppButton tự lấy style từ theme
            size: AppButtonSize.small,
            prefixIcon: Icons.book,
          ),
      ],
    );
  }
}
