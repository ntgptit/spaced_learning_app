// lib/presentation/widgets/common/dialog/sl_score_input_dialog_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';

/// Content widget for the score input dialog.
/// This widget allows users to input a score with visual feedback.
class SlScoreInputDialogContent extends ConsumerStatefulWidget {
  final double initialValue;
  final double minValue;
  final double maxValue;
  final int divisions;
  final String title;
  final String confirmText;
  final String cancelText;

  /// Creates a score input dialog content widget.
  const SlScoreInputDialogContent({
    super.key,
    this.initialValue = 70.0,
    this.minValue = 0.0,
    this.maxValue = 100.0,
    this.divisions = 100,
    this.title = 'Input Score',
    this.confirmText = 'Submit',
    this.cancelText = 'Cancel',
  });

  @override
  ConsumerState<SlScoreInputDialogContent> createState() =>
      _SlScoreInputDialogContentState();
}

class _SlScoreInputDialogContentState
    extends ConsumerState<SlScoreInputDialogContent> {
  late double _scoreValue;

  @override
  void initState() {
    super.initState();
    _scoreValue = widget.initialValue.clamp(widget.minValue, widget.maxValue);
  }

  /// Get the color for the score based on its value
  Color _getScoreColor(ColorScheme colorScheme) {
    final percentage = (_scoreValue - widget.minValue) /
        (widget.maxValue - widget.minValue);

    if (percentage >= 0.9) return colorScheme.primary;
    if (percentage >= 0.7) return colorScheme.tertiary;
    if (percentage >= 0.5) return colorScheme.secondary;
    if (percentage >= 0.3) return Colors.orange;
    return colorScheme.error;
  }

  /// Get background color for the score display
  Color _getScoreBackgroundColor(Color foregroundColor) {
    return foregroundColor.withValues(alpha: 0.15);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scoreColor = _getScoreColor(colorScheme);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimens.spaceL),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getScoreBackgroundColor(scoreColor),
            boxShadow: [
              BoxShadow(
                color: scoreColor.withValues(alpha: 0.25),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              _scoreValue.round().toString(),
              style: theme.textTheme.displayMedium?.copyWith(
                color: scoreColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceXL),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: scoreColor,
            inactiveTrackColor: scoreColor.withValues(alpha: 0.2),
            thumbColor: scoreColor,
            trackHeight: 8.0,
            overlayColor: scoreColor.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: _scoreValue,
            min: widget.minValue,
            max: widget.maxValue,
            divisions: widget.divisions,
            onChanged: (value) {
              setState(() {
                _scoreValue = value;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.minValue.round().toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              widget.maxValue.round().toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceL),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                widget.cancelText,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceM),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_scoreValue),
              style: FilledButton.styleFrom(
                backgroundColor: scoreColor,
                foregroundColor: colorScheme.background,
              ),
              child: Text(widget.confirmText),
            ),
          ],
        ),
      ],
    );
  }

  /// Shows a dialog with a score input slider
  static Future<double?> show(
    BuildContext context, {
    double initialValue = 70.0,
    double minValue = 0.0,
    double maxValue = 100.0,
    int divisions = 100,
    String title = 'Input Score',
    String confirmText = 'Submit',
    String cancelText = 'Cancel',
  }) {
    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
          ),
          content: SlScoreInputDialogContent(
            initialValue: initialValue,
            minValue: minValue,
            maxValue: maxValue,
            divisions: divisions,
            title: title,
            confirmText: confirmText,
            cancelText: cancelText,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXL,
            vertical: AppDimens.paddingXL,
          ),
        );
      },
    );
  }
}
