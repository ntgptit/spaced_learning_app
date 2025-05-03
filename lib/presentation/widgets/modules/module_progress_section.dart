import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

class ModuleProgressSection extends StatelessWidget {
  final ProgressDetail progress;
  final String moduleTitle;
  final void Function(String) onTap;

  const ModuleProgressSection({
    super.key,
    required this.progress,
    required this.moduleTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Progress', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceM),
        ProgressCard(
          progress: ProgressSummary(
            id: progress.id,
            moduleId: progress.moduleId,
            firstLearningDate: progress.firstLearningDate,
            cyclesStudied: progress.cyclesStudied,
            nextStudyDate: progress.nextStudyDate,
            percentComplete: progress.percentComplete,
            createdAt: progress.createdAt,
            updatedAt: progress.updatedAt,
            repetitionCount: progress.repetitions.length,
          ),
          moduleTitle: moduleTitle,
          onTap: () => onTap(progress.id),
        ),
        const SizedBox(height: AppDimens.spaceL),
        Center(
          child: SLButton(
            text: 'View Detailed Progress',
            type: SLButtonType.outline,
            prefixIcon: Icons.visibility,
            onPressed: () => onTap(progress.id),
          ),
        ),
      ],
    );
  }
}
