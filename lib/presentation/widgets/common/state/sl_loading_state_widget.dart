// lib/presentation/widgets/common/state/sl_loading_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_loading_state_widget.g.dart';

enum SlLoadingType { circular, pulse, threeBounce, wave, fadingCircle }

enum SlLoadingSize { small, medium, large }

@riverpod
class LoadingState extends _$LoadingState {
  @override
  bool build() => false;

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

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

  // Factory constructor for full-screen loading
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

  // Factory constructor for small loading indicator
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

  // Factory constructor for loading indicator with a message
  factory SlLoadingStateWidget.withMessage(
    String message, {
    SlLoadingType type = SlLoadingType.threeBounce,
    Color? color,
  }) {
    return SlLoadingStateWidget(message: message, type: type, color: color);
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

  Widget _buildLoadingIndicator(double indicatorSize, Color indicatorColor) {
    switch (type) {
      case SlLoadingType.circular:
        return SpinKitCircle(color: indicatorColor, size: indicatorSize);
      case SlLoadingType.pulse:
        return SpinKitPulse(color: indicatorColor, size: indicatorSize);
      case SlLoadingType.threeBounce:
        return FittedBox(
          child: SpinKitThreeBounce(
            color: indicatorColor,
            size: indicatorSize * 0.7,
          ),
        );
      case SlLoadingType.wave:
        return SpinKitWave(color: indicatorColor, size: indicatorSize * 0.8);
      case SlLoadingType.fadingCircle:
        return SpinKitFadingCircle(color: indicatorColor, size: indicatorSize);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final indicatorColor = color ?? colorScheme.primary;

    final double actualIndicatorSize = _getSizeValue();
    final Widget loadingIndicator = _buildLoadingIndicator(
      actualIndicatorSize,
      indicatorColor,
    );

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: actualIndicatorSize,
          height: actualIndicatorSize,
          child: loadingIndicator,
        ),
        if (message != null) ...[
          const SizedBox(height: AppDimens.spaceM),
          Text(
            message!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
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
        backgroundWidget ??
            Container(
              color: colorScheme.surface.withOpacity(AppDimens.opacityHigh),
            ),
        Center(child: content),
        if (dismissible && onDismiss != null)
          Positioned(
            top: AppDimens.paddingXL,
            right: AppDimens.paddingL,
            child: IconButton(
              icon: Icon(Icons.close, color: colorScheme.onSurface),
              onPressed: onDismiss,
              tooltip: 'Dismiss',
            ),
          ),
      ],
    );
  }

  /// Shows a full-screen loading overlay
  static void showFullScreen(
    BuildContext context,
    WidgetRef ref, {
    String? message,
  }) {
    ref.read(loadingStateProvider.notifier).setLoading(true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          SlLoadingStateWidget.fullScreen(message: message, dismissible: false),
    );
  }

  /// Hides any displayed loading overlay
  static void hide(BuildContext context, WidgetRef ref) {
    if (ref.read(loadingStateProvider)) {
      Navigator.of(context, rootNavigator: true).pop();
      ref.read(loadingStateProvider.notifier).setLoading(false);
    }
  }
}
