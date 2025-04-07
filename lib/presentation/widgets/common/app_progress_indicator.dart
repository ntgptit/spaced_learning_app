import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum ProgressType { linear, circular }

class AppProgressIndicator extends StatefulWidget {
  final ProgressType type;
  final double? value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? child;
  final String? label;
  final TextStyle? labelStyle;
  final bool animate;
  final Duration animationDuration;

  const AppProgressIndicator({
    super.key,
    this.type = ProgressType.circular,
    this.value,
    this.size = AppDimens.circularProgressSizeL,
    this.strokeWidth = AppDimens.lineProgressHeight,
    this.color,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.label,
    this.labelStyle,
    this.animate = false,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<AppProgressIndicator> createState() => _AppProgressIndicatorState();
}

class _AppProgressIndicatorState extends State<AppProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      _animationController = AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      );

      _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.animate) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveForegroundColor =
        widget.foregroundColor ?? widget.color ?? colorScheme.primary;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? colorScheme.surfaceContainerHighest;

    Widget progressIndicator;

    switch (widget.type) {
      case ProgressType.linear:
        progressIndicator =
            widget.animate
                ? _buildAnimatedLinearProgress(
                  effectiveForegroundColor,
                  effectiveBackgroundColor,
                )
                : LinearProgressIndicator(
                  value: widget.value,
                  backgroundColor: effectiveBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    effectiveForegroundColor,
                  ),
                  minHeight: widget.strokeWidth,
                  borderRadius: BorderRadius.circular(widget.strokeWidth / 2),
                );
        break;
      case ProgressType.circular:
        Widget circularProgress = SizedBox(
          width: widget.size,
          height: widget.size,
          child: CircularProgressIndicator(
            value: widget.value,
            backgroundColor: effectiveBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
            strokeWidth: widget.strokeWidth,
          ),
        );

        if (widget.child != null) {
          circularProgress = Stack(
            alignment: Alignment.center,
            children: [circularProgress, widget.child!],
          );
        }

        progressIndicator =
            widget.animate
                ? _buildAnimatedCircularProgress(circularProgress)
                : circularProgress;
        break;
    }

    if (widget.label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          progressIndicator,
          const SizedBox(height: AppDimens.spaceS),
          Text(
            widget.label!,
            style:
                widget.labelStyle ??
                theme.textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return progressIndicator;
  }

  Widget _buildAnimatedLinearProgress(
    Color foregroundColor,
    Color backgroundColor,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: LinearProgressIndicator(
            value: widget.value,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              foregroundColor.withValues(alpha: _fadeAnimation.value),
            ),
            minHeight: widget.strokeWidth,
            borderRadius: BorderRadius.circular(widget.strokeWidth / 2),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCircularProgress(Widget circularProgress) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
      child: circularProgress,
    );
  }
}
