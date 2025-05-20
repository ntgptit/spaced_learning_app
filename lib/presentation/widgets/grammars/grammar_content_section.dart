// lib/presentation/widgets/grammars/grammar_content_section.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart'; // Using SLCard

class GrammarContentSection extends StatelessWidget {
  final GrammarDetail grammar;

  const GrammarContentSection({super.key, required this.grammar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Explanation Section
        if (grammar.explanation != null && grammar.explanation!.isNotEmpty) ...[
          _buildSection(
            title: 'Explanation',
            content: grammar.explanation!,
            icon: Icons.article_outlined,
            // More appropriate icon
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.primary,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Usage Notes Section
        if (grammar.usageNote != null && grammar.usageNote!.isNotEmpty) ...[
          _buildSection(
            title: 'Usage Notes & Context',
            // More descriptive title
            content: grammar.usageNote!,
            icon: Icons.lightbulb_outline_rounded,
            // Rounded icon
            theme: theme,
            colorScheme: colorScheme,
            iconColor:
                colorScheme.secondary, // Different color for visual distinction
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Examples Section
        if (grammar.example != null && grammar.example!.isNotEmpty) ...[
          _buildSection(
            title: 'Illustrative Examples',
            // More descriptive title
            content: grammar.example!,
            icon: Icons.format_quote_rounded,
            // Rounded icon
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.tertiary, // Different color
          ),
        ],
      ],
    );
  }

  // Helper widget to build each content section (Explanation, Usage, Examples).
  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Color iconColor, // Specific color for the section icon and title
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header (Icon and Title)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Align icon and text
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingS),
              // Padding around the icon
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1), // Light background for icon
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppDimens.iconM + 2, // Slightly larger icon
                color: iconColor,
              ),
            ),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              // Allow title to take available space
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  // Larger title for section
                  fontWeight: FontWeight.w600, // Bolder
                  color: iconColor, // Use the section's theme color
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),

        // Content Card using SLCard for consistent styling
        SLCard(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          backgroundColor: colorScheme.surfaceContainerLowest,
          // Very light background
          elevation: AppDimens.elevationNone,
          // Flat design
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            side: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          applyOuterShadow: false,
          child: Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              // Slightly muted text for content
              height: 1.6, // Improved line height for readability
            ),
          ),
        ),
      ],
    );
  }
}
