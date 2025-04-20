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
      duration: const Duration(milliseconds: AppDimens.durationM),
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
    final clamped = newScore.clamp(0.0, 100.0);
    if (_currentScore != clamped) {
      setState(() {
        _currentScore = clamped;
        widget.scoreNotifier.value = _currentScore;

        final textValue = clamped.toInt().toString();
        if (_controller.text != textValue) {
          final sel = _controller.selection;
          _controller.text = textValue;
          if (sel.isValid && textValue.isNotEmpty) {
            final base = sel.baseOffset.clamp(0, textValue.length);
            final ext = sel.extentOffset.clamp(0, textValue.length);
            _controller.selection = TextSelection(
              baseOffset: base,
              extentOffset: ext,
            );
          } else {
            _controller.selection = TextSelection.collapsed(
              offset: textValue.length,
            );
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

  Color _getScoreColor(ColorScheme cs, double score) {
    if (score >= 90) return cs.primary;
    if (score >= 75) return cs.secondary;
    if (score >= 60) return cs.tertiary;
    if (score >= 40) return cs.error;
    return cs.errorContainer;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final scoreColor = _getScoreColor(cs, _currentScore);
    final scoreTextStyle = theme.textTheme.displaySmall?.copyWith(
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
            _buildHeader(theme, cs),
            const SizedBox(height: AppDimens.spaceL),
            _buildScoreDisplay(scoreTextStyle, cs),
            const SizedBox(height: AppDimens.spaceS),
            _buildSlider(cs),
            _buildExactScore(theme, cs, scoreColor),
            const SizedBox(height: AppDimens.spaceL),
            _buildQuickOptions(cs, theme.textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: cs.onPrimaryContainer,
            size: AppDimens.iconM,
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Text(
              'Enter the score from your test on Quizlet or another tool:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(TextStyle? scoreTextStyle, ColorScheme cs) {
    return Container(
      height: AppDimens.iconXXL * 2,
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(color: cs.tertiary, width: 1.5),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_currentScore.toInt()}',
              style: scoreTextStyle?.copyWith(
                color: cs.onTertiaryContainer,
                fontSize: 48,
              ),
            ),
            Text(
              '%',
              style: scoreTextStyle?.copyWith(
                color: cs.onTertiaryContainer,
                fontSize: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(ColorScheme cs) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: cs.primary,
        inactiveTrackColor: cs.surfaceContainerHighest,
        thumbColor: cs.primary,
        trackHeight: 8,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
        overlayColor: cs.primary.withValues(alpha: 0.12),
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

  Widget _buildExactScore(ThemeData theme, ColorScheme cs, Color scoreColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS,
        vertical: AppDimens.paddingM,
      ),
      child: Row(
        children: [
          Text(
            'Exact score: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppDimens.spaceS),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingS,
              ),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
                border: Border.all(color: scoreColor, width: 2),
              ),
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                textAlign: TextAlign.center,
                maxLength: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  suffixText: '%',
                  counterText: '',
                  border: InputBorder.none,
                  suffixStyle: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: TextStyle(
                  color: scoreColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOptions(ColorScheme cs, TextTheme textTheme) {
    final options = [0, 25, 50, 75, 100];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((s) {
        final selected = _currentScore.round() == s;
        return _ScoreButton(
          score: s,
          isSelected: selected,
          onTap: () => _updateScore(s.toDouble()),
          colorScheme: cs,
          textTheme: textTheme,
        );
      }).toList(),
    );
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

  Color _getColor(int score) {
    if (score >= 90) return colorScheme.primary;
    if (score >= 75) return colorScheme.secondary;
    if (score >= 60) return colorScheme.tertiary;
    if (score >= 40) return colorScheme.error;
    return colorScheme.errorContainer;
  }

  @override
  Widget build(BuildContext context) {
    final c = _getColor(score);
    final bg = isSelected
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final fg = isSelected ? colorScheme.onPrimaryContainer : c;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusM),
      child: Container(
        width: AppDimens.iconXL + AppDimens.spaceS,
        height: AppDimens.iconXL + AppDimens.spaceS,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          border: isSelected ? null : Border.all(color: c, width: 2),
        ),
        child: Center(
          child: Text(
            '$score%',
            style: textTheme.labelLarge?.copyWith(
              color: fg,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
