import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Loading indicator with different sizes and styles
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final LoadingIndicatorType type;

  const AppLoadingIndicator({
    super.key,
    this.size = AppDimens.circularProgressSizeL,
    this.color,
    this.type = LoadingIndicatorType.threeBounce,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.colorScheme.primary;

    switch (type) {
      case LoadingIndicatorType.circle:
        return SpinKitCircle(color: indicatorColor, size: size);
      case LoadingIndicatorType.fadingCircle:
        return SpinKitFadingCircle(color: indicatorColor, size: size);
      case LoadingIndicatorType.pulse:
        return SpinKitPulse(color: indicatorColor, size: size);
      case LoadingIndicatorType.doubleBounce:
        return SpinKitDoubleBounce(color: indicatorColor, size: size);
      case LoadingIndicatorType.wave:
        return SpinKitWave(color: indicatorColor, size: size);
      case LoadingIndicatorType.threeBounce:
        return SpinKitThreeBounce(color: indicatorColor, size: size * 0.4);
    }
  }
}

/// Full screen loading indicator with optional message
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final LoadingIndicatorType type;

  const FullScreenLoading({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
    this.type = LoadingIndicatorType.circle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color:
          backgroundColor ??
          theme.colorScheme.surface.withValues(alpha: AppDimens.opacityHigh),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingIndicator(
              color: indicatorColor,
              type: type,
              size: AppDimens.circularProgressSizeL,
            ),
            if (message != null) ...[
              const SizedBox(height: AppDimens.spaceL),
              Text(
                message!,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading indicator overlay for widgets
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color? color;
  final String? message;
  final LoadingIndicatorType type;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.color,
    this.message,
    this.type = LoadingIndicatorType.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: FullScreenLoading(
              message: message,
              backgroundColor: color,
              type: type,
            ),
          ),
      ],
    );
  }
}

/// Types of loading indicators
enum LoadingIndicatorType {
  circle,
  fadingCircle,
  pulse,
  doubleBounce,
  wave,
  threeBounce,
}
