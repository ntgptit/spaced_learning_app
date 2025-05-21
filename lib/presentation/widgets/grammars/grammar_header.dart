// lib/presentation/widgets/grammars/grammar_header.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

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
        // Grammar Pattern (Title)
        Text(
          grammar.grammarPattern,
          style: theme.textTheme.headlineMedium?.copyWith(
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
        const SizedBox(height: AppDimens.spaceL),
        // Informational Card
        SLCard(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          backgroundColor: colorScheme.primaryContainer.withOpacity(0.7),
          elevation: AppDimens.elevationNone,
          applyOuterShadow: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: colorScheme.onPrimaryContainer,
                size: AppDimens.iconM + 2,
              ),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                child: Text(
                  'This grammar pattern is part of your learning module. Understanding these rules will enhance your communication skills and comprehension.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    height: 1.5,
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
