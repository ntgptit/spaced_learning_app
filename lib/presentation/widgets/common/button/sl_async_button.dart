// lib/presentation/widgets/common/button/sl_async_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button_base.dart';

part 'sl_async_button.g.dart';

typedef AsyncButtonCallback = Future<void> Function();

@riverpod
class AsyncButtonState extends _$AsyncButtonState {
  @override
  bool build({String id = 'default'}) => false;

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

class SlAsyncButton extends ConsumerWidget {
  final String asyncId;
  final String text;
  final String loadingText;
  final AsyncButtonCallback onPressed;
  final IconData? prefixIcon;
  final IconData? loadingIcon;
  final SlButtonVariant variant;
  final SlButtonSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isFullWidth;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const SlAsyncButton({
    super.key,
    required this.asyncId,
    required this.text,
    this.loadingText = 'Loading...',
    required this.onPressed,
    this.prefixIcon,
    this.loadingIcon,
    this.variant = SlButtonVariant.filled,
    this.size = SlButtonSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.isFullWidth = false,
    this.onSuccess,
    this.onError,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(asyncButtonStateProvider(id: asyncId));

    // Handle the async action with loading state
    void handlePress() async {
      if (isLoading) return;

      try {
        ref
            .read(asyncButtonStateProvider(id: asyncId).notifier)
            .setLoading(true);

        await onPressed();

        if (onSuccess != null) {
          onSuccess!();
        }
      } catch (error) {
        if (onError != null) {
          onError!();
        }
      } finally {
        if (context.mounted) {
          ref
              .read(asyncButtonStateProvider(id: asyncId).notifier)
              .setLoading(false);
        }
      }
    }

    return SlButtonBase(
      text: isLoading ? loadingText : text,
      onPressed: handlePress,
      prefixIcon: isLoading ? (loadingIcon ?? Icons.hourglass_top) : prefixIcon,
      isFullWidth: isFullWidth,
      size: size,
      variant: variant,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      loadingId: asyncId,
    );
  }
}
