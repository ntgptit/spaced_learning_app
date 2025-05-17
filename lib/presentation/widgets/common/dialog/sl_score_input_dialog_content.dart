// lib/presentation/widgets/common/dialog/sl_score_input_dialog_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';

part 'sl_score_input_dialog_content.g.dart';

/// Provider for managing score value in the dialog
@riverpod
class ScoreValue extends _$ScoreValue {
  @override
  double build(String dialogId, {double initialValue = 70.0}) => initialValue;

  void setScore(double value) {
    state = value;
  }
}

/// Content widget for the score input dialog.
/// This widget allows users to input a score with visual feedback.
class SlScoreInputDialogContent extends ConsumerWidget {
  final String dialogId;
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
    required this.dialogId,
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

  /// Factory for a standard score input dialog
  factory SlScoreInputDialogContent.standard({
    required String dialogId,
    double initialValue = 70.0,
    String title = 'Rate Your Experience',
    String? subtitle = 'Drag the slider to rate',
    IconData titleIcon = Icons.star_outline_rounded,
  }) {
    return SlScoreInputDialogContent(
      dialogId: dialogId,
      initialValue: initialValue,
      title: title,
      subtitle: subtitle,
      titleIcon: titleIcon,
    );
  }

  /// Factory for a feedback score dialog
  factory SlScoreInputDialogContent.feedback({
    required String dialogId,
    double initialValue = 50.0,
    String title = 'Provide Feedback',
    String? subtitle = 'How would you rate this content?',
  }) {
    return SlScoreInputDialogContent(
      dialogId: dialogId,
      initialValue: initialValue,
      title: title,
      subtitle: subtitle,
      titleIcon: Icons.feedback_outlined,
      confirmText: 'Submit Feedback',
    );
  }

  /// Factory for a quiz/test score input
  factory SlScoreInputDialogContent.assessment({
    required String dialogId,
    double initialValue = 0.0,
    double maxValue = 100.0,
    String title = 'Input Test Score',
    String? subtitle = 'Move the slider to set the score',
  }) {
    return SlScoreInputDialogContent(
      dialogId: dialogId,
      initialValue: initialValue,
      maxValue: maxValue,
      title: title,
      subtitle: subtitle,
      titleIcon: Icons.school_outlined,
      confirmText: 'Record Score',
    );
  }

  /// Get the color for the score based on its value
  Color _getScoreColor(
    ColorScheme colorScheme,
    BuildContext context,
    double score,
  ) {
    final percentage = (score - minValue) / (maxValue - minValue);

    // Using Theme extension if available, otherwise direct colors
    final theme = Theme.of(context);
    if (theme.extension<SemanticColorExtension>() != null) {
      return theme.getScoreColor(score);
    }

    // Fallback to direct colors
    if (percentage >= 0.9) {
      return colorScheme.primary;
    }
    if (percentage >= 0.7) return colorScheme.tertiary;
    if (percentage >= 0.5) return colorScheme.secondary;
    if (percentage >= 0.3) return Colors.orange.shade700;
    return colorScheme.error;
  }

  Color _getContrastTextColor(Color backgroundColor, ColorScheme colorScheme) {
    return backgroundColor.computeLuminance() > 0.5
        ? colorScheme.onSurface
        : colorScheme.surface;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Initialize the provider with initial value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(
            scoreValueProvider(dialogId, initialValue: initialValue).notifier,
          )
          .setScore(initialValue.clamp(minValue, maxValue));
    });

    // Watch the score value from provider
    final scoreValue = ref.watch(
      scoreValueProvider(dialogId, initialValue: initialValue),
    );

    final scoreColor = _getScoreColor(colorScheme, context, scoreValue);
    final scoreDisplayBackgroundColor = scoreColor.withOpacity(0.1);
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
            if (titleIcon != null) ...[
              Icon(
                titleIcon,
                color: colorScheme.primary,
                size: AppDimens.iconL,
              ),
              const SizedBox(width: AppDimens.spaceS),
            ],
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppDimens.spaceXL),
        Container(
          width: AppDimens.iconXXXL * 1.8,
          height: AppDimens.iconXXXL * 1.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scoreDisplayBackgroundColor,
            border: Border.all(color: scoreColor.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: scoreColor.withOpacity(0.2),
                blurRadius: AppDimens.shadowRadiusM,
                spreadRadius: AppDimens.shadowOffsetS,
              ),
            ],
          ),
          child: Center(
            child: Text(
              scoreValue.round().toString(),
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
            inactiveTrackColor: scoreColor.withOpacity(0.25),
            thumbColor: scoreColor,
            overlayColor: scoreColor.withOpacity(0.15),
            trackHeight: AppDimens.lineProgressHeightL,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: AppDimens.radiusM,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: AppDimens.paddingXL,
            ),
            valueIndicatorColor: colorScheme.primaryContainer,
            valueIndicatorTextStyle: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          ),
          child: Slider(
            value: scoreValue,
            min: minValue,
            max: maxValue,
            divisions: divisions,
            label: '${scoreValue.round()}',
            onChanged: (value) {
              ref
                  .read(
                    scoreValueProvider(
                      dialogId,
                      initialValue: initialValue,
                    ).notifier,
                  )
                  .setScore(value);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minValue.round().toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                maxValue.round().toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spaceXL),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SlButton(
              text: cancelText,
              onPressed: () => Navigator.of(context).pop(),
              variant: SlButtonVariant.text,
            ),
            const SizedBox(width: AppDimens.spaceM),
            SlButton(
              text: confirmText,
              onPressed: () => Navigator.of(context).pop(scoreValue),
              variant: SlButtonVariant.filled,
              backgroundColor: scoreColor,
              foregroundColor: _getContrastTextColor(scoreColor, colorScheme),
            ),
          ],
        ),
      ],
    );
  }

  /// Shows a dialog with a score input slider
  static Future<double?> show(
    BuildContext context,
    WidgetRef ref, {
    required String dialogId,
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
    // Initialize the provider
    ref
        .read(scoreValueProvider(dialogId, initialValue: initialValue).notifier)
        .setScore(initialValue.clamp(minValue, maxValue));

    return showDialog<double>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          ),
          backgroundColor: Theme.of(
            dialogContext,
          ).colorScheme.surfaceContainerLowest,
          surfaceTintColor: Theme.of(dialogContext).colorScheme.surfaceTint,
          content: SlScoreInputDialogContent(
            dialogId: dialogId,
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
          contentPadding: const EdgeInsets.all(AppDimens.paddingXL),
        );
      },
    );
  }
}
