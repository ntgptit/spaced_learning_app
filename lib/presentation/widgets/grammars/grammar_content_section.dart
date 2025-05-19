import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';

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
        if (grammar.explanation != null && grammar.explanation!.isNotEmpty) ...[
          _buildSection(
            title: 'Explanation',
            content: grammar.explanation!,
            icon: Icons.menu_book,
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        if (grammar.usageNote != null && grammar.usageNote!.isNotEmpty) ...[
          _buildSection(
            title: 'Usage Notes',
            content: grammar.usageNote!,
            icon: Icons.lightbulb_outline,
            theme: theme,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        if (grammar.example != null && grammar.example!.isNotEmpty) ...[
          _buildSection(
            title: 'Examples',
            content: grammar.example!,
            icon: Icons.format_quote,
            theme: theme,
            colorScheme: colorScheme,
          ),
        ],
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingXS),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(
                  alpha: AppDimens.opacityLight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppDimens.iconM,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppDimens.spaceM),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.paddingL),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
            border: Border.all(color: colorScheme.outlineVariant, width: 1),
          ),
          child: Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
