// lib/presentation/widgets/modules/module_content_section.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart'; // Using SLCard

class ModuleContentSection extends StatelessWidget {
  final ModuleDetail module;

  const ModuleContentSection({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          'Content Overview',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold, // Bolder title
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppDimens.spaceM),

        // Main content card
        SLCard(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          backgroundColor: colorScheme.surfaceContainer,
          // M3 surface color
          elevation: AppDimens.elevationNone,
          // Flat design with border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
            side: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.7),
            ),
          ),
          applyOuterShadow: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display word count if available
              if (module.wordCount != null && module.wordCount! > 0) ...[
                Row(
                  children: [
                    Icon(
                      Icons.text_fields_rounded,
                      color: colorScheme.secondary,
                      size: AppDimens.iconM,
                    ), // Rounded icon
                    const SizedBox(width: AppDimens.spaceM),
                    Text(
                      'Approx. ${module.wordCount} words', // More descriptive
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceL), // Increased spacing
                Divider(color: colorScheme.outlineVariant.withOpacity(0.5)),
                const SizedBox(height: AppDimens.spaceL),
              ],
              // Placeholder for module content
              Text(
                module.url != null && module.url!.isNotEmpty
                    ? 'This module contains external learning materials. Tap the "Start Learning" button to access them.'
                    : 'The content for this module will be displayed here. This may include text, images, and interactive elements to aid your learning.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5, // Improved line height for readability
                ),
              ),
              const SizedBox(height: AppDimens.spaceXL), // Increased spacing
              _buildStudyTips(context, theme, colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget for displaying study tips.
  Widget _buildStudyTips(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingL), // Generous padding
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withOpacity(0.7),
        // Using tertiary container for tips
        borderRadius: BorderRadius.circular(
          AppDimens.radiusM,
        ), // Consistent border radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: colorScheme.onTertiaryContainer,
                size: AppDimens.iconM,
              ), // Rounded icon
              const SizedBox(width: AppDimens.spaceM),
              Text(
                'Effective Study Tips', // More engaging title
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceM),
          // List of study tips
          _buildTipItem(
            'Review this module according to the spaced repetition schedule.',
            colorScheme,
          ),
          _buildTipItem(
            'Take concise notes during your study sessions.',
            colorScheme,
          ),
          _buildTipItem(
            'Actively recall information before checking answers or materials.',
            colorScheme,
          ),
          _buildTipItem(
            'Connect new concepts to your existing knowledge.',
            colorScheme,
          ),
        ],
      ),
    );
  }

  // Helper to build individual tip items.
  Widget _buildTipItem(String tip, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: colorScheme.onTertiaryContainer,
              fontSize: AppDimens.fontL,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: colorScheme.onTertiaryContainer,
                fontSize: AppDimens.fontL,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
