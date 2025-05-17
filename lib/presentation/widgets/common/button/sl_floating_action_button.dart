// lib/presentation/widgets/common/button/sl_floating_action_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_floating_action_button.g.dart';

enum SlFabSize { small, regular, large, extended }

@riverpod
class FabState extends _$FabState {
  @override
  bool build({String id = 'default'}) => false;

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

class SlFloatingActionButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final SlFabSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? loadingId;

  const SlFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.label,
    this.size = SlFabSize.regular,
    this.backgroundColor,
    this.foregroundColor,
    this.loadingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLoading = loadingId != null
        ? ref.watch(fabStateProvider(id: loadingId!))
        : false;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;

    // For extended FAB
    if (size == SlFabSize.extended && label != null) {
      return FloatingActionButton.extended(
        onPressed: isLoading || onPressed == null ? null : onPressed,
        label: Text(label!),
        icon: isLoading
            ? SizedBox(
                width: AppDimens.iconS,
                height: AppDimens.iconS,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    effectiveForegroundColor,
                  ),
                ),
              )
            : Icon(icon),
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
      );
    }

    // For small, regular, and large FABs
    final Widget content = isLoading
        ? SizedBox(
            width: _getLoadingSize(),
            height: _getLoadingSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                effectiveForegroundColor,
              ),
            ),
          )
        : Icon(icon, size: _getIconSize());

    switch (size) {
      case SlFabSize.small:
        return FloatingActionButton.small(
          onPressed: isLoading || onPressed == null ? null : onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          child: content,
        );
      case SlFabSize.regular:
        return FloatingActionButton(
          onPressed: isLoading || onPressed == null ? null : onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          child: content,
        );
      case SlFabSize.large:
        return FloatingActionButton.large(
          onPressed: isLoading || onPressed == null ? null : onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          child: content,
        );
      case SlFabSize.extended:
        // Fallback for extended FAB without a label
        return FloatingActionButton(
          onPressed: isLoading || onPressed == null ? null : onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          child: content,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case SlFabSize.small:
        return AppDimens.iconM;
      case SlFabSize.regular:
      case SlFabSize.extended:
        return AppDimens.iconL;
      case SlFabSize.large:
        return AppDimens.iconXL;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case SlFabSize.small:
        return AppDimens.iconXS;
      case SlFabSize.regular:
      case SlFabSize.extended:
        return AppDimens.iconS;
      case SlFabSize.large:
        return AppDimens.iconM;
    }
  }
}
