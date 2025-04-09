import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_progress_indicator.dart';

class ModuleCard extends StatelessWidget {
  final ModuleSummary module;
  final double? progress;
  final VoidCallback? onTap;
  final VoidCallback? onStudyPressed;

  const ModuleCard({
    super.key,
    required this.module,
    this.progress,
    this.onTap,
    this.onStudyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final validProgress = progress?.clamp(0.0, 1.0);

    return AppCard(
      onTap: onTap,
      elevation: 2, // Độ nổi nhẹ
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(textTheme, colorScheme),
            if (validProgress != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              _buildProgressSection(validProgress, colorScheme, textTheme),
            ],
            const SizedBox(height: AppDimens.spaceM),
            _buildActionSection(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModuleNumber(colorScheme, textTheme),
        const SizedBox(width: AppDimens.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                module.title,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (module.wordCount != null && module.wordCount! > 0)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.spaceXS),
                  child: Text(
                    '${module.wordCount} words',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModuleNumber(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      width: AppDimens.avatarSizeM,
      height: AppDimens.avatarSizeM,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Center(
        child: Text(
          '${module.moduleNo}',
          style: textTheme.titleMedium!.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    double validProgress,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        Expanded(
          child: AppProgressIndicator(
            type: ProgressType.linear,
            value: validProgress,
            strokeWidth: AppDimens.buttonHeightM,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
        const SizedBox(width: AppDimens.spaceM),
        Text(
          '${(validProgress * 100).toInt()}%',
          style: textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onStudyPressed != null)
          AppButton(
            text: 'Study',
            onPressed: onStudyPressed,
            type: AppButtonType.primary,
            size: AppButtonSize.small,
            prefixIcon: Icons.book,
          ),
      ],
    );
  }
}
