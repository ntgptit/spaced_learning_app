import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class ScoreInputDialogContent extends StatefulWidget {
  final double initialScore; // Điểm khởi tạo, mặc định là 80
  final ValueChanged<double> onScoreChangedFinal; // Callback khi xác nhận

  const ScoreInputDialogContent({
    super.key,
    this.initialScore = 80.0, // Đặt mặc định là 80
    required this.onScoreChangedFinal,
  });

  @override
  State<ScoreInputDialogContent> createState() =>
      _ScoreInputDialogContentState();
}

class _ScoreInputDialogContentState extends State<ScoreInputDialogContent> {
  late double _currentScore;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _currentScore = widget.initialScore.clamp(
      0.0,
      100.0,
    ); // Đảm bảo trong khoảng 0-100
    _controller = TextEditingController(text: _currentScore.toInt().toString());
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _updateScore(double newScore) {
    final clampedScore = newScore.clamp(0.0, 100.0);
    if (_currentScore != clampedScore) {
      setState(() {
        _currentScore = clampedScore;
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

    final scoreTextStyle = textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: colorScheme.primary,
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter the score from your test on Quizlet or another tool:',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceL),
          Text(
            '${_currentScore.toInt()}%',
            style: scoreTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceS),
          Slider(
            value: _currentScore,
            min: 0,
            max: 100,
            divisions: 100,
            label: '${_currentScore.toInt()}%',
            onChanged: _updateScore,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingS),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Exact score: ',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceS),
                Expanded(
                  child: IntrinsicWidth(
                    child: TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      decoration: const InputDecoration(
                        suffixText: '%',
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppDimens.paddingS,
                          vertical: AppDimens.paddingXXS,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildScoreButtons(colorScheme, textTheme),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScoreButtons(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    const scoreOptions = [0, 25, 50, 75, 100];

    return scoreOptions.map((score) {
      final isSelected = _currentScore.round() == score;
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingXXS),
          child: _ScoreButton(
            score: score,
            isSelected: isSelected,
            onTap: () => _updateScore(score.toDouble()),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ),
      );
    }).toList();
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
    final bgColor =
        isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final fgColor =
        isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    final border = isSelected ? null : Border.all(color: colorScheme.outline);
    final buttonTextStyle = textTheme.labelLarge;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingS,
            vertical: AppDimens.paddingXS,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
            border: border,
          ),
          child: Text(
            '$score%',
            textAlign: TextAlign.center,
            style: buttonTextStyle?.copyWith(
              color: fgColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
