// lib/presentation/widgets/app_progress_indicator.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum ProgressType { linear, circular }

class AppProgressIndicator extends StatelessWidget {
  final ProgressType type;
  final double? value;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? child;
  final String? label;
  final TextStyle? labelStyle;

  const AppProgressIndicator({
    super.key,
    this.type = ProgressType.circular,
    this.value,
    this.size = AppDimens.circularProgressSizeL,
    this.strokeWidth = AppDimens.lineProgressHeight,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.label,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveForegroundColor = foregroundColor ?? colorScheme.primary;
    final effectiveBackgroundColor =
        backgroundColor ??
        (theme.brightness == Brightness.dark
            ? colorScheme.surface.withOpacity(AppDimens.opacitySemi)
            : colorScheme.primary.withOpacity(AppDimens.opacitySemi));

    Widget progressIndicator;

    switch (type) {
      case ProgressType.linear:
        progressIndicator = LinearProgressIndicator(
          value: value,
          backgroundColor: effectiveBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
          minHeight: strokeWidth,
        );
        break;
      case ProgressType.circular:
        progressIndicator = SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: value,
            backgroundColor: effectiveBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
            strokeWidth: strokeWidth,
          ),
        );
        break;
    }

    if (child != null && type == ProgressType.circular) {
      progressIndicator = Stack(
        alignment: Alignment.center,
        children: [progressIndicator, child!],
      );
    }

    if (label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          progressIndicator,
          const SizedBox(height: AppDimens.spaceS),
          Text(
            label!,
            style:
                labelStyle ??
                theme.textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurface.withOpacity(
                    AppDimens.opacityHigh,
                  ),
                ),
          ),
        ],
      );
    }

    return progressIndicator;
  }
}
