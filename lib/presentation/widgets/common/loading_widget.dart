import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/presentation/widgets/animations/scale_animation_widget.dart';

/// Enum representing different loading states
enum LoadingFlag { loading, error, success, empty, idle }

/// A versatile loading widget that handles different states of loading,
/// error, success, and empty states with appropriate visual feedback.
///
/// Inspired by the todo list app's loading widgets with enhanced styling.
class LoadingWidget extends StatelessWidget {
  final Color? progressColor;
  final Color? textColor;
  final double? textSize;
  final String? loadingText;
  final String? emptyText;
  final String? errorText;
  final String? idleText;
  final LoadingFlag flag;
  final VoidCallback? errorCallBack;
  final Widget? successWidget;
  final double size;
  final bool animate;

  const LoadingWidget({
    super.key,
    this.progressColor,
    this.textColor,
    this.textSize,
    this.loadingText,
    this.flag = LoadingFlag.loading,
    this.errorCallBack,
    this.emptyText,
    this.errorText,
    this.size = 100,
    this.successWidget,
    this.idleText,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    final effectiveColor = progressColor ?? primaryColor;
    final effectiveTextColor = textColor ?? effectiveColor;

    switch (flag) {
      case LoadingFlag.loading:
        return _buildLoadingState(context, effectiveColor, effectiveTextColor);

      case LoadingFlag.error:
        return _buildErrorState(context, effectiveColor, effectiveTextColor);

      case LoadingFlag.success:
        return successWidget ?? const SizedBox();

      case LoadingFlag.empty:
        return _buildEmptyState(context, effectiveColor, effectiveTextColor);

      case LoadingFlag.idle:
        return _buildIdleState(context, effectiveColor, effectiveTextColor);
    }
  }

  Widget _buildLoadingState(
    BuildContext context,
    Color effectiveColor,
    Color effectiveTextColor,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (animate)
            ScaleAnimationWidget(
              minScale: 0.9,
              maxScale: 1.1,
              duration: const Duration(seconds: 1),
              child: _buildProgressIndicator(effectiveColor),
            )
          else
            _buildProgressIndicator(effectiveColor),

          SizedBox(height: size / 5),

          Text(
            loadingText ?? 'Loading...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textSize ?? size / 5,
              color: effectiveTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(Color color) {
    return SizedBox(
      height: size / 2,
      width: size / 2,
      child: CircularProgressIndicator(
        strokeWidth: size / 10,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    Color effectiveColor,
    Color effectiveTextColor,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.lightError, size: size),

          TextButton.icon(
            onPressed: errorCallBack ?? () {},
            icon: Icon(Icons.refresh, color: effectiveTextColor),
            label: Text(
              errorText?.isNotEmpty == true ? errorText! : 'Retry',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: textSize ?? size / 5,
                color: effectiveTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    Color effectiveColor,
    Color effectiveTextColor,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            color: effectiveColor.withOpacity(0.7),
            size: size,
          ),

          SizedBox(height: size / 6),

          Text(
            emptyText ?? 'No data available',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textSize ?? size / 5,
              color: effectiveTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdleState(
    BuildContext context,
    Color effectiveColor,
    Color effectiveTextColor,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            color: effectiveColor.withOpacity(0.7),
            size: size,
          ),

          SizedBox(height: size / 6),

          Text(
            idleText ?? 'Ready when you are',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textSize ?? size / 5,
              color: effectiveTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// A loading overlay that shows a loading indicator on top of content
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color? backgroundColor;
  final Color? loadingColor;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.backgroundColor,
    this.loadingColor,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color:
                  backgroundColor ??
                  (isDark
                      ? Colors.black.withOpacity(0.7)
                      : Colors.white.withOpacity(0.7)),
              child: Center(
                child: LoadingWidget(
                  loadingText: message,
                  progressColor: loadingColor ?? theme.colorScheme.primary,
                  size: 80,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
