// lib/presentation/widgets/common/dialog/sl_score_input_dialog_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';

import '../../../../core/extensions/color_extensions.dart';

/// Content widget for the score input dialog.
/// This widget allows users to input a score with visual feedback.
class SlScoreInputDialogContent extends ConsumerStatefulWidget {
  final double initialValue;
  final double minValue;
  final double maxValue;
  final int divisions;
  final String title;
  final String? subtitle; // Optional subtitle
  final String confirmText;
  final String cancelText;
  final IconData? titleIcon; // Optional icon for the title

  /// Creates a score input dialog content widget.
  const SlScoreInputDialogContent({
    super.key,
    this.initialValue = 70.0,
    this.minValue = 0.0,
    this.maxValue = 100.0,
    this.divisions = 100,
    this.title = 'Input Score',
    this.subtitle,
    this.confirmText = 'Submit',
    this.cancelText = 'Cancel',
    this.titleIcon = Icons.leaderboard_outlined, // Default icon
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
  Color _getScoreColor(ColorScheme colorScheme, BuildContext context) {
    final percentage =
        (_scoreValue - widget.minValue) / (widget.maxValue - widget.minValue);

    // Using Theme extension if available, otherwise direct colors
    final theme = Theme.of(context);
    if (theme.extensions.containsKey(SemanticColorExtension)) {
      return theme.getScoreColor(
        _scoreValue,
      ); // Assuming getScoreColor exists in theme extensions
    }

    // Fallback to direct colors
    if (percentage >= 0.9) {
      return colorScheme.primary; // Or a specific success green
    }
    if (percentage >= 0.7) return colorScheme.tertiary;
    if (percentage >= 0.5) return colorScheme.secondary;
    if (percentage >= 0.3) return Colors.orange.shade700; // More vibrant orange
    return colorScheme.error;
  }

  Color _getContrastTextColor(Color backgroundColor, ColorScheme colorScheme) {
    return backgroundColor.computeLuminance() > 0.5
        ? colorScheme.onSurface
        : colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scoreColor = _getScoreColor(colorScheme, context);
    final scoreDisplayBackgroundColor = scoreColor.withValues(alpha: 0.1);
    final scoreDisplayTextColor = _getContrastTextColor(
      scoreColor,
      colorScheme,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.titleIcon != null) ...[
              Icon(
                widget.titleIcon,
                color: colorScheme.primary,
                size: AppDimens.iconL,
              ),
              const SizedBox(width: AppDimens.spaceS),
            ],
            Text(
              widget.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                // M3 headline
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        if (widget.subtitle != null) ...[
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            widget.subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppDimens.spaceXL),
        Container(
          width: AppDimens.iconXXXL * 1.8, // Slightly larger display
          height: AppDimens.iconXXXL * 1.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scoreDisplayBackgroundColor,
            border: Border.all(
              color: scoreColor.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: scoreColor.withValues(alpha: 0.2),
                blurRadius: AppDimens.shadowRadiusM,
                spreadRadius: AppDimens.shadowOffsetS,
              ),
            ],
          ),
          child: Center(
            child: Text(
              _scoreValue.round().toString(),
              style: theme.textTheme.displayMedium?.copyWith(
                // M3 display
                color: scoreColor, // Use the dynamic score color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceXL),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: scoreColor,
            inactiveTrackColor: scoreColor.withValues(alpha: 0.25),
            thumbColor: scoreColor,
            overlayColor: scoreColor.withValues(alpha: 0.15),
            trackHeight: AppDimens.lineProgressHeightL,
            // 8.0
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: AppDimens.radiusM,
            ),
            // 12.0
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: AppDimens.paddingXL,
            ),
            // 24.0
            valueIndicatorColor: colorScheme.primaryContainer,
            valueIndicatorTextStyle: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
            valueIndicatorShape:
                const PaddleSliderValueIndicatorShape(), // M3 style
          ),
          child: Slider(
            value: _scoreValue,
            min: widget.minValue,
            max: widget.maxValue,
            divisions: widget.divisions,
            label: '${_scoreValue.round()}%',
            // Label for accessibility and hover
            onChanged: (value) {
              setState(() {
                _scoreValue = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.minValue.round().toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                widget.maxValue.round().toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spaceXL),
        // More spacing before actions
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SLButton(
              text: widget.cancelText,
              onPressed: () => Navigator.of(context).pop(),
              type: SLButtonType.text,
            ),
            const SizedBox(width: AppDimens.spaceM),
            SLButton(
              text: widget.confirmText,
              onPressed: () => Navigator.of(context).pop(_scoreValue),
              type: SLButtonType.primary,
              // Or a type that uses scoreColor
              backgroundColor: scoreColor,
              // Dynamic button color
              textColor: _getContrastTextColor(scoreColor, colorScheme),
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
    String? subtitle,
    String confirmText = 'Submit',
    String cancelText = 'Cancel',
    IconData? titleIcon = Icons.leaderboard_outlined,
  }) {
    return showDialog<double>(
      context: context,
      barrierDismissible: true, // Usually score inputs are dismissible
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimens.radiusXL,
            ), // M3 Dialog shape
          ),
          backgroundColor: Theme.of(
            dialogContext,
          ).colorScheme.surfaceContainerLowest,
          surfaceTintColor: Theme.of(dialogContext).colorScheme.surfaceTint,
          content: SlScoreInputDialogContent(
            initialValue: initialValue,
            minValue: minValue,
            maxValue: maxValue,
            divisions: divisions,
            title: title,
            subtitle: subtitle,
            confirmText: confirmText,
            cancelText: cancelText,
            titleIcon: titleIcon,
          ),
          contentPadding: const EdgeInsets.all(
            AppDimens.paddingXL,
          ), // Consistent padding
        );
      },
    );
  }
}
