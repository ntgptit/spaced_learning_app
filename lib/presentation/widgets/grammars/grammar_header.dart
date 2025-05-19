import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';

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
        Text(
          grammar.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppDimens.spaceM),
        Card(
          elevation: AppDimens.elevationS,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          color: colorScheme.surfaceContainerLow,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: colorScheme.primary,
                  size: AppDimens.iconM,
                ),
                const SizedBox(width: AppDimens.spaceM),
                Expanded(
                  child: Text(
                    'This grammar point is part of your learning module. '
                    'Understanding grammar rules will help you communicate more effectively.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceL),
      ],
    );
  }
}
