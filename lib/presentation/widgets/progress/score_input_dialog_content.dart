import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Dialog content for inputting test scores
class ScoreInputDialogContent extends StatelessWidget {
  final double currentScore;
  final TextEditingController controller;
  final ValueChanged<double> onScoreChanged;

  const ScoreInputDialogContent({
    super.key,
    required this.currentScore,
    required this.controller,
    required this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Enter the score from your test on Quizlet or another tool:',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: AppDimens.spaceL),
        Text(
          '${currentScore.toInt()}%',
          style: const TextStyle(
            fontSize: AppDimens.fontHeadlineS,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: AppDimens.spaceL),
        Slider(
          value: currentScore,
          min: 0,
          max: 100,
          divisions: 20,
          label: '${currentScore.toInt()}%',
          onChanged: onScoreChanged,
        ),
        const SizedBox(height: AppDimens.spaceM),
        Row(
          children: [
            Text('Enter exact score: ', style: theme.textTheme.bodyMedium),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixText: '%',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingM,
                    vertical: AppDimens.paddingS,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  ),
                ),
                onChanged: (value) {
                  final intValue = int.tryParse(value);
                  if (intValue != null && intValue >= 0 && intValue <= 100) {
                    onScoreChanged(intValue.toDouble());
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildScoreButtons(theme),
        ),
      ],
    );
  }

  List<Widget> _buildScoreButtons(ThemeData theme) {
    // Pre-defined score options
    const scoreOptions = [0, 25, 50, 75, 100];

    return scoreOptions.map((score) {
      final isSelected = currentScore.toInt() == score;
      return _ScoreButton(
        score: score,
        isSelected: isSelected,
        onTap: () => onScoreChanged(score.toDouble()),
      );
    }).toList();
  }
}

/// A button for quickly selecting predefined scores
class _ScoreButton extends StatelessWidget {
  final int score;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScoreButton({
    required this.score,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusS),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingS,
          vertical: AppDimens.paddingXS,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary.withOpacity(
                      AppDimens.opacityHigh,
                    )
                    : theme.colorScheme.outline.withOpacity(
                      AppDimens.opacityMedium,
                    ),
          ),
        ),
        child: Text(
          '$score%',
          style: TextStyle(
            color:
                isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
