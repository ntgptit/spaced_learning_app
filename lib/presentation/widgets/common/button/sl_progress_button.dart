// lib/presentation/widgets/common/button/sl_progress_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sl_button_base.dart'; // Ensure this path points to your SlButtonBase file
// which includes the @riverpod ButtonState provider.

class SlProgressButton extends ConsumerWidget {
  final String text;

  /// Asynchronous function executed on press.
  /// SlProgressButton automatically manages loading state for the `loadingId`.
  final Future<void> Function()? onPressed;

  /// Unique ID to link with `buttonStateProvider` (defined in SlButtonBase)
  /// for loading state management.
  final String loadingId;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isFullWidth;
  final SlButtonSize size;
  final SlButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;

  // You can add other SlButtonBase props here if needed,
  // e.g., borderRadius, padding, elevation, borderSide

  const SlProgressButton({
    super.key,
    required this.text,
    required this.loadingId,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.isFullWidth = false,
    this.size = SlButtonSize.medium,
    this.variant = SlButtonVariant.filled,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // SlButtonBase automatically tracks the loading state from buttonStateProvider
    // (which is an annotated Riverpod provider) via the passed loadingId.

    return SlButtonBase(
      text: text,
      loadingId: loadingId,
      onPressed: onPressed == null
          ? null
          : () async {
              // If onPressed is provided, SlProgressButton manages the loading state.
              final notifier = ref.read(
                buttonStateProvider(id: loadingId).notifier,
              );
              try {
                // Check if the widget is still mounted (provider exists) before updating state.
                if (!ref.exists(buttonStateProvider(id: loadingId))) return;
                notifier.setLoading(true);

                await onPressed!();
              } catch (e) {
                // Optionally log the error or handle it based on your app's needs.
                // For example: debugPrint("Error in SlProgressButton: $e");
                rethrow; // Rethrow to allow the caller to handle it if necessary.
              } finally {
                // Ensure setLoading(false) is called, even if an error occurred
                // or if the widget was disposed during the async operation.
                if (ref.exists(buttonStateProvider(id: loadingId))) {
                  notifier.setLoading(false);
                }
              }
            },
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isFullWidth: isFullWidth,
      size: size,
      variant: variant,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      // Pass through other SlButtonBase props if you added them.
    );
  }
}
