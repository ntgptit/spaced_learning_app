// lib/presentation/widgets/progress/progress_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

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
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    // Format dates for display
    final nextStudyText =
        progress.nextStudyDate != null
            ? dateFormat.format(progress.nextStudyDate!)
            : 'Not scheduled';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      color: isDue ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  CircularProgressIndicator(
                    value: progress.percentComplete / 100,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    strokeWidth: 5,
                  ),
                  const SizedBox(width: 16),

                  // Module title and progress details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          moduleTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(subtitle!, style: theme.textTheme.bodyMedium),
                        ],

                        const SizedBox(height: 4),
                        Text(
                          'Next study: $nextStudyText',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDue ? theme.colorScheme.primary : null,
                            fontWeight: isDue ? FontWeight.bold : null,
                          ),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          'Progress: ${progress.percentComplete.toInt()}%',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // Due indicator
                  if (isDue)
                    const Icon(Icons.notifications_active, color: Colors.amber),
                ],
              ),

              // Show count of completed repetitions
              if (progress.repetitionCount > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Repetitions: ${progress.repetitionCount}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
