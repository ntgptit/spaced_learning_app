// lib/presentation/widgets/common/states/sl_loading_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum SlLoadingType { circular, pulse, threeBounce, wave, fadingCircle }

enum SlLoadingSize { small, medium, large }

class SlLoadingStateWidget extends ConsumerWidget {
  final String? message;
  final SlLoadingType type;
  final SlLoadingSize size;
  final Color? color;
  final bool fullScreen;
  final Widget? backgroundWidget;
  final bool dismissible;
  final VoidCallback? onDismiss;

  const SlLoadingStateWidget({
    super.key,
    this.message,
    this.type = SlLoadingType.threeBounce,
    this.size = SlLoadingSize.medium,
    this.color,
    this.fullScreen = false,
    this.backgroundWidget,
    this.dismissible = false,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final indicatorColor = color ?? colorScheme.primary;

    final double sizeValue = _getSizeValue();
    final Widget loadingIndicator = _buildLoadingIndicator(
      sizeValue,
      indicatorColor,
    );

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: sizeValue, height: sizeValue, child: loadingIndicator),
        if (message != null) ...[
          const SizedBox(height: AppDimens.spaceM),
          Text(
            message!,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (!fullScreen) {
      return Center(child: content);
    }

    return Stack(
      children: [
        if (backgroundWidget != null)
          backgroundWidget!
        else
          Container(
            color: colorScheme.surface.withValues(alpha: AppDimens.opacityHigh),
          ),
        Center(child: content),
        if (dismissible && onDismiss != null)
          Positioned(
            top: AppDimens.paddingXL,
            right: AppDimens.paddingL,
            child: IconButton(
              icon: Icon(Icons.close, color: colorScheme.onSurface),
              onPressed: onDismiss,
            ),
          ),
      ],
    );
  }

  double _getSizeValue() {
    switch (size) {
      case SlLoadingSize.small:
        return AppDimens.circularProgressSize;
      case SlLoadingSize.medium:
        return AppDimens.circularProgressSizeL;
      case SlLoadingSize.large:
        return AppDimens.iconXXL;
    }
  }

  Widget _buildLoadingIndicator(double size, Color color) {
    switch (type) {
      case SlLoadingType.circular:
        return SpinKitCircle(color: color, size: size);
      case SlLoadingType.pulse:
        return SpinKitPulse(color: color, size: size);
      case SlLoadingType.threeBounce:
        return SpinKitThreeBounce(color: color, size: size * 0.4);
      case SlLoadingType.wave:
        return SpinKitWave(color: color, size: size * 0.5);
      case SlLoadingType.fadingCircle:
        return SpinKitFadingCircle(color: color, size: size);
    }
  }

  // Utility constructors
  factory SlLoadingStateWidget.fullScreen({
    String? message,
    Color? color,
    SlLoadingType type = SlLoadingType.fadingCircle,
    Widget? background,
    bool dismissible = false,
    VoidCallback? onDismiss,
  }) {
    return SlLoadingStateWidget(
      message: message,
      type: type,
      size: SlLoadingSize.large,
      color: color,
      fullScreen: true,
      backgroundWidget: background,
      dismissible: dismissible,
      onDismiss: onDismiss,
    );
  }

  factory SlLoadingStateWidget.small({
    Color? color,
    SlLoadingType type = SlLoadingType.threeBounce,
  }) {
    return SlLoadingStateWidget(
      size: SlLoadingSize.small,
      type: type,
      color: color,
    );
  }

  factory SlLoadingStateWidget.withMessage(
    String message, {
    SlLoadingType type = SlLoadingType.threeBounce,
    Color? color,
  }) {
    return SlLoadingStateWidget(message: message, type: type, color: color);
  }
}
