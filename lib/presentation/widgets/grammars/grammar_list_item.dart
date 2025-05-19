import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';

class GrammarListItem extends StatelessWidget {
  final GrammarSummary grammar;
  final VoidCallback onTap;

  const GrammarListItem({
    super.key,
    required this.grammar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: AppDimens.elevationXS,
      margin: const EdgeInsets.only(bottom: AppDimens.spaceM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(
            alpha: AppDimens.opacitySemi,
          ),
          width: 1.0,
        ),
      ),
      color: colorScheme.surfaceContainerLowest,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Row(
            children: [
              Container(
                width: AppDimens.iconXL,
                height: AppDimens.iconXL,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(
                    alpha: AppDimens.opacityLight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.menu_book,
                    color: colorScheme.primary,
                    size: AppDimens.iconM,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grammar.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (grammar.moduleName != null) ...[
                      const SizedBox(height: AppDimens.spaceXS),
                      Text(
                        'Module: ${grammar.moduleName}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: AppDimens.iconM,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
