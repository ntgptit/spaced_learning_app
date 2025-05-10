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
          // Truyền trực tiếp ProgressDetail vào ProgressCard mà không cần chuyển đổi
          progress: progress,
          // Có thể tiếp tục sử dụng moduleTitle từ props nếu không muốn dùng
          // progress.moduleTitle
          subtitle: moduleTitle != progress.moduleTitle ? moduleTitle : null,
          isDue: _isDue(progress),
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

  bool _isDue(ProgressDetail progress) {
    if (progress.nextStudyDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextDate = DateTime(
      progress.nextStudyDate!.year,
      progress.nextStudyDate!.month,
      progress.nextStudyDate!.day,
    );

    return nextDate.compareTo(today) <= 0;
  }
}
