// lib/presentation/widgets/common/states/sl_error_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final errorColor = accentColor ?? colorScheme.error;

    if (compact) {
      return _buildCompactError(theme, colorScheme, errorColor);
    }

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
                color: errorColor.withValues(alpha: 0.1),
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
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingXL,
                    vertical: AppDimens.paddingM,
                  ),
                  backgroundColor: errorColor,
                  foregroundColor: _getContrastColor(errorColor),
                ),
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
    ThemeData theme,
    ColorScheme colorScheme,
    Color errorColor,
  ) {
    return Card(
      color: errorColor.withValues(alpha: 0.08),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: errorColor.withValues(alpha: 0.4)),
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
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(retryText ?? 'Retry'),
              ),
          ],
        ),
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  // Factory constructors
  factory SlErrorStateWidget.network({
    VoidCallback? onRetry,
    bool compact = false,
  }) {
    return SlErrorStateWidget(
      title: 'Network Error',
      message:
          'Failed to connect to the server. Please check your connection and try again.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      compact: compact,
    );
  }

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
      compact: compact,
    );
  }

  factory SlErrorStateWidget.custom({
    required String title,
    String? message,
    IconData icon = Icons.error_outline,
    VoidCallback? onRetry,
    bool compact = false,
    Color? accentColor,
    Widget? customAction,
  }) {
    return SlErrorStateWidget(
      title: title,
      message: message,
      icon: icon,
      onRetry: onRetry,
      compact: compact,
      accentColor: accentColor,
      customAction: customAction,
    );
  }
}
