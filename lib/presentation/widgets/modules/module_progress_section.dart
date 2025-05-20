// lib/presentation/widgets/modules/module_progress_section.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart'; // Uses the redesigned ProgressCard

class ModuleProgressSection extends StatelessWidget {
  final ProgressDetail progress;
  final String
  moduleTitle; // Still useful for context if progress.moduleTitle is generic
  final void Function(String)
  onTap; // Callback when the progress section is tapped

  const ModuleProgressSection({
    super.key,
    required this.progress,
    required this.moduleTitle,
    required this.onTap,
  });

  // Determines if the module is currently due for review.
  bool _isDue(ProgressDetail progressDetail) {
    // Guard clause: if no next study date, it's not due.
    if (progressDetail.nextStudyDate == null) return false;

    final now = DateTime.now();
    // Normalize dates to compare day, month, year only.
    final today = DateTime(now.year, now.month, now.day);
    final nextDate = DateTime(
      progressDetail.nextStudyDate!.year,
      progressDetail.nextStudyDate!.month,
      progressDetail.nextStudyDate!.day,
    );

    // Due if next study date is today or in the past.
    return !nextDate.isAfter(today);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          'Your Learning Progress', // More descriptive title
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppDimens.spaceM),

        // Progress Card Display
        ProgressCard(
          progress: progress,
          // Pass the full ProgressDetail object
          subtitle: moduleTitle != progress.moduleTitle ? moduleTitle : null,
          // Optional subtitle
          isDue: _isDue(progress),
          // Pass the calculated due status
          onTap: () => onTap(progress.id), // Action on tap
        ),
        const SizedBox(height: AppDimens.spaceL),

        // Action Button to View Detailed Progress
        Center(
          child: SLButton(
            text: 'View Detailed Repetition Schedule',
            // More specific button text
            type: SLButtonType.outline,
            // Material 3 tonal button style
            prefixIcon: Icons.visibility_outlined,
            // Outlined icon
            onPressed: () => onTap(progress.id),
            size: SLButtonSize.medium, // Appropriate button size
          ),
        ),
      ],
    );
  }
}
