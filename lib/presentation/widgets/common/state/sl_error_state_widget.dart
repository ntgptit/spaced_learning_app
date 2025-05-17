// lib/presentation/widgets/common/state/sl_error_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';

class SlErrorStateWidget extends ConsumerWidget {
  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryText;
  final bool compact;
  final Color? accentColor;
  final Widget? customAction;

  const SlErrorStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryText,
    this.compact = false,
    this.accentColor,
    this.customAction,
  });

  // Factory constructor for network errors
  factory SlErrorStateWidget.network({
    VoidCallback? onRetry,
    bool compact = false,
    String? message,
  }) {
    return SlErrorStateWidget(
      title: 'Network Error',
      message:
          message ??
          'Failed to connect. Please check your connection and try again.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      retryText: 'Try Again',
      compact: compact,
    );
  }

  // Factory constructor for server errors
  factory SlErrorStateWidget.serverError({
    String? details,
    VoidCallback? onRetry,
    bool compact = false,
  }) {
    return SlErrorStateWidget(
      title: 'Server Error',
      message:
          details ??
          'Something went wrong on our end. We\'re working to fix it.',
      icon: Icons.cloud_off_rounded,
      onRetry: onRetry,
      retryText: 'Try Again',
      compact: compact,
    );
  }

  // Factory constructor for custom errors
  factory SlErrorStateWidget.custom({
    required String title,
    String? message,
    IconData icon = Icons.error_outline,
    VoidCallback? onRetry,
    String? retryText = 'Try Again',
    bool compact = false,
    Color? accentColor,
    Widget? customAction,
  }) {
    return SlErrorStateWidget(
      title: title,
      message: message,
      icon: icon,
      onRetry: onRetry,
      retryText: retryText,
      compact: compact,
      accentColor: accentColor,
      customAction: customAction,
    );
  }

  Color _getContrastColor(Color backgroundColor, ColorScheme colorScheme) {
    return backgroundColor.computeLuminance() > 0.5
        ? colorScheme.onSurface
        : colorScheme.surface;
  }

  Widget _buildFullError(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color errorColor,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimens.iconXXL,
              height: AppDimens.iconXXL,
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppDimens.iconXL, color: errorColor),
            ),
            const SizedBox(height: AppDimens.spaceXL),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              // Continuing from lib/presentation/widgets/common/state/sl_error_state_widget.dart
              const SizedBox(height: AppDimens.spaceM),
              Text(
                message!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppDimens.spaceXL),
              SlButton(
                text: retryText ?? 'Try Again',
                onPressed: onRetry,
                variant: SlButtonVariant.filled,
                backgroundColor: errorColor,
                foregroundColor: _getContrastColor(errorColor, colorScheme),
                prefixIcon: Icons.refresh,
              ),
            ],
            if (customAction != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              customAction!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactError(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color errorColor,
  ) {
    return Card(
      color: errorColor.withOpacity(0.08),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: errorColor.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            Icon(icon, color: errorColor, size: AppDimens.iconM),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      message!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: errorColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(retryText ?? 'Retry'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final errorColor = accentColor ?? colorScheme.error;

    if (compact) {
      return _buildCompactError(context, theme, colorScheme, errorColor);
    }
    return _buildFullError(context, theme, colorScheme, errorColor);
  }
}
