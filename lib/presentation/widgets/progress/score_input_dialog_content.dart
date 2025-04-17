import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class ScoreInputDialogContent extends StatefulWidget {
  final ValueNotifier<double> scoreNotifier;

  const ScoreInputDialogContent({super.key, required this.scoreNotifier});

  @override
  State<ScoreInputDialogContent> createState() =>
      _ScoreInputDialogContentState();
}

class _ScoreInputDialogContentState extends State<ScoreInputDialogContent>
    with SingleTickerProviderStateMixin {
  late double _currentScore;
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _currentScore = widget.scoreNotifier.value.clamp(0.0, 100.0);
    _controller = TextEditingController(text: _currentScore.toInt().toString());
    _controller.addListener(_onTextChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateScore(double newScore) {
    final clampedScore = newScore.clamp(0.0, 100.0);
    if (_currentScore != clampedScore) {
      setState(() {
        _currentScore = clampedScore;
        widget.scoreNotifier.value = _currentScore;

        final scoreInt = clampedScore.toInt();
        final textValue = scoreInt.toString();
        if (_controller.text != textValue) {
          final selection = _controller.selection;
          _controller.text = textValue;
          try {
            _controller.selection = selection.copyWith(
              baseOffset: selection.baseOffset.clamp(0, textValue.length),
              extentOffset: selection.extentOffset.clamp(0, textValue.length),
            );
          } catch (e) {
          }
        }
      });
    }
  }

  void _onTextChanged() {
    final value = double.tryParse(_controller.text);
    if (value != null && value != _currentScore) {
      _updateScore(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final scoreColor = _getScoreColor(colorScheme, _currentScore);
    final scoreTextStyle = textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: scoreColor,
    );

    return FadeTransition(
      opacity: _animation,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme, colorScheme),
            const SizedBox(height: AppDimens.spaceL),
            _buildScoreDisplay(scoreTextStyle, scoreColor),
            const SizedBox(height: AppDimens.spaceS),
            _buildSlider(colorScheme),
            _buildExactScore(theme, colorScheme),
            const SizedBox(height: AppDimens.spaceL),
            _buildQuickOptions(colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.primary),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Text(
              'Enter the score from your test on Quizlet or another tool:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(TextStyle? scoreTextStyle, Color scoreColor) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: scoreColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${_currentScore.toInt()}', style: scoreTextStyle),
            Text(
              '%',
              style: scoreTextStyle?.copyWith(
                fontSize: (scoreTextStyle.fontSize ?? 32) * 0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(ColorScheme colorScheme) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: _getScoreColor(colorScheme, _currentScore),
        thumbColor: _getScoreColor(colorScheme, _currentScore),
        overlayColor: _getScoreColor(
          colorScheme,
          _currentScore,
        ).withValues(alpha: 0.2),
        trackHeight: 6,
      ),
      child: Slider(
        value: _currentScore,
        min: 0,
        max: 100,
        divisions: 100,
        label: '${_currentScore.toInt()}%',
        onChanged: _updateScore,
      ),
    );
  }

  Widget _buildExactScore(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS,
        vertical: AppDimens.paddingM,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Exact score: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppDimens.spaceS),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
              child: IntrinsicWidth(
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                  ),
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  decoration: InputDecoration(
                    suffixText: '%',
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppDimens.paddingM,
                    ),
                    border: InputBorder.none,
                    suffixStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextStyle(
                    color: _getScoreColor(colorScheme, _currentScore),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOptions(ColorScheme colorScheme, TextTheme textTheme) {
    final scoreOptions = [0, 25, 50, 75, 100];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          scoreOptions.map((score) {
            final isSelected = _currentScore.round() == score;
            return _ScoreButton(
              score: score,
              isSelected: isSelected,
              onTap: () => _updateScore(score.toDouble()),
              colorScheme: colorScheme,
              textTheme: textTheme,
            );
          }).toList(),
    );
  }

  Color _getScoreColor(ColorScheme colorScheme, double score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return colorScheme.primary;
    if (score >= 60) return colorScheme.secondary;
    if (score >= 40) return Colors.orange;
    return colorScheme.error;
  }
}

class _ScoreButton extends StatelessWidget {
  final int score;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ScoreButton({
    required this.score,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(score);
    final bgColor = isSelected ? color : colorScheme.surfaceContainerHighest;
    final fgColor = isSelected ? colorScheme.surface : color;
    final border =
        isSelected ? null : Border.all(color: color.withValues(alpha: 0.5));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            border: border,
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child: Center(
            child: Text(
              '$score%',
              textAlign: TextAlign.center,
              style: textTheme.labelLarge?.copyWith(
                color: fgColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return colorScheme.primary;
    if (score >= 60) return colorScheme.secondary;
    if (score >= 40) return Colors.orange;
    return colorScheme.error;
  }
}
