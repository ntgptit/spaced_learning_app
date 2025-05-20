// lib/presentation/widgets/modules/module_header.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart'; // Using SLCard

class ModuleHeader extends StatelessWidget {
  final ModuleDetail module;

  const ModuleHeader({super.key, required this.module});

  // Estimates reading time based on word count.
  String _estimateReadingTime(int? wordCount) {
    if (wordCount == null || wordCount <= 0) {
      return 'N/A'; // Not Applicable if no word count.
    }
    // Assuming an average reading speed of 200 words per minute.
    final readingTimeMinutes = (wordCount / 200).ceil();
    if (readingTimeMinutes < 1) return '<1 min';
    return readingTimeMinutes == 1 ? '1 min' : '$readingTimeMinutes mins';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Module Title
        Text(
          module.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            // Increased font size for emphasis
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppDimens.spaceS), // Reduced space slightly
        // Module Number and Book Name
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingM, // Adjusted padding
                vertical: AppDimens.paddingXS,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                // Use primary container for tag
                borderRadius: BorderRadius.circular(
                  AppDimens.radiusXL,
                ), // Fully rounded
              ),
              child: Text(
                'Module ${module.moduleNo}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600, // Bolder text
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Text(
                'From: ${module.bookName ?? "Unknown Book"}',
                // Provide a fallback
                style: theme.textTheme.titleSmall?.copyWith(
                  // Slightly larger text for book name
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceL), // Consistent spacing
        // Stats Card using SLCard for a modern, contained look
        SLCard(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          backgroundColor: colorScheme.surfaceContainerHigh,
          // Material 3 surface color
          elevation: AppDimens.elevationNone,
          // Flat design, relying on color and border
          applyOuterShadow: false,
          // No outer shadow for cleaner look
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                module.progress.length.toString(),
                'Students',
                Icons.people_outline_rounded, // Modern icon
              ),
              _buildDivider(context),
              _buildStatItem(
                context,
                module.wordCount?.toString() ?? 'N/A',
                'Words',
                Icons.article_outlined, // Modern icon
              ),
              _buildDivider(context),
              _buildStatItem(
                context,
                _estimateReadingTime(module.wordCount),
                'Est. Time',
                Icons.timer_outlined, // Modern icon
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget to build individual stat items within the stats card.
  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      // Use Expanded to allow items to share space equally
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // Ensure column takes minimum vertical space
        children: [
          Icon(icon, size: AppDimens.iconM, color: colorScheme.primary),
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              // Use titleLarge for stat value
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceXXS),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper widget to build a vertical divider between stat items.
  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor =
        theme.colorScheme.outlineVariant; // Use outlineVariant for divider

    return Container(
      height: AppDimens.iconXXL, // Height of the divider
      width: AppDimens.dividerThickness, // Thickness of the divider
      color: dividerColor.withValues(alpha: 0.5),
    ); // Make it slightly transparent
  }
}
