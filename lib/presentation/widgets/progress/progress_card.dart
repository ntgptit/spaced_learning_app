// lib/presentation/widgets/progress/progress_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

/// A card widget displaying progress summary for a module
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
              _buildHeaderRow(theme),
              if (progress.repetitionCount > 0) ...[
                const SizedBox(height: 8),
                _buildRepetitionCountBadge(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the header row with progress indicator and details
  Widget _buildHeaderRow(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressIndicator(theme),
        const SizedBox(width: 16),
        _buildProgressDetails(theme),
        if (isDue) _buildDueIndicator(),
      ],
    );
  }

  /// Builds the circular progress indicator
  Widget _buildProgressIndicator(ThemeData theme) {
    return CircularProgressIndicator(
      value: progress.percentComplete / 100,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      strokeWidth: 5,
    );
  }

  /// Builds the module title and progress details
  Widget _buildProgressDetails(ThemeData theme) {
    final dateFormat = DateFormat('MMM dd, yyyy');
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
    );
  }

  /// Builds the due indicator icon
  Widget _buildDueIndicator() {
    return const Icon(Icons.notifications_active, color: Colors.amber);
  }

  /// Builds the repetition count badge
  Widget _buildRepetitionCountBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Repetitions: ${progress.repetitionCount}',
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
