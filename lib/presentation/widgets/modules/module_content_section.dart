import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';

class ModuleContentSection extends StatelessWidget {
  final ModuleDetail module;

  const ModuleContentSection({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Content Overview', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceM),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (module.wordCount != null && module.wordCount! > 0) ...[
                  Row(
                    children: [
                      const Icon(Icons.format_size),
                      const SizedBox(width: AppDimens.spaceM),
                      Text(
                        'Word Count: ${module.wordCount}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                ],
                const Text(
                  'This is where the module content would be displayed. '
                  'In a complete application, this would include text, '
                  'images, videos, and other learning materials.',
                ),
                const SizedBox(height: AppDimens.spaceL),
                _buildStudyTips(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudyTips(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: theme.colorScheme.primary),
              const SizedBox(width: AppDimens.spaceM),
              Text(
                'Study Tips',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceM),
          const Text(
            '• Review this module regularly using the spaced repetition schedule\n'
            '• Take notes while studying\n'
            '• Try to recall the material before checking your answers\n'
            '• Connect new information to things you already know',
          ),
        ],
      ),
    );
  }
}
