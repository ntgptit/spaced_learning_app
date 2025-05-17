// lib/presentation/widgets/common/dialog/sl_progress_dialog.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart'; // SLLoadingIndicator is here

/// A dialog that shows a loading indicator with an optional message.
/// It can be customized with different indicator types, colors, and a timeout.
class SlProgressDialog extends ConsumerStatefulWidget {
  final String message;
  final bool barrierDismissible;
  final Color? progressColor;
  final Color? backgroundColor;
  final Duration? timeout;
  final VoidCallback? onTimeout;
  final Widget? customProgressWidget;
  final double progressIndicatorSize;
  final LoadingIndicatorType indicatorType;

  const SlProgressDialog({
    super.key,
    this.message = 'Loading...',
    this.barrierDismissible = false,
    this.progressColor,
    this.backgroundColor,
    this.timeout,
    this.onTimeout,
    this.customProgressWidget,
    this.progressIndicatorSize = AppDimens.circularProgressSizeL,
    this.indicatorType = LoadingIndicatorType.threeBounce,
  });

  @override
  ConsumerState<SlProgressDialog> createState() => _SlProgressDialogState();

  /// Show the progress dialog
  static Future<void> show(
    BuildContext context, {
    String message = 'Loading...',
    bool barrierDismissible = false,
    Color? progressColor,
    Color? backgroundColor,
    Duration? timeout,
    VoidCallback? onTimeout,
    Widget? customProgressWidget,
    double progressIndicatorSize = AppDimens.circularProgressSizeL,
    LoadingIndicatorType indicatorType = LoadingIndicatorType.threeBounce,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) => SlProgressDialog(
        message: message,
        barrierDismissible: barrierDismissible,
        progressColor: progressColor,
        backgroundColor: backgroundColor,
        timeout: timeout,
        onTimeout: onTimeout,
        customProgressWidget: customProgressWidget,
        progressIndicatorSize: progressIndicatorSize,
        indicatorType: indicatorType,
      ),
    );
  }

  /// Hide the currently displayed progress dialog
  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /// Factory for a basic loading dialog
  factory SlProgressDialog.loading({
    String message = 'Loading...',
    Duration? timeout,
    VoidCallback? onTimeout,
  }) {
    return SlProgressDialog(
      message: message,
      timeout: timeout,
      onTimeout: onTimeout,
      indicatorType: LoadingIndicatorType.threeBounce,
    );
  }

  /// Factory for a processing dialog with a longer timeout
  factory SlProgressDialog.processing({
    String message = 'Processing...',
    Duration timeout = const Duration(seconds: 30),
    VoidCallback? onTimeout,
  }) {
    return SlProgressDialog(
      message: message,
      timeout: timeout,
      onTimeout: onTimeout,
      indicatorType: LoadingIndicatorType.fadingCircle,
    );
  }

  /// Factory for a saving dialog
  factory SlProgressDialog.saving({
    String message = 'Saving changes...',
    Duration? timeout,
    VoidCallback? onTimeout,
  }) {
    return SlProgressDialog(
      message: message,
      timeout: timeout,
      onTimeout: onTimeout,
      indicatorType: LoadingIndicatorType.pulse,
    );
  }
}

class _SlProgressDialogState extends ConsumerState<SlProgressDialog> {
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    if (widget.timeout != null && widget.onTimeout != null) {
      _timeoutTimer = Timer(widget.timeout!, () {
        if (mounted) {
          Navigator.of(context).pop();
          widget.onTimeout!();
        }
      });
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      backgroundColor: widget.backgroundColor ?? colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      contentPadding: const EdgeInsets.all(AppDimens.paddingXL),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.customProgressWidget ??
              SLLoadingIndicator(
                // Using SLLoadingIndicator from common widgets
                size: widget.progressIndicatorSize,
                color: widget.progressColor ?? colorScheme.primary,
                type: widget.indicatorType,
              ),
          if (widget.message.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceL),
            Text(
              widget.message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
