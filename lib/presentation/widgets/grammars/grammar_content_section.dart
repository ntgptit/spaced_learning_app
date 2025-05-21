// lib/presentation/widgets/grammars/grammar_content_section.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

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
        // Definition Section
        if (grammar.definition != null && grammar.definition!.isNotEmpty) ...[
          _buildSection(
            title: 'Definition',
            content: grammar.definition!,
            icon: Icons.article_outlined,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.primary,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Structure Section
        if (grammar.structure != null && grammar.structure!.isNotEmpty) ...[
          _buildSection(
            title: 'Structure',
            content: grammar.structure!,
            icon: Icons.architecture_outlined,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.tertiary,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Conjugation Section
        if (grammar.conjugation != null && grammar.conjugation!.isNotEmpty) ...[
          _buildSection(
            title: 'Conjugation',
            content: grammar.conjugation!,
            icon: Icons.compare_arrows_rounded,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.secondary,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Examples Section
        if (grammar.examples != null && grammar.examples!.isNotEmpty) ...[
          _buildSection(
            title: 'Examples',
            content: grammar.examples!,
            icon: Icons.format_quote_rounded,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.primary,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Common Phrases Section
        if (grammar.commonPhrases != null &&
            grammar.commonPhrases!.isNotEmpty) ...[
          _buildSection(
            title: 'Common Phrases',
            content: grammar.commonPhrases!,
            icon: Icons.chat_bubble_outline_rounded,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.tertiary,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],

        // Notes Section
        if (grammar.notes != null && grammar.notes!.isNotEmpty) ...[
          _buildSection(
            title: 'Usage Notes',
            content: grammar.notes!,
            icon: Icons.lightbulb_outline_rounded,
            theme: theme,
            colorScheme: colorScheme,
            iconColor: colorScheme.secondary,
          ),
        ],
      ],
    );
  }

  // Helper widget to build each content section
  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header (Icon and Title)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingS),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppDimens.iconM + 2, color: iconColor),
            ),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),

        // Content Card
        SLCard(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          backgroundColor: colorScheme.surfaceContainerLowest,
          elevation: AppDimens.elevationNone,
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
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
