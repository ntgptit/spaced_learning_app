import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_progress_indicator.dart';

class ModuleCard extends StatelessWidget {
  final ModuleSummary module;
  final double? progress;
  final VoidCallback? onTap;

  const ModuleCard({
    super.key,
    required this.module,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      title: Text(
        module.title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold, // Làm nổi bật title
          color: colorScheme.primary, // Dùng màu primary để nổi bật
        ),
        maxLines: 1, // Giới hạn 1 dòng
        overflow: TextOverflow.ellipsis, // Thêm dấu ... nếu title quá dài
      ),
      leading: Container(
        width: AppDimens.avatarSizeL,
        height: AppDimens.avatarSizeL,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
        ),
        child: Center(
          child: Text(
            '${module.moduleNo}',
            style: theme.textTheme.titleLarge!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      subtitle:
          module.wordCount != null && module.wordCount! > 0
              ? Text(
                '${module.wordCount} words',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
              : null,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (progress != null) ...[
            const SizedBox(height: AppDimens.spaceL),
            Row(
              children: [
                Expanded(
                  child: AppProgressIndicator(
                    type: ProgressType.linear,
                    value: progress,
                    strokeWidth: AppDimens.lineProgressHeightL,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceL),
                Text(
                  '${(progress! * 100).toInt()}%',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),

      trailing: Container(
        alignment: Alignment.center,
        child: Icon(
          Icons.navigate_next,
          color: colorScheme.onSurfaceVariant,
          size: AppDimens.iconM,
        ),
      ),
    );
  }
}
