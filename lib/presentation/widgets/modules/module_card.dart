// lib/presentation/widgets/module_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_progress_indicator.dart';

class ModuleCard extends StatelessWidget {
  final ModuleSummary module;
  final double? progress;
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

    return AppCard(
      onTap: onTap,
      title: Text('Module ${module.moduleNo}: ${module.title}'),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '${module.moduleNo}',
            style: theme.textTheme.titleLarge!.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      subtitle:
          module.wordCount != null && module.wordCount! > 0
              ? Text('${module.wordCount} words')
              : null,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (progress != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppProgressIndicator(
                    type: ProgressType.linear,
                    value: progress,
                    strokeWidth: 8,
                  ),
                ),
                const SizedBox(width: 16),
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
      actions: [
        if (onStudyPressed != null)
          AppButton(
            text: 'Study',
            onPressed: onStudyPressed,
            type: AppButtonType.primary,
            size: AppButtonSize.small,
            prefixIcon: Icons.book,
          ),
      ],
    );
  }
}
