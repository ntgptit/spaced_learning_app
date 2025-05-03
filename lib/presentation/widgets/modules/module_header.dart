import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';

class ModuleHeader extends StatelessWidget {
  final ModuleDetail module;

  const ModuleHeader({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(module.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppDimens.spaceM),
        Row(
          children: [
            _buildModuleTag(context),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: Text(
                'Book: ${module.bookName ?? "Unknown"}',
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceL),
        _buildStatsCard(context),
      ],
    );
  }

  Widget _buildModuleTag(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
      ),
      child: Text(
        'Module ${module.moduleNo}',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              module.progress.length.toString(),
              'Students',
            ),
            _buildDivider(context),
            _buildStatItem(
              context,
              module.wordCount?.toString() ?? 'N/A',
              'Words',
            ),
            _buildDivider(context),
            _buildStatItem(
              context,
              _estimateReadingTime(module.wordCount),
              'Reading Time',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.colorScheme.outline.withValues(alpha: 0.5);

    return Container(height: 40, width: 1, color: dividerColor);
  }

  String _estimateReadingTime(int? wordCount) {
    if (wordCount == null || wordCount <= 0) return 'N/A';
    final readingTimeMinutes = (wordCount / 200).ceil();
    if (readingTimeMinutes < 1) return '<1 min';
    return readingTimeMinutes == 1 ? '1 min' : '$readingTimeMinutes mins';
  }
}
