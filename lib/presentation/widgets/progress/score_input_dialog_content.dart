// lib/presentation/widgets/progress/score_input_dialog_content.dart

import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class ScoreInputDialogContent extends StatefulWidget {
  // Bỏ initialScore và onScoreChangedFinal
  // final double initialScore;
  // final ValueChanged<double> onScoreChangedFinal;
  final ValueNotifier<double> scoreNotifier; // Thêm notifier

  const ScoreInputDialogContent({
    super.key,
    required this.scoreNotifier, // Bắt buộc truyền notifier
  });

  @override
  State<ScoreInputDialogContent> createState() =>
      _ScoreInputDialogContentState();
}

class _ScoreInputDialogContentState extends State<ScoreInputDialogContent> {
  // Giữ _currentScore để quản lý trạng thái nội bộ và binding UI
  late double _currentScore;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Khởi tạo state nội bộ từ giá trị ban đầu của notifier
    _currentScore = widget.scoreNotifier.value.clamp(0.0, 100.0);
    _controller = TextEditingController(text: _currentScore.toInt().toString());
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  // Hàm cập nhật state nội bộ VÀ notifier bên ngoài
  void _updateScore(double newScore) {
    final clampedScore = newScore.clamp(0.0, 100.0);
    if (_currentScore != clampedScore) {
      setState(() {
        _currentScore = clampedScore;
        // Cập nhật notifier bên ngoài
        widget.scoreNotifier.value = _currentScore;

        // Đồng bộ text field (giữ nguyên logic cũ)
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
            // Bỏ qua lỗi tiềm ẩn khi thao tác text lúc đang cập nhật
          }
        }
      });
    }
  }

  // Xử lý thay đổi từ TextField
  void _onTextChanged() {
    final value = double.tryParse(_controller.text);
    // Chỉ cập nhật nếu parse thành công VÀ giá trị khác giá trị hiện tại
    if (value != null && value != _currentScore) {
      _updateScore(value);
    } else if (_controller.text.isEmpty) {
      // Có thể xử lý trường hợp rỗng nếu muốn (vd: đặt score = 0)
      // _updateScore(0.0);
    } else if (value == null && _controller.text.isNotEmpty) {
      // Có thể xử lý input không hợp lệ (vd: báo lỗi, revert)
      // Hiện tại: không làm gì cả, giữ nguyên _currentScore
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

    // UI giống hệt trước, chỉ khác là gọi _updateScore
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
            '${_currentScore.toInt()}%', // Hiển thị state nội bộ
            style: scoreTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceS),
          Slider(
            value: _currentScore, // Bind vào state nội bộ
            min: 0,
            max: 100,
            divisions: 100,
            label: '${_currentScore.toInt()}%',
            onChanged: _updateScore, // Gọi hàm cập nhật nội bộ & notifier
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
                      controller: _controller, // Bind vào controller
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
                      // Listener _onTextChanged sẽ gọi _updateScore
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Các nút 0, 25, 50, 75, 100 giữ nguyên cách build
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
      // Dùng _currentScore nội bộ để xác định trạng thái selected
      final isSelected = _currentScore.round() == score;
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingXXS),
          child: _ScoreButton(
            score: score,
            isSelected: isSelected,
            onTap: () => _updateScore(score.toDouble()), // Gọi cập nhật nội bộ
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ),
      );
    }).toList();
  }
}

// Widget _ScoreButton không thay đổi
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
