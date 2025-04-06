import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';

/// Widget to display error messages with optional retry action
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool compact;
  final Color? backgroundColor;
  final Color? textColor;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.compact = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return compact ? _buildCompactView(theme) : _buildFullView(theme);
  }

  /// Builds a compact version of the error display
  Widget _buildCompactView(ThemeData theme) {
    return Card(
      color: backgroundColor ?? AppColors.lightErrorContainer,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            _buildErrorIcon(theme, size: AppDimens.iconM),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor ?? AppColors.lightOnErrorContainer,
                ),
              ),
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(left: AppDimens.paddingM),
                child: AppButton(
                  text: 'Retry',
                  type: AppButtonType.text,
                  onPressed: onRetry,
                  textColor: AppColors.accentOrange,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a full-screen version of the error display
  Widget _buildFullView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildErrorIcon(theme, size: AppDimens.iconXXL),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimaryLight,
              ),
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: AppDimens.paddingXL),
                child: AppButton(
                  text: 'Try Again',
                  type: AppButtonType.outline,
                  prefixIcon: Icons.refresh,
                  onPressed: onRetry,
                  textColor: AppColors.accentOrange,
                  borderColor: AppColors.lightOutline,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the error icon with consistent styling
  Widget _buildErrorIcon(ThemeData theme, {required double size}) {
    return Icon(
      icon ?? Icons.error_outline,
      color: AppColors.lightError,
      size: size,
    );
  }
}

/// Base class for snackbar helpers
abstract class _SnackbarHelper {
  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color? iconColor,
    Color? textColor,
    Duration? duration,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.white,
              size: AppDimens.iconM,
            ),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor ?? AppColors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: action,
      ),
    );
  }
}

/// Snackbar helper for showing error messages
class ErrorSnackbar {
  static void show(BuildContext context, String message, {Duration? duration}) {
    _SnackbarHelper._showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.lightError,
      icon: Icons.error_outline,
      iconColor: AppColors.lightOnError,
      textColor: AppColors.lightOnError,
      duration: duration ?? const Duration(seconds: 4),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: AppColors.lightOnError,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
  }
}

/// Snackbar helper for showing success messages
class SuccessSnackbar {
  static void show(BuildContext context, String message, {Duration? duration}) {
    _SnackbarHelper._showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.successLight,
      icon: Icons.check_circle,
      iconColor: AppColors.onSuccessLight,
      textColor: AppColors.onSuccessLight,
    );
  }
}
