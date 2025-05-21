// lib/presentation/widgets/grammars/grammar_list_item.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

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

    return SLCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimens.paddingM),
      backgroundColor: colorScheme.surfaceContainer,
      elevation: AppDimens.elevationNone,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.7)),
      ),
      applyOuterShadow: false,
      child: Row(
        children: [
          // Icon for grammar rule
          Container(
            width: AppDimens.avatarSizeM,
            height: AppDimens.avatarSizeM,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.spellcheck_rounded,
                color: colorScheme.onSecondaryContainer,
                size: AppDimens.iconM,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceL),
          // Grammar pattern and module name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grammar.grammarPattern,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Display module name if available
                if (grammar.moduleName != null &&
                    grammar.moduleName!.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.spaceXXS),
                  Text(
                    'Module: ${grammar.moduleName}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceS),
          // Chevron icon to indicate tappable item
          Icon(
            Icons.chevron_right_rounded,
            size: AppDimens.iconM + 4,
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
