// lib/presentation/widgets/grammars/grammar_header.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart'; // Using SLCard

class GrammarHeader extends StatelessWidget {
  final GrammarDetail grammar;

  const GrammarHeader({super.key, required this.grammar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grammar Title
        Text(
          grammar.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            // Increased font size
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        // Display module name if available
        if (grammar.moduleName != null && grammar.moduleName!.isNotEmpty) ...[
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            'From Module: ${grammar.moduleName}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppDimens.spaceL), // Consistent spacing
        // Informational Card using SLCard
        SLCard(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.7),
          // M3 surface color with opacity
          elevation: AppDimens.elevationNone,
          // Flat card
          applyOuterShadow: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align items to the start
            children: [
              Icon(
                Icons.info_outline_rounded, // Rounded icon
                color: colorScheme.onPrimaryContainer,
                size: AppDimens.iconM + 2, // Slightly larger icon
              ),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                child: Text(
                  'This grammar point is part of your learning module. Understanding these rules will enhance your communication skills and comprehension.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    height: 1.5, // Improved line height
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
